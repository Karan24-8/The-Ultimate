import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quark_26_flutter/Services/payments.dart';

class SetPin extends StatefulWidget {
  const SetPin({super.key});

  @override
  State<SetPin> createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isLoading = false;
  final Services _services = Services();

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (_pinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter exactly 6 digits for PIN',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Cinzel", fontSize: 20.r),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (_confirmPinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter exactly 6 digits for confirm PIN',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Cinzel", fontSize: 20.r),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (_pinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PIN and Confirm PIN do not match',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Cinzel", fontSize: 20.r),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _handleSetPin() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _services.setPin(_pinController.text);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'PIN set successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Cinzel"),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Failed to set PIN. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Cinzel"),
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: "Cinzel"),
            ),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        //resizeToAvoidBottomInset:false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Image.asset(
              height: 874.h,
              width: 402.w,
              "assets/background.png",
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
                          "SET PIN",
                          style: TextStyle(
                            fontSize: 36.r,
                            color: Colors.white,
                            fontFamily: 'Orbitron_Bold',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 36.h),
                    Container(
                      width: 343.w,
                      height: 72.h,
                      decoration: BoxDecoration(
                        color:Color(0xFF0F0D30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFCE4BB2),
                            blurRadius: 5.r,
                            spreadRadius: 1.r,
                          ),
                        ],
                        border: Border.all(width: 1.w,color:Color(0xFFCE4BB2)),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _pinController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24.r,color: Color(0xFFBC81FF),fontFamily: 'Albert'),
                          onChanged: (value) {
                            if (_pinController.text.length == 6) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            hintText: "ENTER YOUR PIN",
                            hintStyle: TextStyle(fontSize: 24.r,color: Color(0xFFBC81FF),fontFamily: 'Albert'),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 343.w,
                      height: 72.h,
                      decoration: BoxDecoration(
                        color:Color(0xFF0F0D30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFCE4BB2),
                            blurRadius: 5.r,
                            spreadRadius: 1.r,
                          ),
                        ],
                        border: Border.all(width: 1.w,color:Color(0xFFCE4BB2)),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _confirmPinController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24.r,color: Color(0xFFBC81FF),fontFamily: 'Albert'),
                          onChanged: (value) {
                            if (_confirmPinController.text.length == 6) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            hintText: "RE-ENTER YOUR PIN",
                            hintStyle: TextStyle(fontSize: 24.r,color: Color(0xFFBC81FF),fontFamily: 'Albert'),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    GestureDetector(
                      onTap: _isLoading ? null : _handleSetPin,
                      child: Container(
                        height: 66.h,
                        width: 272.w,
                        decoration: BoxDecoration(
                          color: _isLoading ? Colors.grey : Color(0xFF171717),
                          border: Border.all(width: 1.w,color:Color(0xFFBC81FF)),
                        ),
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'SET PIN',
                                  style: TextStyle(
                                    fontFamily: 'Orbitron_Bold',
                                    color: Color(0xFFBC81FF),
                                    fontSize: 20.r,
                                  ),
                                ),
                        ),
                      ),
                    ),
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
