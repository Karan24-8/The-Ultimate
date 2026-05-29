#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Image
from cone_msgs.msg import ConeDetection, ConeDetectionArray
from cv_bridge import CvBridge
import cv2
import os
from ultralytics import YOLO
import numpy as np

import message_filters
from sensor_msgs.msg import Image

class ConeDetectorNode(Node):
    def __init__(self):
        super().__init__('cone_detector_node')
        
        # ... (Keep your existing params for thresholds/models) ...

        # NEW: Declare depth topic
        self.declare_parameter('depth_topic', '/zed/zed_node/depth/depth_registered')
        self.depth_topic = self.get_parameter('depth_topic').value

        self.image_topic= '/zed/zed_node/left/image_rect_color'
        self.bridge = CvBridge()
        # Model parameters
        self.declare_parameter('model_path', 'models/best.pt')
        self.declare_parameter('confidence', 0.25)
        self.model_path = '/home/supersniper/ros2_ws/src/Cone/cone_detector/cone_detector/models/best.pt'
        self.conf_thresh = float(self.get_parameter('confidence').value)

        # Try loading YOLO model
        try:
            self.get_logger().info(f"Loading YOLO model: {self.model_path}")
            self.model = YOLO(self.model_path)
            # optional: names / palette
            self.names = getattr(self.model, 'names', {})
        except Exception as e:
            self.get_logger().error(f"Failed to load YOLO model: {e}")
            self.model = None

        # ---------------- Utils ----------------
        self.color_ranges = {
            # --- Chromatic Colors ---
            'red': {
                'lower': [np.array([0, 50, 50]), np.array([170, 50, 50])],
                'upper': [np.array([10, 255, 255]), np.array([180, 255, 255])]
            },
            'orange': {
                'lower': np.array([10, 100, 100]),
                'upper': np.array([25, 255, 255])
            },
            'yellow': {
                'lower': np.array([25, 100, 100]),
                'upper': np.array([35, 255, 255])
            },
            'green': {
                'lower': np.array([35, 50, 50]),
                'upper': np.array([85, 255, 255])
            },
            'blue': {
                'lower': np.array([85, 50, 50]),
                'upper': np.array([130, 255, 255])
            },
            'magenta': {
                'lower': np.array([130, 50, 50]),
                'upper': np.array([170, 255, 255])
            }
        }

        # ---------------- ROS I/O CHANGED ----------------
        self.pub_annotated = self.create_publisher(Image, 'cone_detector/annotated_image', 10)
        self.pub_detections = self.create_publisher(ConeDetectionArray, '/cone_detector/detections', 30)

        # REPLACED: Single subscription with Synchronizer
        self.rgb_sub = message_filters.Subscriber(self, Image, self.image_topic)
        self.depth_sub = message_filters.Subscriber(self, Image, self.depth_topic)

        # Syncs messages with matching timestamps (approximate 0.1s slop)
        self.ts = message_filters.ApproximateTimeSynchronizer(
            [self.rgb_sub, self.depth_sub], 10, 0.1
        )
        self.ts.registerCallback(self.image_cb)

        self.get_logger().info("Cone Detector ready (RGB-D Sync Mode).")

    def _check_cuda(self):
        """Check if CUDA is available."""
        try:
            import torch
            return torch.cuda.is_available()
        except ImportError:
            return False

    # -------------------------------------------------------
    def detect_color_in_roi(self, cv_image, x1, y1, x2, y2):
        roi = cv_image[y1:y2, x1:x2]
        if roi.size == 0:
            return "unknown"

        # Ensure BGR before HSV (portable OpenCV)
        if roi.shape[2] == 4:
            roi = cv2.cvtColor(roi, cv2.COLOR_BGRA2BGR)

        hsv = cv2.cvtColor(roi, cv2.COLOR_BGR2HSV)

        max_pixels = 0
        best_color = "unknown"

        for name, ranges in self.color_ranges.items():
            if isinstance(ranges['lower'], list):
                mask1 = cv2.inRange(hsv, ranges['lower'][0], ranges['lower'][1])
                mask2 = cv2.inRange(hsv, ranges['upper'][0], ranges['upper'][1])
                mask = cv2.bitwise_or(mask1, mask2)
            else:
                mask = cv2.inRange(hsv, ranges['lower'], ranges['upper'])

            count = cv2.countNonZero(mask)
            if count > max_pixels:
                max_pixels = count
                best_color = name

        return best_color

    # -------------------------------------------------------
    def image_cb(self, rgb_msg, depth_msg):
        try:
            # Convert RGB
            cv_image = self.bridge.imgmsg_to_cv2(rgb_msg, desired_encoding='passthrough')
            # Convert Depth (32FC1 = 32-bit Float, 1 Channel)
            cv_depth = self.bridge.imgmsg_to_cv2(depth_msg, desired_encoding='32FC1')
        except Exception as e:
            self.get_logger().error(f"CV bridge error: {e}")
            return

        # Ensure BGR for YOLO
        if cv_image.shape[2] == 4:
            cv_image_bgr = cv2.cvtColor(cv_image, cv2.COLOR_BGRA2BGR)
        else:
            cv_image_bgr = cv_image

        # YOLO Inference
        if self.model is None:
            self.get_logger().error("YOLO model not loaded, skipping inference")
            return

        results = self.model.predict(cv_image_bgr, conf=self.conf_thresh, verbose=False)[0]

        det_array = ConeDetectionArray()
        det_array.header = rgb_msg.header # Use RGB header for timestamp

        annotated_img = cv_image_bgr.copy()

        if results.boxes:
            for box in results.boxes:
                x1, y1, x2, y2 = map(int, box.xyxy[0])
                conf = float(box.conf[0])
                
                # Dimensions
                w = float(x2 - x1)
                h = float(y2 - y1)
                cx = int((x1 + x2) / 2.0)
                cy = int((y1 + y2) / 2.0)

                # --- CHANGED: Distance Calculation ---
                # Extract small region (5x5 pixels) around center for robustness
                bounds = 5
                roi_depth = cv_depth[
                    max(0, cy-bounds):min(cv_depth.shape[0], cy+bounds),
                    max(0, cx-bounds):min(cv_depth.shape[1], cx+bounds)
                ]
                
                # Use Median to ignore NaN (holes) and outliers
                distance = float(np.nanmedian(roi_depth))
                
                # Fallback if depth is invalid (NaN)
                if np.isnan(distance) or distance <= 0:
                    distance = -1.0 # Indicator for "Unknown/Too Close"

                # Color Detection (Existing Logic)
                color = self.detect_color_in_roi(cv_image, x1, y1, x2, y2)

                det = ConeDetection()
                det.header = rgb_msg.header
                det.cx = float(cx)
                det.cy = float(cy)
                det.width = w
                det.height = h
                det.distance = distance
                det.confidence = conf
                det.color = color

                det_array.detections.append(det)

                # Annotation
                label = f"{color} {distance:.2f}m"
                cv2.rectangle(annotated_img, (x1, y1), (x2, y2), (0, 255, 0), 2)
                cv2.putText(annotated_img, label, (x1, y1 - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

        self.pub_detections.publish(det_array)
        
        annotated_msg = self.bridge.cv2_to_imgmsg(annotated_img, encoding='bgr8')
        annotated_msg.header = rgb_msg.header
        self.pub_annotated.publish(annotated_msg)


def main(args=None):
    rclpy.init(args=args)
    node = ConeDetectorNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()


