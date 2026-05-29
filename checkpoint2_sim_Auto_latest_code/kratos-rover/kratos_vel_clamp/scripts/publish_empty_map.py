#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from nav_msgs.msg import OccupancyGrid
from rclpy.qos import QoSProfile, DurabilityPolicy

from geometry_msgs.msg import TransformStamped
from tf2_ros.static_transform_broadcaster import StaticTransformBroadcaster

class EmptyMapPublisher(Node):
    def __init__(self):
        super().__init__('empty_map_publisher')

        # Latched QoS (required by Nav2)
        qos_profile = QoSProfile(depth=1)
        qos_profile.durability = DurabilityPolicy.TRANSIENT_LOCAL

        self.map_pub = self.create_publisher(
            OccupancyGrid, 'map', qos_profile
        )

        # Static TF broadcaster for map -> odom
        self.tf_broadcaster = StaticTransformBroadcaster(self)

        # Publish map once
        self.timer = self.create_timer(0.5, self.publish_map_and_tf)

        self.get_logger().info('Publishing empty map and map->odom TF')

    def publish_map_and_tf(self):
        # -------- Publish OccupancyGrid --------
        msg = OccupancyGrid()
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.header.frame_id = 'map'

        msg.info.resolution = 0.05
        msg.info.width = 2000     # 100 m
        msg.info.height = 2000

        msg.info.origin.position.x = -50.0
        msg.info.origin.position.y = -50.0
        msg.info.origin.position.z = 0.0
        msg.info.origin.orientation.w = 1.0

        msg.data = [0] * (msg.info.width * msg.info.height)

        self.map_pub.publish(msg)

        # -------- Publish map -> odom TF --------
        tf = TransformStamped()
        tf.header.stamp = self.get_clock().now().to_msg()
        tf.header.frame_id = 'map'
        tf.child_frame_id = 'odom'

        tf.transform.translation.x = 0.0
        tf.transform.translation.y = 0.0
        tf.transform.translation.z = 0.0
        tf.transform.rotation.w = 1.0

        self.tf_broadcaster.sendTransform(tf)

        self.get_logger().info('Map and TF published')

        # Publish once
        self.timer.cancel()

def main(args=None):
    rclpy.init(args=args)
    node = EmptyMapPublisher()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
