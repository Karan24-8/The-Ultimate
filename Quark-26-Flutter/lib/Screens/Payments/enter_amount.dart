import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quark_26_flutter/Screens/Payments/enter_pin.dart';
import 'package:quark_26_flutter/Screens/Payments/reset_pin.dart';

class EnterAmount extends StatefulWidget {
  final String vendor;
  final String qrdata;
  const EnterAmount({super.key, required this.vendor, required this.qrdata});

  @override
  State<EnterAmount> createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  late final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            iconSize: 30.h,
            color: Colors.white,
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
                    'ENTER AMOUNT',
                    style: TextStyle(
                      fontSize: 32.h,
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Orbitron_Regular',
                    ),
                  ),
                  SizedBox(height: 120.h),
                  Text(
                    'PAYING TO : ${widget.vendor}',
                    style: TextStyle(
                      fontSize: 24.h,
                      color: Color(0xFFBC81FF),
                      fontFamily: 'Albert Sans',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: 343.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF0F0D30),
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
                        controller: _amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          color: Color(0xFFFFD994),
                          fontSize: 30.h,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ENTER AMOUNT",
                          hintStyle: TextStyle(
                            color: Color(0xFFBC81FF),
                            fontSize: 30.r,
                            fontFamily: 'Albert',
                          ),
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
                      int? amountInIntegers = int.tryParse(
                        _amountController.text,
                      );
                      if (amountInIntegers != null) {
                        if (amountInIntegers <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter a valid amount!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: "Cinzel"),
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (amountInIntegers > 3000) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Amount exceeds maximum limit of ₹3000',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: "Cinzel"),
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          // debugPrint("amount: ${_amountController.text}");
                          // debugPrint("vendor: ${widget.vendor}");
                          // debugPrint("qrdata: ${widget.qrdata}");
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  EnterPin(
                                    amount: _amountController.text,
                                    vendor: widget.vendor,
                                    qrData: widget.qrdata,
                                  ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter a valid amount!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: "Cinzel"),
                            ),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Container(
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
                      ),
                      height: 66.h,
                      width: 272.w,
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
                  SizedBox(height: 10.h),

                  GestureDetector(
                    onTap: () {
                      debugPrint("Reset Pin Tapped");
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              ResetPin(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Container(
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
                      ),
                      height: 66.h,
                      width: 272.w,
                      child: Center(
                        child: Stack(
                          children: [
                            Text(
                              'RESET PIN',
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
                              'RESET PIN',
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
