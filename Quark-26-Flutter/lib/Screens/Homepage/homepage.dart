import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quark_26_flutter/Screens/aftermovie/aftermovie.dart';
import 'package:quark_26_flutter/Screens/ContactUs/ContactUs.dart';
import 'package:quark_26_flutter/Screens/Events/Events.dart';
import 'package:quark_26_flutter/Screens/Gallery/gallery-main.dart';
import 'package:quark_26_flutter/Screens/Payments/payments_page.dart';
import 'package:quark_26_flutter/Screens/Rulebook/rulebook.dart';
import 'package:quark_26_flutter/Screens/Sponsors/sponsors.dart';
import 'package:quark_26_flutter/Screens/gate_pass_screen.dart';
import 'package:quark_26_flutter/Services/config.dart';
import 'package:quark_26_flutter/Widgets/homepageCard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static const _storage = FlutterSecureStorage();
  bool _isGuest = true;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final userType = await _storage.read(key: 'user_type');
    if (mounted) {
      setState(() => _isGuest = userType == 'guest');
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Exit App',
              style: TextStyle(color: Colors.black, letterSpacing: 0.1.sp),
            ),
            content: Text(
              'Are you sure you want to exit the app?',
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No', style: TextStyle(color: Colors.black, fontSize: 14.sp)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldExit = await _onWillPop();
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Image.asset(
              height: 874.h,
              width: 402.w,
              "assets/gallery/gallery_bg_2.png",
              fit: BoxFit.cover,
            ),
            Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "assets/logo.png",
                          width: 244.w,
                          height: 99.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (Config().showEvents)
                        Homepagecard(
                          title: "EVENTS",
                          imageUrl: 'events.png',
                          destination: Events(),
                        ),
                      if (!_isGuest)
                        Homepagecard(
                          title: "PAYMENTS",
                          imageUrl: 'payments.png',
                          destination: PaymentsPage(),
                        ),
                      Homepagecard(
                        title: "GATE PASS",
                        imageUrl: 'payments.png',
                        destination: GatePassScreen(),
                      ),
                      Homepagecard(
                        title: "GALLERY",
                        imageUrl: 'gallery.png',
                        destination: GalleryPage(),
                      ),
                      Homepagecard(
                        title: "AFTERMOVIE",
                        imageUrl: 'aftermovie.png',
                        destination: Aftermovie(),
                      ),
                      Homepagecard(
                        title: "CONTACT US",
                        imageUrl: 'contactus.png',
                        destination: ContactUs(),
                      ),
                      if (Config().showSponsors)
                        Homepagecard(
                          title: "SPONSORS",
                          imageUrl: 'sponsors.png',
                          destination: SponsorsPage(),
                        ),
                      Homepagecard(
                        title: "RULEBOOK",
                        imageUrl: 'rulebook.png',
                        destination: Rulebook(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
