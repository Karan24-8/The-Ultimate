import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quark_26_flutter/Screens/Payments/confirmation.dart';

class EnterPin extends StatefulWidget {
  final String amount;
  final String qrData;
  final String vendor;

  const EnterPin({
    super.key,
    required this.amount,
    required this.qrData,
    required this.vendor,
  });

  @override
  State<EnterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 30.h, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,

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
                  SizedBox(height: 120.h),
                  Text(
                    "ENTER PIN",
                    style: TextStyle(
                      fontSize: 32.h,
                      fontFamily: "Orbitron_Regular",
                      color: Color(0xFFFFFFFF),
                    ),
                  ),

                  SizedBox(height: 120.h),

                  Container(
                    width: 347.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      color:Color(0xFF0F0D30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFCE4BB2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      border: Border.all(color: Color(0xFFCE4BB2), width: 1.w),

                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _pinController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFD88E),
                          fontSize: 20.h,
                        ),
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
                  SizedBox(height: 25.h),
                  GestureDetector(
                    onTap: () {
                      if (_pinController.text.length != 6) {
                        final bottomPadding = MediaQuery.of(
                          context,
                        ).viewInsets.bottom;

                        final double snackBarBottom = bottomPadding > 0
                            ? bottomPadding - 10.h
                            : 20.h;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter exactly 6 digits',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: "Cinzel"),
                            ),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: snackBarBottom,
                              left: 20.w,
                              right: 20.w,
                            ),
                          ),
                        );
                      } else {
                        FocusScope.of(context).unfocus();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Confirmation(
                              amount: widget.amount,
                              vendor: widget.vendor,
                              qrData: widget.qrData,
                              pin: _pinController.text,
                            ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    },

                    child: Container(
                      height: 66.h,
                      width: 272.w,
                      decoration: BoxDecoration(
                        color:Color(0xFF0F0D30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFCE4BB2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(1.w),
                        border: Border.all(
                          color: Color(0xFFCE4BB2),
                          width: 1.w,
                        ),
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            Text(
                              'PAY',
                              style: TextStyle(
                                fontSize: 20.h,
                                fontFamily: 'Orbitron_Regular',
                                letterSpacing: 3,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.w
                                  ..color = Color(0xFFBC81FF),
                              ),
                            ),
                            Text(
                              'PAY',
                              style: TextStyle(
                                fontSize: 20.h,
                                fontFamily: 'Orbitron_Regular',
                                color: Color(0xFFFFD994),
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
