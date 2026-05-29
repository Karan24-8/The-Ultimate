import 'package:cloud_firestore/cloud_firestore.dart'; // Added this import
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';


class Aftermovie extends StatefulWidget {
  const Aftermovie({super.key});

  @override
  State<Aftermovie> createState() => _AftermovieState();
}

class _AftermovieState extends State<Aftermovie> {
  String youtubeUrl = ''; 

  @override
  void initState() {
    super.initState();
    _fetchUrl(); 
  }

  
  Future<void> _fetchUrl() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('AfterMovie')
          .doc('youtube-url')
          .get();

      if (snapshot.exists && mounted) {
        setState(() {
          youtubeUrl = snapshot.get('url') ?? ''; 
        });
      }
    } catch (e) {
      debugPrint('Error fetching URL: $e');
    }
  }

  String? _extractVideoId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
  }

  if (uri.host.contains('youtube.com')) {
    return uri.queryParameters['v'];
  }

  return null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/aftermovie-bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    "QUARK'25\nAFTERMOVIE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron_Regular',
                      fontSize: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        width: 320.w,
                        height: 300.h,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            56,
                            53,
                            53,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5.w,
                          ),
                        ),
                        
                        child: youtubeUrl.isEmpty 
                            ? Center(child: CircularProgressIndicator(color: Colors.white)) 
                            : GestureDetector(
                                onTap: () async {
                                  // Open YouTube directly in external app - simple and reliable
                                  final uri = Uri.parse(youtubeUrl);
                                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Could not open YouTube video')),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.transparent,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // YouTube thumbnail
                                      Image.network(
                                        'https://i.ytimg.com/vi/${_extractVideoId(youtubeUrl) ?? ''}/hqdefault.jpg',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        
                                      ),
                                      // Play button overlay
                                      Center(
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          color: Colors.white,
                                          size: 64.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                      ),
                    ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "Quark is the annual technical festival of BITS Pilani K. K. Birla Goa Campus—where innovation, competition, and creativity collide. Entirely student-driven, Quark brings together the best minds from across the country for three electrifying days of coding battles, robotics, research, workshops, and inspiring talks. From high-octane competitions to buzzing tech showcases, Quark is where ideas turn into action and curiosity becomes creation.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Albert Sans',
                        fontSize: 16.sp,
                        color: Colors.white,
                        
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h), // Extra padding at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}