#!/usr/bin/env python3
"""
Mission Manager with Nav2 Integration
Converts GPS waypoints to map coordinates and sends goals to Nav2
Falls back to cone following for final approach
"""
import rclpy
from rclpy.node import Node
from rclpy.action import ActionClient
from rclpy.duration import Duration
from std_msgs.msg import String, Float64
from geometry_msgs.msg import PoseStamped
from sensor_msgs.msg import NavSatFix
from nav2_msgs.action import NavigateToPose
from tf2_ros import Buffer, TransformListener, LookupException, ConnectivityException, ExtrapolationException
import os
import time
import math
from pathlib import Path
from rclpy.qos import QoSProfile, ReliabilityPolicy, HistoryPolicy
from cone_msgs.action import FollowCone
class MissionManager(Node):
    def __init__(self):
        super().__init__('mission_manager')

        # Parameters
        self.declare_parameter('map_frame', 'map')
        self.declare_parameter('base_frame', 'base_link')
        
        self.map_frame = self.get_parameter('map_frame').value
        self.base_frame = self.get_parameter('base_frame').value

        # State machine
        self.internal_state = 'WAITING_FOR_AUTONOMOUS'
        
        # Goal queue: {0: goal_dict, 1: goal_dict}
        self.goal_queue = {}
        self.current_goal_index = 0
        self.current_goal = None
        
        
        # Navigation State (robot position in map frame)
        self.current_x = 0.0
        self.current_y = 0.0
        self.current_heading = 0.0
        
        # --- TUNING PARAMETERS ---
        self.cone_switch_distance = 3  # Meters - when to switch from Nav2 to cone following
        self.nav2_goal_tolerance = 2.0   # Nav2 goal tolerance
        self.nav2_timeout = 300.0        # Nav2 navigation timeout (seconds)
        # -------------------------

        # Path Setup - use rado_control_3 directly (Orin structure)
        home = str(Path.home())
        self.mission_file_path = os.path.join(
            home, 'ros2_ws/src/rado_control_3/config/mission_plan.txt'
        )

        # TF2 Setup
        self.tf_buffer = Buffer()
        self.tf_listener = TransformListener(self.tf_buffer, self)

        # Publishers
        # Cone following action client
        self.cone_action_client = ActionClient(self, FollowCone, 'cone_follow')
        # Publisher to notify GUI of mission progress
        self.mission_status_pub = self.create_publisher(
            String, '/mission/status', 10
        )
        # Publisher for navigation mode (for velocity mux in state_manager)
        self.nav_mode_pub = self.create_publisher(
            String, '/navigation/mode', 10
        )

        self.change_mode = self.create_publisher(
            String, '/sys/command', 10
        )



        # Subscribers
        self.create_subscription(
            String, '/system/state', self.state_callback, 10
        )
        self.create_subscription(
            String, '/sys/command', self.gcs_command_callback, 10
        )
        self.create_subscription(
            String, '/auto/cone_follow/status', self.cone_status_callback, 10
        )
        # Subscribe to GUI goal selection
        self.create_subscription(
            String, '/mission/set_goal', self.set_goal_callback, 10
        )

        # Nav2 Action Client
        self.nav2_client = ActionClient(self, NavigateToPose, 'navigate_to_pose')
        self.nav2_goal_handle = None

        # Timer
        self.timer = self.create_timer(0.2, self.control_loop)
        
        # Load mission and wait for Nav2

        self.internal_state = 'WAITING_FOR_PROCEED'
        
        self.get_logger().info('Mission Manager (Nav2 Integrated) Initialized.')
        self.get_logger().info(f'Loaded(self.current_goal) mission goal.')
        
        # Wait for Nav2 action server
        self.create_timer(1.0, self.check_nav2_ready)

    def check_nav2_ready(self)  :
        """Check if Nav2 action server is available"""
        if not self.nav2_client.server_is_ready():
            self.get_logger().info('Waiting for Nav2 action server...', throttle_duration_sec=5)
        else:
            self.get_logger().info('Nav2 action server is ready!')

    def gcs_command_callback(self, msg):
        """Handle commands from ground control station"""
        command = msg.data.upper().strip()
        
        if command == 'PROCEED':
            if self.internal_state == 'WAITING_FOR_PROCEED':
                # Start processing the mission queue from the beginning
                
                
                # Clean up the queue (remove None entries)
                if self.current_goal:
                    self.internal_state = 'NAV2_NAVIGATING'
                    self.get_logger().info(
                        f"Proceeding to goal: {self.current_goal['type']} "
                        f"{self.current_goal['color']} at ({self.current_goal['x']:.2f}, "
                        f"{self.current_goal['y']:.2f})"
                    )
                    self.send_nav2_goal()
                else:
                    self.get_logger().warn("No goal set.")
        elif command == 'MANUAL':
            self.internal_state = 'WAITING_FOR_PROCEED'
            self.cancel_nav2_goal()
            # Set navigation mode to IDLE
            mode_msg = String()
            mode_msg.data = 'IDLE'
            self.nav_mode_pub.publish(mode_msg)
            # Clear the queue on manual stop
            
            
            self.get_logger().info("Mission stopped. Queue cleared.")
        elif command == 'CANCEL':
            self.cancel_nav2_goal()
            # Set navigation mode to IDLE
            mode_msg = String()
            mode_msg.data = 'IDLE'
            self.nav_mode_pub.publish(mode_msg)
            self.internal_state = 'WAITING_FOR_PROCEED'

    def set_goal_callback(self, msg):
        """Handle goal messages from GUI or command line"""
        self.get_logger().info(f"[DEBUG] Received goal message: '{msg.data}'")
        
        try:
            parts = msg.data.split('|')
            self.get_logger().info(f"[DEBUG] Parsed parts: {parts}, count: {len(parts)}")

            # New QUEUE format: QUEUE|INDEX|type|color|x|y
            if len(parts) == 6 and parts[0].upper() == 'QUEUE':
                index = int(parts[1])
                if index not in [0, 1]:
                    self.get_logger().warn(f"Invalid queue index: {index}. Must be 0 or 1.")
                    return
                
                goal = {
                    'type': parts[2].lower().strip(),
                    'color': parts[3].lower().strip(),
                    'x': float(parts[4]),
                    'y': float(parts[5])
                }
                self.goal_queue[index] = goal
                self.get_logger().info(
                    f"Queue[{index}] set: {goal['type']} {goal['color']} at "
                    f"({goal['x']:.2f}, {goal['y']:.2f})"
                )
                
                # If both goals are set, prepare to start
                if 0 in self.goal_queue and 1 in self.goal_queue:
                    self.current_goal_index = 0
                    self.current_goal = self.goal_queue[0]
                    self.internal_state = 'WAITING_FOR_PROCEED'
                    self.get_logger().info("Both goals queued. Ready to proceed.")
        
            # Legacy GOAL format: GOAL|type|color|x|y
            elif len(parts) == 5 and parts[0].upper() == 'GOAL':
                self.current_goal = {
                    'type': parts[1].lower().strip(),
                    'color': parts[2].lower().strip(),
                    'x': float(parts[3]),
                    'y': float(parts[4])
                }
                self.goal_queue = {}  # Clear queue for legacy mode
                self.current_goal_index = -1  # Indicate legacy mode

                self.get_logger().info(
                    f"✅ GOAL SET: {self.current_goal['type']} "
                    f"{self.current_goal['color']} at "
                    f"({self.current_goal['x']:.2f}, {self.current_goal['y']:.2f})"
                )
                self.get_logger().info(f"[DEBUG] current_goal is now: {self.current_goal}")
                self.get_logger().info(f"[DEBUG] internal_state was: {self.internal_state}")
                
                # If we're waiting for autonomous and now have a goal, start navigating
                if self.internal_state == 'WAITING_FOR_AUTONOMOUS':
                    self.internal_state = 'NAV2_NAVIGATING'
                    self.get_logger().info("Goal received while in AUTONOMOUS - starting navigation!")
                    self.send_nav2_goal()
                else:
                    self.internal_state = 'WAITING_FOR_PROCEED'
                    self.get_logger().info(f"[DEBUG] Changed internal_state to: {self.internal_state}")
            else:
                self.get_logger().warn(f"Invalid goal format: {msg.data}. Expected GOAL|type|color|x|y or QUEUE|index|type|color|x|y")
        except Exception as e:
            self.get_logger().error(f"Failed to parse goal: {e}")
            import traceback
            self.get_logger().error(traceback.format_exc())


    def state_callback(self, msg):
        """Handle rover state changes"""
        state = msg.data.upper().strip()
        
        if state == 'AUTONOMOUS':
            # Only start navigation if we're not already navigating
            if self.internal_state in ['NAV2_NAVIGATING', 'CONE_NAVIGATING']:
                # Already navigating, ignore repeated AUTONOMOUS messages
                return
            
            if self.current_goal:
                # Goal is set, start navigating
                self.internal_state = 'NAV2_NAVIGATING'
                self.get_logger().info(
                    f"AUTONOMOUS received - navigating to {self.current_goal['type']} "
                    f"{self.current_goal['color']} at ({self.current_goal['x']:.2f}, {self.current_goal['y']:.2f})"
                )
                self.send_nav2_goal()
            else:
                # No goal yet, wait for goal to be set
                if self.internal_state != 'WAITING_FOR_AUTONOMOUS':
                    self.internal_state = 'WAITING_FOR_AUTONOMOUS'
                    self.get_logger().info("AUTONOMOUS received - waiting for goal to be set...")
        elif state == 'MANUAL':
            if self.internal_state in ['NAV2_NAVIGATING', 'CONE_NAVIGATING']:
                self.internal_state = 'WAITING_FOR_PROCEED'
                self.cancel_nav2_goal()

    def gps_callback(self, msg):
        """Update current position from TF (map -> base_link)"""
        # GPS callback kept for compatibility, but we now get position from TF
        pass
    
    def update_robot_position(self):
        """Get current robot position from TF (map -> base_link)"""
        try:
            transform = self.tf_buffer.lookup_transform(
                self.map_frame,
                self.base_frame,
                rclpy.time.Time(),
                timeout=Duration(seconds=0.1)
            )
            self.current_x = transform.transform.translation.x
            self.current_y = transform.transform.translation.y
            return True
        except (LookupException, ConnectivityException, ExtrapolationException) as e:
            self.get_logger().warn(
                f'Failed to get robot position from TF: {e}',
                throttle_duration_sec=2
            )
            return False

    def cone_status_callback(self, msg):
        """Handle cone following status updates"""
        if self.internal_state == 'CONE_NAVIGATING' and msg.data == 'SUCCESS':
            self.handle_arrival()

    def send_nav2_goal(self):
        """Send navigation goal to Nav2 using x, y map coordinates directly"""
        if not self.nav2_client.server_is_ready():
            self.get_logger().error('Nav2 action server not available!')
            self.internal_state = 'WAITING_FOR_PROCEED'
            return

        # Get x, y directly from goal (already in map coordinates)
        x = self.current_goal['x']
        y = self.current_goal['y']

        # Create Nav2 goal
        goal_msg = NavigateToPose.Goal()
        goal_msg.pose.header.frame_id = self.map_frame
        goal_msg.pose.header.stamp = self.get_clock().now().to_msg()
        goal_msg.pose.pose.position.x = x
        goal_msg.pose.pose.position.y = y
        goal_msg.pose.pose.position.z = 0.0
        
        # Orientation (quaternion for yaw=0, can be calculated based on approach direction)
        goal_msg.pose.pose.orientation.w = 1.0

        self.get_logger().info(
            f'Sending Nav2 goal to map coords: ({x:.2f}, {y:.2f})'
        )

        # Set navigation mode to NAV2 for velocity mux
        mode_msg = String()
        mode_msg.data = 'NAV2'
        self.nav_mode_pub.publish(mode_msg)
        self.get_logger().info('Navigation mode set to NAV2')

        # Send goal
        send_goal_future = self.nav2_client.send_goal_async(
            goal_msg,
            feedback_callback=self.nav2_feedback_callback
        )
        send_goal_future.add_done_callback(self.nav2_goal_response_callback)

    def nav2_goal_response_callback(self, future):
        """Handle Nav2 goal acceptance/rejection"""
        self.nav2_goal_handle = future.result()
        
        if not self.nav2_goal_handle.accepted:
            self.get_logger().error('Nav2 goal was rejected!')
            self.internal_state = 'WAITING_FOR_PROCEED'
            return

        self.get_logger().info('Nav2 goal accepted, navigating...')
        
        # Get result asynchronously
        result_future = self.nav2_goal_handle.get_result_async()
        result_future.add_done_callback(self.nav2_result_callback)

    def nav2_feedback_callback(self, feedback_msg):
        """Handle Nav2 navigation feedback"""
        feedback = feedback_msg.feedback
        
        # Calculate distance to goal using map coordinates
        if self.current_goal and self.update_robot_position():
            dist = self.get_distance_to_goal(
                self.current_x, self.current_y,
                self.current_goal['x'], self.current_goal['y']
            )
            
            self.get_logger().info(
                f'Nav2 feedback - Distance remaining: {dist:.2f}m',
                throttle_duration_sec=2
            )
            


    def nav2_result_callback(self, future):
        """Handle Nav2 navigation result"""
        result = future.result().result
        status = future.result().status
        
        if status == 4:  # SUCCEEDED
            self.get_logger().info('Nav2 navigation succeeded!')
            
            # Index 0: Switch to cone following for final approach
            if self.current_goal_index == 0:
                self.internal_state = 'CONE_NAVIGATING'
                # Send cone following action goal
                
                self.send_cone_follow_goal()
            
            # Index 1: Nav2 only, no cone following - mission complete
            elif self.current_goal_index == 1:
                self.get_logger().info('Index 1 Nav2 goal complete. Switching to MANUAL.')
                self.handle_mission_complete()
            
            # Legacy mode (single goal): use cone following
            else:
                self.internal_state = 'CONE_NAVIGATING'
                self.send_cone_follow_goal()
                
        elif status == 5:  # CANCELED
            self.get_logger().info('Nav2 navigation was canceled')
        elif status == 6:  # ABORTED
            self.get_logger().info('Nav2 navigation was aborted')
        else:
            self.get_logger().error(f'Nav2 navigation failed with status: {status}')
            self.internal_state = 'WAITING_FOR_PROCEED'

    def cancel_nav2_goal(self):
        """Cancel current Nav2 navigation goal"""
        if self.nav2_goal_handle is not None:
            self.get_logger().info('Canceling Nav2 goal...')
            cancel_future = self.nav2_goal_handle.cancel_goal_async()
            self.nav2_goal_handle = None

    def send_cone_follow_goal(self):
        """Send cone following action goal"""
        if not self.cone_action_client.server_is_ready():
            self.get_logger().warn('Cone follow action server not available, waiting...')
            self.cone_action_client.wait_for_server()
        
        goal_msg = FollowCone.Goal()
        goal_msg.color = self.current_goal['color']
        goal_msg.type = self.current_goal['type']
        
        self.get_logger().info(
            f"Sending cone follow goal: {goal_msg.type.upper()} {goal_msg.color.upper()}"
        )
        
        # Set navigation mode to CONE for velocity mux
        mode_msg = String()
        mode_msg.data = 'CONE'
        self.nav_mode_pub.publish(mode_msg)
        self.get_logger().info('Navigation mode set to CONE')
        
        send_goal_future = self.cone_action_client.send_goal_async(
            goal_msg,
            feedback_callback=self.cone_follow_feedback_callback
        )
        send_goal_future.add_done_callback(self.cone_follow_goal_response_callback)

    def cone_follow_goal_response_callback(self, future):
        """Handle cone follow action goal acceptance/rejection"""
        goal_handle = future.result()
        
        if not goal_handle.accepted:
            self.get_logger().error('Cone follow goal was rejected!')
            self.internal_state = 'WAITING_FOR_PROCEED'
            return
        
        self.get_logger().info('Cone follow goal accepted, executing...')
        
        result_future = goal_handle.get_result_async()
        result_future.add_done_callback(self.cone_follow_result_callback)

    def cone_follow_feedback_callback(self, feedback_msg):
        """Handle cone follow action feedback"""
        feedback = feedback_msg.feedback
        self.get_logger().info(
            f'Cone follow feedback - Distance: {feedback.distance_to_cone:.2f}m, Status: {feedback.status}',
            throttle_duration_sec=2
        )

    def cone_follow_result_callback(self, future):
        """Handle cone follow action result"""
        result = future.result().result
        
        if result.success:
            self.get_logger().info(f'Cone following succeeded: {result.message}')
            self.handle_arrival()
        else:
            self.get_logger().error(f'Cone following failed: {result.message}')
            # IMPORTANT: Clear goal to prevent infinite loop when AUTONOMOUS is still being published
            # Set navigation mode to IDLE
            mode_msg = String()
            mode_msg.data = 'IDLE'
            self.nav_mode_pub.publish(mode_msg)
            self.current_goal = None
            self.internal_state = 'WAITING_FOR_PROCEED'
            self.get_logger().info("Goal cleared due to cone follow failure. Send a new goal to retry.")

    def handle_arrival(self):
        """Called when cone following succeeds for current goal"""
        self.get_logger().info(
            f"Arrived at {self.current_goal['type']} ({self.current_goal['color']})"
        )
        
        # Notify GUI of completion
        status_msg = String()
        status_msg.data = f"COMPLETE|{self.current_goal['type']}"
        self.mission_status_pub.publish(status_msg)
        manual_msg = String()
        manual_msg.data = "MANUAL"
        self.change_mode.publish(manual_msg)
        
        self.get_logger().info(f"{self.current_goal['type'].capitalize()} complete at {self.current_goal['color']}")
        
        # If using queue and just finished index 0, proceed to index 1
        if self.current_goal_index == 0 and 1 in self.goal_queue:
            self.get_logger().info("Index 0 complete. Proceeding to index 1...")
            self.current_goal_index = 1
            self.current_goal = self.goal_queue[1]
            self.internal_state = 'NAV2_NAVIGATING'
            self.send_nav2_goal()
        else:
            # Legacy mode or no more goals - CLEAR GOAL and switch to manual
            self.get_logger().info("Mission complete. Clearing goal and switching to MANUAL mode.")
            # Set navigation mode to IDLE
            mode_msg = String()
            mode_msg.data = 'IDLE'
            self.nav_mode_pub.publish(mode_msg)
            self.current_goal = None
            self.goal_queue = {}
            self.internal_state = 'WAITING_FOR_PROCEED'
    
    def handle_mission_complete(self):
        """Called when entire mission queue is complete (after index 1 Nav2 succeeds)"""
        self.get_logger().info("Mission complete! Both goals reached.")
        
        # Notify GUI
        status_msg = String()
        status_msg.data = f"COMPLETE|{self.current_goal['type']}"
        self.mission_status_pub.publish(status_msg)
        
        # Set navigation mode to IDLE
        mode_msg = String()
        mode_msg.data = 'IDLE'
        self.nav_mode_pub.publish(mode_msg)
        
        # Clear state
        self.goal_queue = {}
        self.current_goal = None
        self.current_goal_index = 0
        self.internal_state = 'WAITING_FOR_PROCEED'
        self.get_logger().info("Switched to MANUAL mode.")



    def get_distance_to_goal(self, x1, y1, x2, y2):
        """Calculate Euclidean distance between two map coordinates"""
        return math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

    def control_loop(self):
        """Main control loop - minimal, most logic is event-driven"""
        # The control loop is now mostly event-driven via callbacks
        # This loop can be used for periodic status checks if needed
        pass


def main(args=None):
    rclpy.init(args=args)
    node = MissionManager()
    
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
