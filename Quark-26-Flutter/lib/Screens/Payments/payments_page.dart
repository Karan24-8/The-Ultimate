import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quark_26_flutter/Screens/Payments/payments.dart';
import 'package:quark_26_flutter/Screens/Payments/reset_pin.dart';
import 'package:quark_26_flutter/Screens/Payments/transaction_history.dart';
import 'package:quark_26_flutter/Widgets/credit_card.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  static const _storage = FlutterSecureStorage();
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await _storage.read(key: 'user_name');
    if (mounted) {
      setState(() => _userName = name ?? 'User');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'WALLET',
                    style: TextStyle(
                      fontSize: 40.r,
                      letterSpacing: 0.1,
                      color: Colors.white,
                      fontFamily: 'Orbitron_Bold',
                    ),
                  ),
                  SizedBox(height: 36.h),
                  CreditCard(name: _userName),
                  SizedBox(height: 40.r),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Payments()),
                          );
                        },
                        child: Container(
                          height: 202.h,
                          width: 146.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: Color(0xFFBC81FF),
                              width: 3.w,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_2,
                                size: 55.r,
                                color: Colors.white,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'SCAN QR',
                                style: TextStyle(
                                  fontSize: 11.r,
                                  color: Colors.white,
                                  fontFamily: 'Albert',
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 13.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionHistory()),
                          );
                        },
                        child: Container(
                          height: 202.h,
                          width: 146.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: Color(0xFFBC81FF),
                              width: 3.w,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 55.r,
                                color: Colors.white,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'Transaction\nHistory',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.r,
                                  color: Colors.white,
                                  fontFamily: 'Albert',
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 13.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPin()),
                      );
                    },
                    child: Container(
                      height: 51.h,
                      width: 304.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          color: Color(0xFFBC81FF),
                          width: 3.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'RESET PIN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.r,
                            color: Colors.white,
                            fontFamily: 'Orbitron_Bold',
                            letterSpacing: 0.13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
