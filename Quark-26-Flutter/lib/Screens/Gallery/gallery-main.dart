import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 32.r,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            SizedBox(width: 48.w), // balances the leading IconButton
          ],
          title: Text(
            'GALLERY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Orbitron_Regular',
              letterSpacing: 2,
              shadows: const [
                Shadow(
                  color: Color(0xFFB388FF),
                  blurRadius: 20,
                ),
                Shadow(
                  color: Color(0xFF9C27B0),
                  blurRadius: 40,
                ),
                Shadow(
                  color: Color(0xFF7C4DFF),
                  blurRadius: 60,
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Gallery').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 60.h,
                ),
              );
            }
            if (snapshot.hasError)
              return Center(child: Text("Something went wrong"));
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No images",
                  style: TextStyle(color: Colors.white),
                ),
              );

            }

            final docs = snapshot.data!.docs;
            final itemCount = docs.length;

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/gallery/gallery_bg_2.png',
                    fit: BoxFit.cover,
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/gallery/gallery_bg.png',
                      height: 420.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Images
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: List.generate(itemCount, (index) {
                          final angle =
                              (2 * pi * index / itemCount) +
                                  (_controller.value * 2 * pi);

                          final radius = 260.w;
                          final x = radius * sin(angle);
                          final z = radius * cos(angle);

                          final depth = (z + radius) / (2 * radius);
                          final scale = depth.clamp(0.5, 1.0);
                          final opacity = depth.clamp(0.3, 1.0);

                          final data =
                          docs[index].data() as Map<String, dynamic>;
                          final imgUrl = data['url'] ?? '';

                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.0015)
                              ..translate(x, 0, -z)
                              ..rotateY(angle)
                              ..scale(scale),
                            child: Opacity(
                              opacity: opacity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18.r),
                                child: CachedNetworkImage(
                                  width: 200.w,
                                  height: 400.h,
                                  imageUrl: imgUrl,
                                  fit: BoxFit.contain,
                                  placeholder: (_, __) =>
                                  const CircularProgressIndicator(strokeWidth: 2),
                                  errorWidget: (_, __, ___) =>
                                  const Icon(Icons.broken_image, color: Colors.white),
                                )

                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
