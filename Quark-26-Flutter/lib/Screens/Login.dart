import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quark_26_flutter/Screens/entry.dart';
import 'package:quark_26_flutter/Services/config.dart';
import 'package:quark_26_flutter/Services/payments.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';


class LoginScreen extends StatefulWidget {
  /// When opened from logout, pass this so Entry gets the logout callback after re-login.
  final Future<void> Function()? onLogoutForEntry;

  const LoginScreen({super.key, this.onLogoutForEntry});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool isAppleAuthEnabled = false;

  final Color _buttonBgColor = const Color(0xFF14123D);
  final Color _buttonTextColor = const Color(0xFFB1CBF8);

  @override
  void initState() {
    super.initState();
    _checkAppleAuthEnabled();
  }

  Future<void> _checkAppleAuthEnabled() async {
    isAppleAuthEnabled = await Config().isAppleAuthEnabled();
    setState(() {
      isAppleAuthEnabled = isAppleAuthEnabled;
    });
  }

  Future<void> _handleSignIn() async {
    setState(() {});

    try {
      debugPrint('Starting Google Sign-In process');

      // Clear any existing session first
      if (await _googleSignIn.isSignedIn()) {
        debugPrint('Clearing existing session');
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'user_name');
        await _storage.delete(key: 'user_email');
        await _storage.delete(key: 'user_type');
      }

      // debugPrint('Attempting to sign in with Google');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        debugPrint('Google Sign-In successful: ${googleUser.email}');

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        String? idToken = googleAuth.idToken;
        debugPrint('idToken: $idToken');
        // debugPrint('ID Token obtained: ${idToken != null ? 'Yes' : 'No'}');

        if (idToken != null) {
          try {
            debugPrint('Fetching API configuration');
            // await Config().fetchAndStoreApiUrl();

            debugPrint('Processing authentication');
            String userType = await Services().auth(idToken);
            debugPrint('User type determined: $userType');

            try {
              await _storage.write(
                key: 'user_name',
                value: googleUser.displayName,
              );
              await _storage.write(key: 'user_email', value: googleUser.email);
              await _storage.write(key: 'user_type', value: userType);
            } catch (e) {
            }

            debugPrint('User data stored successfully');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Signed in as: ${googleUser.displayName}",
                  style: TextStyle(fontFamily: "Cinzel"),
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to Entry screen only after successful authentication
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Entry(onLogout: widget.onLogoutForEntry),
              ),
            );
          } catch (authError) {
            debugPrint('Authentication processing failed: $authError');
            _showSnackBar(
              "Authentication failed. Please try again.",
              Colors.red,
            );
          }
        } else {
          debugPrint('No ID token received from Google');
          _showSnackBar(
            "Authentication failed. No token received.",
            Colors.red,
          );
        }
      } else {
        debugPrint('Google Sign-In was canceled by user');
        _showSnackBar("Sign-in canceled", Colors.orange);
      }
    } catch (error) {
      debugPrint('Error during Google Sign-In: $error');
      _showSnackBar(
        "Sign in failed. Please check your connection and try again.",
        Colors.red,
      );
    } finally {
      setState(() {});
    }
  }

  void _handleAppleSignIn() async {
    try {
      final credentials = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credentials.userIdentifier != null) {
        debugPrint('Apple Sign In Success');

        String? userName;
        try {
          await _storage.write(key: 'user_type', value: 'guest');

          userName =
          credentials.givenName != null && credentials.familyName != null
              ? '${credentials.givenName} ${credentials.familyName}'
              : credentials.givenName ?? 'Apple User';

          await _storage.write(key: 'user_name', value: userName);
          await _storage.write(key: 'user_email', value: credentials.email ?? '');
        } catch (e) {
        }

        debugPrint('Apple user data stored successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Signed in as: $userName",
              style: TextStyle(fontFamily: "Cinzel"),
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Entry(onLogout: widget.onLogoutForEntry),
          ),
        );
      } else {
        debugPrint('Apple Sign In failed - no user identifier');
        _showSnackBar("Apple Sign In failed. Please try again.", Colors.red);
      }
    } catch (error) {
      debugPrint('Apple Sign In Error: $error');
      _showSnackBar(
        "Sign in failed. Please check your connection.",
        Colors.red,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontFamily: "Cinzel")),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login/loginbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. LOGO
                  Container(
                    width:350.w,

                    child: Image.asset('assets/logo.png',
                    fit: BoxFit.fitWidth,),
                  ),

                  SizedBox(height: 50.h), // Spacing

                  // 2. GOOGLE BUTTON
                  GestureDetector(
                    onTap: _handleSignIn,
                    child: Container(
                      height: 50.h,
                      width: 250.w, // Adjusted width for better look
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.h),
                        color: _buttonBgColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/login/google_icon.svg',
                            height: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'GOOGLE',
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              color: _buttonTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp, // Use .sp for font size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h), // Spacing between buttons

                  // 3. APPLE BUTTON (Correctly separated)
                  // Uncomment the Platform check when ready
                  if (Platform.isIOS)
                  GestureDetector(
                    onTap: _handleAppleSignIn,
                    child: Container(
                      height: 50.h,
                      width: 250.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.h),
                        color: _buttonBgColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.apple_outlined,
                            size: 30.h,
                            color: _buttonTextColor, // Match icon color to text
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'APPLE',
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              color: _buttonTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}