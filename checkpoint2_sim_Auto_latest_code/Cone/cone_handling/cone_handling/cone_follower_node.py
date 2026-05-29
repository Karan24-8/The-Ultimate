#!/usr/bin/env python3
import math
import time
import rclpy
from rclpy.duration import Duration
from rclpy.node import Node
from rclpy.action import ActionServer
from rclpy.executors import MultiThreadedExecutor
from rclpy.qos import QoSProfile, ReliabilityPolicy, HistoryPolicy
from geometry_msgs.msg import Twist
from sensor_msgs.msg import CameraInfo
from cone_msgs.msg import ConeDetectionArray
from std_msgs.msg import String, Float64

from cone_msgs.action import FollowCone

# =========================================================================================
#                                 TUNING CONFIGURATION
# =========================================================================================
CONFIG = {
    # --- SPEEDS ---
    'forward_speed':       0.2,   
    'turn_speed':          0.2,   
    'backup_speed':       -0.2,   

    # --- P-CONTROLLER FOR TURNING ---
    'turn_kp':             0.003,   
    'max_turn_speed':      0.3,    
    'min_turn_speed':      0.1,     

    # --- DISTANCES ---
    'stop_distance':       1.9,    # Stop at this distance from cone
    'max_detection_dist':  50.0,   
    
    # --- 180 TURN CONFIG ---
    'heading_tolerance':   4.0,    # Degrees tolerance for 180 turn completion
    'settle_time':         1.0,    
    'turn_timeout':        20.0,   
    
    # --- ALIGNMENT ---
    'kp':                  0.003,  
    'ki':                  0.0001, 
    'ki_max':              0.1,    
    'alignment_tolerance': 100.0,   # Pixels tolerance for alignment
    'inner_band':          100.0,   
    'outer_band':          300.0,  
    'final_align_tol':     20.0,   
    
    # --- TIMERS ---
    'lost_timeout':        5.0,    
    'grace_period':        1.5,    # <--- UPDATED: Buffer 1.5s before searching
    'data_stale_thresh':   0.2,    # <--- NEW: Data older than 0.2s is considered "stale"
    'backup_duration':     2.5,    
    'catchbox_delay':      3.0,    
    'retry_backoff_dur':   4.0,    
    'stop_settle_time':    0.5,    
}


# =========================================================================================
#                                 GAZEBO CONFIGURATION
# =========================================================================================
GAZEBO_CONFIG = {
    # --- SPEEDS ---
    'forward_speed':       0.4,    # Faster in sim
    'turn_speed':          0.4,    # Faster in sim
    'backup_speed':       -0.3,    
    
    # --- P-CONTROLLER FOR TURNING ---
    'turn_kp':             0.005,  # Stronger P for sim
    'max_turn_speed':      0.5,    
    'min_turn_speed':      0.15,     

    # --- DISTANCES ---
    'stop_distance':       1.5,    # Stop closer
    'max_detection_dist':  50.0,   
    
    # --- 180 TURN CONFIG ---
    'heading_tolerance':   5.0,    
    'settle_time':         0.5,    
    'turn_timeout':        20.0,   
    
    # --- ALIGNMENT ---
    'kp':                  0.005,  # Sharper alignment
    'ki':                  0.0, 
    'ki_max':              0.1,    
    'alignment_tolerance': 50.0,   # Tighter tolerance
    'inner_band':          50.0,   
    'outer_band':          300.0,  
    'final_align_tol':     10.0,   
    
    # --- TIMERS ---
    'lost_timeout':        5.0,    
    'grace_period':        1.0,    
    'data_stale_thresh':   0.2,    
    'backup_duration':     2.0,    
    'catchbox_delay':      2.0,    
    'retry_backoff_dur':   4.0,    
    'stop_settle_time':    0.5,    
}
# =========================================================================================

