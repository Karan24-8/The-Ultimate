import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homepagecard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final Widget destination;

  const Homepagecard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.destination,
  });

  @override
  State<Homepagecard> createState() => _HomepagecardState();
}

class _HomepagecardState extends State<Homepagecard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.destination),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
        child: SizedBox(
          width: 353.w,
          height: 162.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/homepage/${widget.imageUrl}',
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8.sp,
                        fontFamily: 'Orbitron_Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
