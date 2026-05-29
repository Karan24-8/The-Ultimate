import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quark_26_flutter/Services/payments.dart';

class ResetPin extends StatefulWidget {
  const ResetPin({super.key});

  @override
  State<ResetPin> createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final Services _services = Services();

  /// Step 1: Send OTP. Step 2: Enter OTP + new PIN.
  int _step = 1;
  bool _isLoading = false;
  bool _resendCooldown = false;

  @override
  void dispose() {
    _newPinController.dispose();
    _confirmPinController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Wave 1: Call reset-pin request-otp endpoint to send OTP.
  Future<void> _sendOTP() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await _services.requestOTP();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _step = 2;
        _resendCooldown = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to your registered email'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      // Cooldown for resend (e.g. 60s)
      Future.delayed(const Duration(seconds: 60), () {
        if (mounted) setState(() => _resendCooldown = false);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send OTP: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Resend OTP (same endpoint as send).
  Future<void> _resendOTP() async {
    if (_isLoading || _resendCooldown) return;
    await _sendOTP();
  }

  bool _validateStep2() {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the OTP'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP must be 6 digits'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (_newPinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter exactly 6 digits for new PIN'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (_confirmPinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter exactly 6 digits for confirm PIN'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (_newPinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New PIN and Confirm PIN do not match'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  /// Wave 2: Verify OTP and set new PIN.
  Future<void> _handleResetPin() async {
    if (!_validateStep2()) return;
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final ok = await _services.verifyOTP(
        _otpController.text.trim(),
        _newPinController.text,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN reset successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid OTP. Please try again or request a new OTP.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildInputBox({
    required TextEditingController controller,
    required String hint,
    int maxLength = 6,
  }) {
    return Container(
      width: 343.w,
      height: 72.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0D30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCE4BB2),
            blurRadius: 5.r,
            spreadRadius: 1.r,
          ),
        ],
        border: Border.all(
          width: 1.w,
          color: const Color(0xFFCE4BB2),
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(maxLength),
          ],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.r,
            color: const Color(0xFFBC81FF),
            fontFamily: 'Albert',
          ),
          onChanged: (value) {
            if (value.length == maxLength) {
              FocusScope.of(context).unfocus();
            }
          },
          keyboardType: TextInputType.number,
          obscureText: true,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 24.r,
              color: const Color(0xFFBC81FF),
              fontFamily: 'Albert',
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, size: 30.r, color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              height: 874.h,
              width: 402.w,
              'assets/background.png',
              fit: BoxFit.cover,
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 375.w,
                      height: 54.h,
                      child: Center(
                        child: Text(
                          'RESET PIN',
                          style: TextStyle(
                            fontSize: 36.sp,
                            color: Colors.white,
                            fontFamily: 'Orbitron_Bold',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    if (_step == 1) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          "We'll send an OTP to your registered email. Tap below to receive it.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFBC81FF),
                            fontFamily: 'Albert',
                          ),
                        ),
                      ),
                      SizedBox(height: 48.h),
                      GestureDetector(
                        onTap: _isLoading ? null : _sendOTP,
                        child: Container(
                          height: 66.h,
                          width: 272.w,
                          decoration: BoxDecoration(
                            color: _isLoading
                                ? Colors.grey
                                : const Color(0xFF171717),
                            border: Border.all(
                              width: 1.w,
                              color: const Color(0xFFBC81FF),
                            ),
                          ),
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                                    height: 24.h,
                                    width: 24.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFBC81FF),
                                    ),
                                  )
                                : Text(
                                    'SEND OTP',
                                    style: TextStyle(
                                      fontFamily: 'Orbitron_Bold',
                                      color: const Color(0xFFBC81FF),
                                      fontSize: 20.sp,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          'Enter the OTP you received and your new 6-digit PIN.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFBC81FF),
                            fontFamily: 'Albert',
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildInputBox(
                        controller: _otpController,
                        hint: 'ENTER OTP',
                      ),
                      SizedBox(height: 10.h),
                      _buildInputBox(
                        controller: _newPinController,
                        hint: 'NEW PIN',
                      ),
                      SizedBox(height: 10.h),
                      _buildInputBox(
                        controller: _confirmPinController,
                        hint: 'CONFIRM PIN',
                      ),
                      if (_resendCooldown)
                        Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: Text(
                            'Resend OTP available in 60s',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white54,
                            ),
                          ),
                        )
                      else
                        TextButton(
                          onPressed: _isLoading ? null : _resendOTP,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFBC81FF),
                            ),
                          ),
                        ),
                      SizedBox(height: 24.h),
                      GestureDetector(
                        onTap: _isLoading ? null : _handleResetPin,
                        child: Container(
                          height: 66.h,
                          width: 272.w,
                          decoration: BoxDecoration(
                            color: _isLoading
                                ? Colors.grey
                                : const Color(0xFF171717),
                            border: Border.all(
                              width: 1.w,
                              color: const Color(0xFFBC81FF),
                            ),
                          ),
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                                    height: 24.h,
                                    width: 24.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFBC81FF),
                                    ),
                                  )
                                : Text(
                                    'RESET PIN',
                                    style: TextStyle(
                                      fontFamily: 'Orbitron_Bold',
                                      color: const Color(0xFFBC81FF),
                                      fontSize: 20.sp,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
