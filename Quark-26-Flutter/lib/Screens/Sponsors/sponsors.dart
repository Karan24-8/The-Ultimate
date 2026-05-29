import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SponsorsPage extends StatelessWidget {
  const SponsorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sponsors/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Sponsors').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.black,
                  size: 50.h,
                ),
              );
            }
            if (snapshot.hasError)
              return Center(child: Text("Something went wrong"));
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No Sponsors", style: TextStyle(color: Colors.white)),
              );
            }

            final docs = snapshot.data!.docs;
            final sponsorPages = (docs.length / 2).ceil();
            final totalPages = sponsorPages + 1;

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, pageIndex) {
                final index = pageIndex % totalPages;

                if (index == 0) {
                  return _titlePage();
                }

                final start = (index - 1) * 2;
                final end = (start + 2).clamp(0, docs.length);
                final pageDocs = docs.sublist(start, end);

                return _sponsorPage(pageDocs);
              },
            );
          },
        ),
      ),

      SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 32.r,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    ],
  ),
);
  }

  Widget _titlePage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Text(
          'OUR PAST SPONSORS & MEDIA PARTNERS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.h,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Orbitron_Regular',
            letterSpacing: 2,
            shadows: const [
              Shadow(color: Color(0xFFB388FF), blurRadius: 20),
              Shadow(color: Color(0xFF9C27B0), blurRadius: 40),
              Shadow(color: Color(0xFF7C4DFF), blurRadius: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sponsorPage(List<QueryDocumentSnapshot> docs) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final imageUrl = data['url'] ?? '';
            final name = data['name'] ?? '';

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 170.w,
                      height: 200.h,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Orbitron_Regular',
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
