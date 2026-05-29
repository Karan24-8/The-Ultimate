import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCard extends StatelessWidget {
  final String name;
  const CreditCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 212.h,
      width: 369.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/creditcard.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 28.h,
            right: 55.w,
            child: Text(
              '2026',
              style: TextStyle(
                color: Color(0xFF49C0FF),
                fontSize: 16.r,
                fontFamily: 'OCR',
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 6, color: Color(0xFF49C0FF))],
              ),
            ),
          ),
          Positioned(
            top: 105.h,
            right: 80.w,
            child: Text(
              name,
              style: TextStyle(
                color: const Color.fromARGB(159, 255, 255, 255),
                fontSize: 16.r,
                fontWeight: FontWeight.bold,
                fontFamily: 'OCR',
                letterSpacing: 0.2,
              ),
            ),
          ),
          Positioned(
            top: 155.h,
            right: 50.w,
            child: Text(
              "QUARK",
              style: TextStyle(
                color: Color(0xFFF46EE3),
                fontSize: 20.r,
                fontFamily: 'OCR',
                letterSpacing: 0.1,
                shadows: [Shadow(blurRadius: 8, color: Color(0xFFF46EE3))],
              ),
            ),
          ),
          Positioned(
            top: 135.h,
            right: 295.w,
            child: Text(
              "Valid\nFrom",
              style: TextStyle(
                color: const Color.fromARGB(159, 255, 255, 255),
                fontSize: 8.r,
                fontFamily: 'Albert',
              ),
            ),
          ),
                    Positioned(
            top: 135.h,
            right: 245.w,
            child: Text(
              "06/02",
              style: TextStyle(
                color: const Color.fromARGB(159, 255, 255, 255),
                fontSize: 16.r,
                fontFamily: 'Albert',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
