import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:quark_26_flutter/Screens/Payments/enter_amount.dart';
import 'package:quark_26_flutter/Services/payments.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with WidgetsBindingObserver {
  Barcode result = Barcode('', BarcodeFormat.unknown, null);
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isDisposed = false;
  bool _cameraPermissionDenied = false;
  bool _isProcessingScan = false;
  StreamSubscription<Barcode>? _scanSubscription;
  bool _permissionHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.camera.status;

      if (status.isDenied) {
        final result = await Permission.camera.request();
        if (!result.isGranted && mounted) {
          setState(() {
            _cameraPermissionDenied = true;
          });
        }
      } else if (status.isPermanentlyDenied && mounted) {
        setState(() {
          _cameraPermissionDenied = true;
        });
        openAppSettings();
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid && !_isDisposed) {
      _safePauseCamera();
    }
    if (!_isDisposed && !_cameraPermissionDenied) {
      _safeResumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80.h,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 30.h, color: Colors.white),
            onPressed: () {
              controller?.dispose();
              Navigator.pop(context);
            },
          ),
        ),

        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Opacity(
              opacity: 0.56,
              child: Image.asset(
                height: 874.h,
                width: 402.w,
                "assets/background.png",
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80.h),

                  Text(
                    'SCAN QR',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2.0.sp,
                      fontSize: 36.0.sp,
                      fontFamily: "Orbitron_Regular",
                    ),
                  ),

                  SizedBox(height: 32.0.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF0F0D30),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFCE4BB2),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFFCE4BB2),
                        width: 1.0.w,
                      ),
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Text(
                      "SCAN QR to Pay instantly",
                      style: TextStyle(
                        fontSize: 25.0.sp,
                        fontFamily: "Albert Sans",
                        color: Color(0xFFBC81FF),
                        letterSpacing: 1.0.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 32.0.h),

                  Container(
                    height: 320.h,
                    width: 320.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36.r),
                      border: Border.all(color: Color(0xFFBC81FF), width: 6.w),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFCE4BB2).withOpacity(0.8),
                          blurRadius: 20.r,
                          spreadRadius: 2.r,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.r),
                      child: _cameraPermissionDenied
                          ? _buildPermissionPlaceholder()
                          : _buildQrView(context),
                    ),
                  ),
                  SizedBox(height: 32.0.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (i) => AnimatedContainer(
                        duration: Duration(milliseconds: 600 + i * 100),
                        margin: EdgeInsets.symmetric(horizontal: 7.w),
                        width: 13.w,
                        height: 13.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFBC81FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFCE4BB2).withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (_cameraPermissionDenied) ...[
                    SizedBox(height: 32.0.h),
                    Text(
                      'Provide permissions manually from settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _safePauseCamera() {
    try {
      if (controller != null && !_isDisposed) {
        controller!.pauseCamera();
      }
    } catch (e) {
      debugPrint('Error pausing camera: $e');
    }
  }

  void _safeResumeCamera() {
    try {
      if (controller != null && !_isDisposed) {
        controller!.resumeCamera();
      }
    } catch (e) {
      debugPrint('Error resuming camera: $e');
    }
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Color(0xFFFFD88E),
        borderRadius: 32,
        borderLength: 44,
        borderWidth: 10,
        cutOutSize: 270.w,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    if (_isDisposed) return;

    setState(() {
      this.controller = controller;
    });
    _scanSubscription = controller.scannedDataStream.listen((scanData) async {
      if (_isProcessingScan) return;
      _isProcessingScan = true;
      _safePauseCamera();

      final qrCode = scanData.code;

      if (qrCode == null || qrCode.isEmpty) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFC73C3C),
            content: Text(
              'Invalid QR code. Please try again.',
              style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
            ),
          ),
        );

        _isProcessingScan = false;
        _safeResumeCamera();
        return;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Center(
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Color(0xFF171717).withOpacity(0.7),
                    border: Border.all(color: Color(0xFFBC81FF), width: 1.0.w),
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        color: Color(0xFFBC81FF),
                        size: 48.w,
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'Processing...',
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFBC81FF),
                          letterSpacing: 1.0.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      try {
        String? vendor = await Services().validateVendor(scanData.code!);
        // debugPrint(vendor);
        // String? vendor = "Dominoz";
        Navigator.pop(context);

        if (vendor != null) {
          // log("Hellooooo wassup");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EnterAmount(vendor: vendor, qrdata: qrCode),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color(0xFFC73C3C),
              content: Text(
                'Vendor not found, please try again.',
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          );

          _isProcessingScan = false;
          _safeResumeCamera();
        }
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFC73C3C),
            content: Text(
              'Error processing request. Please try again.',
              style: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        );
        _isProcessingScan = false;
        _safeResumeCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // Only show dialog if permission is actually denied
      if (_permissionHandled) return;

      _permissionHandled = true;

      if (mounted) {
        setState(() {
          _cameraPermissionDenied = true;
        });
      }

      _showPermissionDialogIfNeeded();
    } else {
      // if (_cameraPermissionDenied || _permissionHandled) {
      if (mounted) {
        setState(() {
          _cameraPermissionDenied = false;
          _permissionHandled = false;
        });
      }
      // }
    }
  }

  Future<void> _showPermissionDialogIfNeeded() async {
    // final status = await PermissionService().getCameraPermissionStatus();
    // // Only show dialog for permanently denied or restricted permissions
    // if (status == PermissionStatus.permanentlyDenied ||
    //     status == PermissionStatus.restricted) {
    //   if (mounted) {
    //     PermissionService().showCameraPermissionDialog(context);
    //   }
    // }
    debugPrint("Supposed to complete");
  }

  Widget _buildPermissionPlaceholder() {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Icon(Icons.camera_alt_sharp, color: Colors.white54, size: 64.w),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isDisposed = true;
    _isProcessingScan = false;
    _scanSubscription?.cancel();
    _scanSubscription = null;

    try {
      if (controller != null) {
        controller!.pauseCamera();
        controller!.dispose();
      }
    } catch (e) {
      // Handle disposal errors gracefully
      debugPrint('Error disposing QR controller: $e');
    }
    super.dispose();
  }
}