class ConeFollowerNode(Node):
    
    def __init__(self):
        super().__init__('cone_follower_node')
        
        self.declare_parameter('use_gazebo', False)
        self.use_gazebo = self.get_parameter('use_gazebo').value
        
        mode_str = "GAZEBO SIMULATION" if self.use_gazebo else "REAL LIFE (ZED)"
        print(f"Cone Follower [SAFETY CRITICAL EDITION] - Started | Mode: {mode_str}")

        self.declare_parameter('detection_topic', '/cone_detector/detections')
        self.declare_parameter('camera_info_topic', '/zed/zed_node/left/camera_info') 
        self.declare_parameter('compass_topic', '/mavros/global_position/compass_hdg')
        self.declare_parameter('cmd_vel_topic', '/cmd_vel_cone')
        self.declare_parameter('fallback_image_width', 1280.0)

        # Select Config based on mode
        active_config = GAZEBO_CONFIG if self.use_gazebo else CONFIG
        
        for key, value in active_config.items():
            self.declare_parameter(key, value)

        self.detection_topic = self.get_parameter('detection_topic').value
        self.cam_info_topic = self.get_parameter('camera_info_topic').value
        self.compass_topic = self.get_parameter('compass_topic').value
        self.cmd_vel_topic = self.get_parameter('cmd_vel_topic').value
        self.fallback_width = self.get_parameter('fallback_image_width').value
        
        # Adjust image center based on mode
        if self.use_gazebo:
            self.image_center_x = self.fallback_width / 2.0 
        else:
            self.image_center_x = self.fallback_width / 4.0 # ZED Stereo split
            
        self.camera_info_received = False

        # Load Params
        self.fwd_speed = self.get_parameter('forward_speed').value
        self.turn_speed = self.get_parameter('turn_speed').value
        self.backup_speed = self.get_parameter('backup_speed').value
        self.stop_dist = self.get_parameter('stop_distance').value
        self.max_dist = self.get_parameter('max_detection_dist').value
        
        self.heading_tol = self.get_parameter('heading_tolerance').value
        self.settle_time = self.get_parameter('settle_time').value
        self.turn_timeout = self.get_parameter('turn_timeout').value
        
        self.turn_kp = self.get_parameter('turn_kp').value
        self.max_turn_speed = self.get_parameter('max_turn_speed').value
        self.min_turn_speed = self.get_parameter('min_turn_speed').value

        self.kp = self.get_parameter('kp').value
        self.ki = self.get_parameter('ki').value
        self.ki_max = self.get_parameter('ki_max').value
        self.alignment_tol = self.get_parameter('alignment_tolerance').value
        
        self.inner_band = self.get_parameter('inner_band').value
        self.outer_band = self.get_parameter('outer_band').value
        self.final_tol = self.get_parameter('final_align_tol').value
        
        self.lost_timeout = self.get_parameter('lost_timeout').value
        self.grace_period = self.get_parameter('grace_period').value
        self.data_stale_thresh = self.get_parameter('data_stale_thresh').value # Load new param
        self.backup_dur = self.get_parameter('backup_duration').value
        self.catchbox_wait = self.get_parameter('catchbox_delay').value
        self.retry_backoff = self.get_parameter('retry_backoff_dur').value
        self.stop_settle = self.get_parameter('stop_settle_time').value

        # State machine 
        self.state = 'IDLE'
        self.last_detection = None
        self.last_valid_time = self.get_clock().now()
        self.state_start_time = self.get_clock().now()
        self.integral_error = 0.0
        
        self.current_heading = None
        self.target_heading = None
        self.turn_direction = None 
        self.backup_start_time = None
        
        # Action Server State
        self.goal_handle = None
        self.goal_color = None
        self.goal_type = None
        self.action_active = False

        # Publishers / Subscribers
        self.cmd_pub = self.create_publisher(Twist, '/cmd_vel_cone', 10)
        self.status_pub = self.create_publisher(String, '/auto/cone_follow/status', 10)
        
        self.create_subscription(ConeDetectionArray, self.detection_topic, self.detections_cb, 10)
        self.create_subscription(CameraInfo, self.cam_info_topic, self.camera_info_cb, 10)

        sensor_qos = QoSProfile(
            reliability=ReliabilityPolicy.BEST_EFFORT,
            history=HistoryPolicy.KEEP_LAST,
            depth=10
        )
        self.create_subscription(Float64, self.compass_topic, self.compass_cb, sensor_qos)
        
        self.action_server = ActionServer(
            self, FollowCone, 'cone_follow', self.execute_cone_following
        )

        self.control_timer = self.create_timer(0.05, self.control_loop)
        self.get_logger().info('Cone Follower Action Server initialized')

    # =========================================================================================
    #                               SAFETY & HELPER FUNCTIONS
    # =========================================================================================
    
    def stop_all_motion(self):
        self.get_logger().warn("!!! EMERGENCY STOP TRIGGERED !!!")
        t = Twist()
        for _ in range(20): 
            self.cmd_pub.publish(t)
            time.sleep(0.02)

    def stop_motion(self):
        t = Twist()
        self.cmd_pub.publish(t)

    def normalize_heading(self, heading):
        while heading < 0: heading += 360.0
        while heading >= 360: heading -= 360.0
        return heading

    def heading_diff(self, current, target):
        diff = target - current
        while diff > 180: diff -= 360
        while diff < -180: diff += 360
        return diff

    def get_steering_cmd(self, error, limit_speed=True, use_integral=True):
        if abs(error) < self.final_tol:
            return 0.0
        
        p_out = error * self.kp
        # if use_integral:
        #     self.integral_error += error
        #     clamp = self.ki_max / self.ki
        #     if self.integral_error > clamp: self.integral_error = clamp
        #     if self.integral_error < -clamp: self.integral_error = -clamp
        #     i_out = self.integral_error * self.ki
        i_out = 0.0
        
        angular_vel = p_out + i_out
        if limit_speed:
            angular_vel = max(-self.turn_speed, min(self.turn_speed, angular_vel))
        
        if angular_vel > 0 and angular_vel < self.min_turn_speed:
            angular_vel = self.min_turn_speed
        elif angular_vel < 0 and angular_vel > -self.min_turn_speed:
            angular_vel = -self.min_turn_speed
        
        return angular_vel

    def set_state(self, new_state: str, reason: str = ""):
        if self.state != new_state:
            self.get_logger().warn(f"============== STATE CHANGE ==============")
            self.get_logger().warn(f"  {self.state}  --->  {new_state}")
            self.get_logger().warn(f"  Reason: {reason}")
            self.get_logger().warn(f"==========================================")
            self.state = new_state
            self.state_start_time = self.get_clock().now()
            self.integral_error = 0.0

    # =========================================================================================
    #                               CALLBACKS
    # =========================================================================================
    def camera_info_cb(self, msg: CameraInfo):
        if not self.camera_info_received:
            # Update center from actual camera info if received, respecting mode
            if self.use_gazebo:
                self.image_center_x = msg.width / 2.0
            else:
                self.image_center_x = msg.width / 4.0 # ZED Stereo split
                
            self.camera_info_received = True

    def compass_cb(self, msg: Float64):
        self.current_heading = msg.data

    def detections_cb(self, msg: ConeDetectionArray):
        if not msg.detections: return
        if not self.action_active: return
        
        best = min(msg.detections, key=lambda d: d.distance)
        
        if best.distance > self.max_dist: return
        
        if best.color.lower().strip() != self.goal_color: return
        
        self.last_detection = best
        self.last_valid_time = self.get_clock().now()
        
        if self.state == 'SEARCH':
            self.set_state('STOP_ON_DETECT', reason='target cone found')

    def send_cmd(self, linear, angular):
        t = Twist()
        t.linear.x = float(linear)
        t.angular.z = float(angular)
        self.cmd_pub.publish(t)
        self.get_logger().info(f"🚗 CMD | Lin: {linear:5.2f} | Ang: {angular:5.2f} | State: {self.state}")

    async def execute_cone_following(self, goal_handle):
        self.goal_handle = goal_handle
        self.goal_color = goal_handle.request.color.lower()
        self.goal_type = goal_handle.request.type.lower()
        self.action_active = True
        
        self.get_logger().info(f"Cone Action Started: {self.goal_type} {self.goal_color}")
        self.set_state('SEARCH', reason='Action started')
        feedback_msg = FollowCone.Feedback()
        
        while rclpy.ok() and self.action_active:
            if goal_handle.is_cancel_requested:
                self.stop_all_motion()
                self.action_active = False
                self.state = 'IDLE'
                goal_handle.canceled()
                self.get_logger().info("Goal canceled by client")
                return FollowCone.Result(success=False, message="Canceled")
            
            if self.last_detection:
                feedback_msg.distance_to_cone = self.last_detection.distance
            else:
                feedback_msg.distance_to_cone = float('inf')
            feedback_msg.status = self.state
            goal_handle.publish_feedback(feedback_msg)
            
            if self.state == 'MISSION_COMPLETE':
                self.get_logger().info(f"Cone following completed successfully, ready for next goal")
                goal_handle.succeed()
                return FollowCone.Result(success=True, message="SUCCESS")
            
            time.sleep(0.1)
        
        self.action_active = False
        self.state = 'IDLE'
        goal_handle.abort()
        return FollowCone.Result(success=False, message="Aborted")

    # =========================================================================================
    #                               MAIN CONTROL LOOP
    # =========================================================================================
    def control_loop(self):
        if not self.action_active:
            self.stop_motion()
            return
        
        now = self.get_clock().now()
        time_in_state = (now - self.state_start_time).nanoseconds / 1e9
        time_since_last_detection = (now - self.last_valid_time).nanoseconds / 1e9
        
        # Publish status
        status_msg = String()
        status_msg.data = self.state
        self.status_pub.publish(status_msg)
        
        # ========================== STATE: SEARCH ==========================
        if self.state == 'SEARCH':
            self.send_cmd(0.0, self.turn_speed)
        
        # ========================== STATE: STOP_ON_DETECT ==========================
        elif self.state == 'STOP_ON_DETECT':
            self.send_cmd(0.0, 0.0)
            if time_in_state > self.stop_settle:
                self.set_state('ALIGN', reason='stopped, now aligning to cone')
        
        # ========================== STATE: ALIGN ==========================
        elif self.state == 'ALIGN':
            # --- BUFFER LOGIC START ---
            if time_since_last_detection > self.data_stale_thresh:
                if time_since_last_detection < self.grace_period:
                    # In Buffer Zone: Stop and Wait
                    self.stop_motion()
                    self.get_logger().warn(f"⏳ Buffering... ({time_since_last_detection:.1f}/{self.grace_period}s)", throttle_duration_sec=0.5)
                    return
                else:
                    # Grace Period Expired: Lost Cone
                    self.set_state('SEARCH', reason=f'lost cone align ({time_since_last_detection:.1f}s)')
                    return
            # --- BUFFER LOGIC END ---

            error_x = self.last_detection.cx - self.image_center_x
            if abs(error_x) <= self.alignment_tol:
                self.send_cmd(0.0, 0.0)
                self.set_state('APPROACH', reason=f'aligned (error={error_x:.1f}px)')
            else:
                angular_cmd = self.get_steering_cmd(error_x, use_integral=False)
                self.send_cmd(0.0, angular_cmd)
        
        # ========================== STATE: APPROACH ==========================
        elif self.state == 'APPROACH':
            # --- BUFFER LOGIC START ---
            if time_since_last_detection > self.data_stale_thresh:
                if time_since_last_detection < self.grace_period:
                    # In Buffer Zone: Stop and Wait
                    self.stop_motion()
                    self.get_logger().warn(f"⏳ Buffering... ({time_since_last_detection:.1f}/{self.grace_period}s)", throttle_duration_sec=0.5)
                    return
                else:
                    # Grace Period Expired: Lost Cone
                    self.set_state('SEARCH', reason=f'lost cone approach ({time_since_last_detection:.1f}s)')
                    return
            # --- BUFFER LOGIC END ---

            distance = self.last_detection.distance
            error_x = self.last_detection.cx - self.image_center_x
            
            if distance <= self.stop_dist:
                self.send_cmd(0.0, 0.0)
                self.set_state('STOP_AT_CONE', reason='reached stop distance')
                return
            
            if abs(error_x) > self.outer_band:
                self.send_cmd(0.0, 0.0)
                self.set_state('ALIGN', reason='off-center during approach')
            else:
                angular_cmd = 0.0
                if abs(error_x) > self.alignment_tol:
                    angular_cmd = error_x * self.kp
                    angular_cmd = max(-self.turn_speed, min(self.turn_speed, angular_cmd))
                self.send_cmd(self.fwd_speed, angular_cmd)
        
        # ========================== STATE: STOP_AT_CONE ==========================
        elif self.state == 'STOP_AT_CONE':
            self.send_cmd(0.0, 0.0)
            if time_in_state > self.stop_settle:
                if self.current_heading is not None:
                    self.target_heading = self.normalize_heading(self.current_heading + 180.0)
                    self.turn_direction = -1 
                    self.set_state('TURN_180', reason='starting 180 turn')
                else:
                    self.get_logger().warn("⚠️ No compass heading available!")
        
        # ========================== STATE: TURN_180 ==========================
        elif self.state == 'TURN_180':
            if self.current_heading is None: return
            heading_error = self.heading_diff(self.current_heading, self.target_heading)
            
            if abs(heading_error) <= self.heading_tol:
                self.send_cmd(0.0, 0.0)
                self.backup_start_time = self.get_clock().now()
                self.set_state('BACKUP', reason='180 turn completed')
            elif time_in_state > self.turn_timeout:
                self.send_cmd(0.0, 0.0)
                self.backup_start_time = self.get_clock().now()
                self.set_state('BACKUP', reason='180 turn timeout')
            else:
                turn_speed = min(abs(heading_error) * self.turn_kp * 2.0, self.max_turn_speed)
                turn_speed = max(turn_speed, self.min_turn_speed)
                self.send_cmd(0.0, self.turn_direction * turn_speed)
        
        # ========================== STATE: BACKUP ==========================
        elif self.state == 'BACKUP':
            if self.backup_start_time is None: self.backup_start_time = self.get_clock().now()
            backup_elapsed = (now - self.backup_start_time).nanoseconds / 1e9
            
            if backup_elapsed >= self.backup_dur:
                self.send_cmd(0.0, 0.0)
                self.get_logger().info("✅ Cone following completed - ready for next goal")
                self.set_state('MISSION_COMPLETE', reason='backup complete, goal achieved')
            else:
                self.send_cmd(self.backup_speed, 0.0)
        
        # ========================== STATE: IDLE ==========================
        elif self.state == 'IDLE':
            self.send_cmd(0.0, 0.0)

def main(args=None):
    rclpy.init(args=args)
    node = ConeFollowerNode()
    executor = MultiThreadedExecutor()
    executor.add_node(node)
    
    try:
        executor.spin()
    except KeyboardInterrupt:
        print("\n\n!!! KEYBOARD INTERRUPT DETECTED !!!")
    except Exception as e:
        print(f"CRITICAL ERROR: {e}")
    finally:
        print("INITIATING SAFETY STOP SEQUENCE...")
        node.stop_all_motion()
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()