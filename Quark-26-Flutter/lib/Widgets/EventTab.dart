import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Eventtab extends StatelessWidget {
  final String imageurl;
  final String title;
  const Eventtab({super.key, required this.imageurl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65.h,
          width: 98.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              imageurl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: Colors.white, size: 20.r);
              },
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Orbitron_Bold',
            color: Colors.white,
            fontSize: 12.r,
            height:0.9
          ),
        ),
      ],
    );
  }
}
