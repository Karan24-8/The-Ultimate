import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quark_26_flutter/Screens/Payments/qr_scanner.dart';
import 'package:quark_26_flutter/Screens/Payments/set_pin.dart';
import 'package:quark_26_flutter/Screens/entry.dart';
import 'package:quark_26_flutter/Services/payments.dart';

/// Payment flow entry: checks if user has PIN set.
/// If yes → QR scanner; if no → Set PIN.
/// Back from this screen returns to the main app (Entry).
class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  Future<bool>? _checkPinFuture;

  @override
  void initState() {
    super.initState();
    _checkPinFuture = Services().checkPin();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Entry()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<bool>(
          future: _checkPinFuture,
          builder: (context, snapshot) {
            log(snapshot.data.toString());
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState();
            } else if (snapshot.hasData && snapshot.data == true) {
              return const QRScannerScreen();
            } else {
              return const SetPin();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.white, size: 40.sp),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Session expired. Please logout and try again with your BITSMail.',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _checkPinFuture = Services().checkPin();
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
