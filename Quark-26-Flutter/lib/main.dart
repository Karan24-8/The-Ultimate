import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:quark_26_flutter/Screens/Login.dart';
import 'package:quark_26_flutter/Screens/entry.dart';
import 'package:quark_26_flutter/Services/config.dart';
import 'package:quark_26_flutter/Services/payments.dart';
import 'package:quark_26_flutter/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run initialization tasks in parallel for better performance
  await Future.wait([
  //  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  // Initialize services in parallel
  await Future.wait([
    NoScreenshot.instance.screenshotOff(),
    Services().initialize(),
    Config().initialize(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isSignedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    try {
      final results = await Future.wait([
        _storage.read(key: 'user_name'),
        _storage.read(key: 'user_email'),
        _storage.read(key: 'user_type'),
        _googleSignIn.signInSilently(),
      ]);

      final userName = results[0] as String?;
      final userEmail = results[1] as String?;
      final userType = results[2] as String?;
      final googleUser = results[3] as GoogleSignInAccount?;

      if (googleUser != null &&
          userName != null &&
          userEmail != null &&
          userType != null) {
        if (mounted) {
          setState(() {
            _isSignedIn = true;
            _isLoading = false;
          });
        }
      } else {
        if (googleUser == null &&
            (userName != null || userEmail != null || userType != null)) {
          await _clearStoredData();
        }
        if (mounted) {
          setState(() {
            _isSignedIn = false;
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      await _clearStoredData();
      if (mounted) {
        setState(() {
          _isSignedIn = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _clearStoredData() async {
    try {
      await Future.wait([
        _storage.delete(key: 'user_name'),
        _storage.delete(key: 'user_email'),
        _storage.delete(key: 'user_type'),
        _storage.delete(key: 'access_token'),
      ]);

      try {
        await _googleSignIn.signOut();
      } catch (signOutError) {
        // ignore
      }

      try {
        await _googleSignIn.disconnect();
      } catch (disconnectError) {
        // ignore
      }
    } catch (error) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Quark 2026',
          home: _isLoading
              ? Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: const Color(0xFF0EBFFF),
                      size: 45.w,
                    ),
                  ),
                )
              : _buildHomeScreen(),
        );
      },
    );
  }

  Widget _buildHomeScreen() {
    if (_isSignedIn) {
      return Entry(onLogout: _handleLogout);
    }
    return LoginScreen(onLogoutForEntry: _handleLogout);
  }

  Future<void> _handleLogout() async {
    await _clearStoredData();
    if (mounted) {
      setState(() {
        _isSignedIn = false;
      });
    }
  }
}



import 'package:quark_26_flutter/Screens/gate_pass_screen.dart';

void main(){
  runApp(
    MaterialApp(
      home: GatePassScreen(),
    )
  );
}