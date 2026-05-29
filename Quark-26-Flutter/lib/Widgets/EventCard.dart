import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String dateText;
  final String time;
  final String location;

  const EventCard({
    super.key,
    required this.title,
    required this.dateText,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92.h,
      width: 353.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0xFFCE4BB2),
        //     blurRadius: 5.r,
        //     spreadRadius: 1.r,
        //   ),
        // ],
        border: Border.all(width: 1.w, color: Colors.white),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 83.w,
            height: 83.h,
            child: Center(
              child: Stack(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 70.r,
                    color: Colors.grey,
                  ),
                  Positioned(
                    top: 26.h,
                    left: 23.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: dateText,
                                style: TextStyle(
                                  fontSize: 20.r,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: '\n'),
                              TextSpan(
                                text: 'FEB',
                                style: TextStyle(
                                  fontSize: 13.r,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.r,
                  fontFamily: 'Albert Var',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Date: $dateText Feb  Time: $time',
                style: TextStyle(
                  fontSize: 12.r,
                  fontFamily: 'Albert',
                  color: Colors.white,
                  letterSpacing: 0,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 15.r),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 12.r,
                      fontFamily: 'Albert',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
