#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from std_msgs.msg import String


class CmdVelStateMux(Node):
    def __init__(self):
        super().__init__('cmd_vel_state_mux')

        # Internal state - updated from /navigation/mode
        self.internal_state = 'IDLE'

        self.cmd_vel = Twist()
        self.cmd_vel_cone = Twist()

        self.create_subscription(
            Twist, '/cmd_vel', self.cmd_vel_cb, 10
        )
        self.create_subscription(
            Twist, '/cmd_vel_cone', self.cmd_vel_cone_cb, 10
        )
        
        # Subscribe to navigation mode from coordinate_follower_node
        self.create_subscription(
            String, '/navigation/mode', self.nav_mode_cb, 10
        )

        self.pub = self.create_publisher(
            Twist, '/cmd_vel_true', 10
        )

        # Fixed-rate publishing
        self.create_timer(0.02, self.publish_cmd)  # 50 Hz
        
        self.get_logger().info('CmdVelStateMux started, listening to /navigation/mode')

    def cmd_vel_cb(self, msg):
        self.cmd_vel = msg

    def cmd_vel_cone_cb(self, msg):
        self.cmd_vel_cone = msg

    def nav_mode_cb(self, msg):
        """Update internal state based on navigation mode from coordinate_follower"""
        mode = msg.data.upper().strip()
        
        if mode == 'NAV2':
            self.internal_state = 'NAV2_NAVIGATING'
        elif mode == 'CONE':
            self.internal_state = 'CONE_NAVIGATING'
        else:  # IDLE or anything else
            self.internal_state = 'IDLE'
        
        self.get_logger().info(f'Navigation mode changed to: {self.internal_state}')

    def publish_cmd(self):
        out = Twist()  # default = STOP

        if self.internal_state == 'NAV2_NAVIGATING':
            out = self.cmd_vel

        elif self.internal_state == 'CONE_NAVIGATING':
            out = self.cmd_vel_cone

        # else: publish zero Twist (stop)

        self.pub.publish(out)


def main():
    rclpy.init()
    node = CmdVelStateMux()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
