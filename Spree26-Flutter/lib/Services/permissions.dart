import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Check if camera permission is granted
  Future<bool> isCameraPermissionGranted() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await Permission.camera.status;
      return status.isGranted;
    }
    return false;
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await Permission.camera.request();
      return status.isGranted;
    }
    return false;
  }

  /// Check camera permission status
  Future<PermissionStatus> getCameraPermissionStatus() async {
    if (Platform.isIOS || Platform.isAndroid) {
      return await Permission.camera.status;
    }
    return PermissionStatus.denied;
  }

  /// Show permission dialog with proper messaging
  void showCameraPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Color(0xFF0F0D30).withOpacity(0.7),
              border: Border.all(color: Color(0xFFCE4BB2), width: 1.0.w),
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 64.w,
                  color: Color(0xFF0F0D30),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Camera Permission Required',
                  style: TextStyle(
                    fontFamily: 'Albert Sans',
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F0D30),
                    letterSpacing: 0.8.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'This app needs camera access to scan QR codes for payments and other features. Please enable camera permission in your device settings.',
                  style: TextStyle(
                    fontFamily: 'Albert Sans',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Albert Sans',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          )?.copyWith(color: Color(0xFFC73C3C)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await openAppSettings();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0F0D30),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Open Settings',
                          style: TextStyle(
                            fontFamily: 'Albert Sans',
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          )?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handle camera permission flow
  Future<bool> handleCameraPermission(BuildContext context) async {
    final status = await getCameraPermissionStatus();

    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        final granted = await requestCameraPermission();
        if (!granted) {
          showCameraPermissionDialog(context);
        }
        return granted;
      case PermissionStatus.permanentlyDenied:
        showCameraPermissionDialog(context);
        return false;
      case PermissionStatus.restricted:
        showCameraPermissionDialog(context);
        return false;
      default:
        return false;
    }
  }
}