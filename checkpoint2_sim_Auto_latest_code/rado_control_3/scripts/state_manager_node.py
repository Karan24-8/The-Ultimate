#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_msgs.msg import String, Bool
from geometry_msgs.msg import Twist

class StateManager(Node):
    def __init__(self):
        super().__init__('state_manager')
        self.state = 'IDLE' # Default to IDLE
        self.navigation_state= 'IDLE'
        # Publisher to inform other nodes of the current state
        self.state_pub = self.create_publisher(String, '/system/state', 10)
        
        # Subscribers for state logic
        self.cmd_sub = self.create_subscription(String, '/sys/command', self.cmd_callback, 10)
        self.create_subscription(Bool, '/auto/task_complete', self.task_complete_callback, 10)

        self.nav_mode_sub = self.create_subscription(
            String, '/navigation/mode', self.change_navigation, 10
        )

        self.nav2_vel = Twist()
        self.nav2_vel_subscriber = self.create_subscription(Twist , '/cmd_vel' , self.get_nav2_vel , 10)
        
        self.cone_vel = Twist()
        self.cone_vel_subscriber = self.create_subscription(Twist , '/cmd_vel_cone' , self.get_cone_vel , 10)

        self.vel_final_pub = self.create_publisher(Twist, '/cmd_vel_final', 10)

        
        # The main loop for publishing state and motor commands
        self.timer = self.create_timer(0.1, self.control_loop) # 10Hz
        self.get_logger().info('State Manager (with Mux Logic) is running.')


    def get_nav2_vel(self, msg):
        self.nav2_vel = msg

    def get_cone_vel(self, msg):
        self.cone_vel = msg

    def change_navigation(self, msg):
        self.get_logger().info(f"Switching mode to: {msg.data}")
        self.navigation_state = msg.data



    def cmd_callback(self, msg):
        cmd = msg.data
        if cmd == 'init_drive':
            self.state = "MANUAL"
            self.get_logger().info("System Initialized: Switched to MANUAL state")
        elif cmd == 'manual_mode':
            self.state = "MANUAL"
            self.get_logger().info("Switched to MANUAL state")
        elif cmd == 'auto_mode' or cmd == 'PROCEED':
            self.state = "AUTONOMOUS"
            self.get_logger().info("Switched to AUTONOMOUS state")
        elif cmd == 'task_complete' or cmd == 'MANUAL':
            self.state = "MANUAL"
            self.get_logger().info("Task Complete: Switching to MANUAL")

    def task_complete_callback(self, msg):
        if msg.data:
            self.state = "MANUAL"
            self.get_logger().info("Auto Task Complete -> Manual")

    def control_loop(self):
        """Publishes state."""
        # 1. Publish the current state for the GCS to read
        state_msg = String()
        state_msg.data = self.state
        self.state_pub.publish(state_msg)

        final_twist = Twist()

        if self.state == 'NAV2':
            final_twist = self.nav2_vel
            
        elif self.state == 'CONE':
            final_twist = self.cone_vel
            
        elif self.state == 'IDLE':
            final_twist = Twist()
            
        self.vel_final_pub.publish(final_twist)

def main(args=None):
    rclpy.init(args=args)
    node = StateManager()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
