import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quark_26_flutter/Screens/entry.dart';
import 'package:quark_26_flutter/Screens/Payments/payments_page.dart';
import 'package:quark_26_flutter/Services/payments.dart';

// Custom Painter for the checkmark animation
class CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define checkmark path
    final path = Path();
    
    final startPoint = Offset(size.width * 0.25, size.height * 0.5);
    final bottomPoint = Offset(size.width * 0.45, size.height * 0.7);
    final endPoint = Offset(size.width * 0.8, size.height * 0.3);
    
    path.moveTo(startPoint.dx, startPoint.dy);
    
    if (progress <= 0.5) {
      final adjustedProgress = progress * 2; // Scale to 0-1 for this segment
      
      final currentX = startPoint.dx + (bottomPoint.dx - startPoint.dx) * adjustedProgress;
      final currentY = startPoint.dy + (bottomPoint.dy - startPoint.dy) * adjustedProgress;
      
      path.lineTo(currentX, currentY);
    } else {
      path.lineTo(bottomPoint.dx, bottomPoint.dy);
      
      final adjustedProgress = (progress - 0.5) * 2; // Scale to 0-1 for this segment
      
      final currentX = bottomPoint.dx + (endPoint.dx - bottomPoint.dx) * adjustedProgress;
      final currentY = bottomPoint.dy + (endPoint.dy - bottomPoint.dy) * adjustedProgress;
      
      path.lineTo(currentX, currentY);
    }
    
    // Set up the paint
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
      
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Confirmation extends StatefulWidget {
  final String amount, vendor, qrData, pin;
  const Confirmation({
    super.key,
    required this.amount,
    required this.vendor,
    required this.qrData,
    required this.pin,
  });

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> with TickerProviderStateMixin {
  late final AnimationController _circleController;
  late final AnimationController _checkController;
  late final AnimationController _bounceController;
  
  late final Animation<double> _circleAnimation;
  late final Animation<double> _checkAnimation;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _glowAnimation;

  bool _isPaymentInProgress = false;
  String? _paymentError;

  @override
  void initState() {
    super.initState();
    _makePayment();

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeOutQuart),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController, 
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuint),
      ),
    );
    
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.95, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.4), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Success animation is started only after payment succeeds in _makePayment()
  }

  void _startAnimations() {
    _circleController.forward().then((_) {
      _checkController.forward().then((_) {
        _bounceController.forward();
      });
    });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _checkController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _makePayment() async {
    if (_isPaymentInProgress) return;
    setState(() {
      _isPaymentInProgress = true;
      _paymentError = null;
    });

    try {
      await Services().makePayment(
        widget.qrData,
        int.parse(widget.amount),
        widget.pin,
      );

      // Payment successful: show success animation
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _startAnimations();
      });
    } catch (e) {
      if (!mounted) return;
      final message = e.toString();
      if (message.contains("Invalid PIN") || message.contains("403")) {
        setState(() {
          _paymentError = "Invalid PIN. Please try again.";
        });
      } else {
        setState(() {
          _paymentError = message.contains("network")
              ? "Kindly check your network connection."
              : "An error occurred during payment. Please try again.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPaymentInProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPaymentInProgress) {
      // Show loading screen
      return Scaffold(
      backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Image.asset(
              height: 874.h,
              width: 402.w,
              "assets/background.png",
              fit: BoxFit.cover,
            ),
            Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Color(0xFFBC81FF),
                size: 60.h,
              ),
            ),
          ],
        ),
      );
    }
    if (_paymentError != null) {
      // Show error screen
      return Scaffold(
      backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Opacity(
              opacity: 0.56,
              child: Image.asset(
                height: 874.h,
                width: 402.w,
                "assets/background.png",
                fit: BoxFit.cover,
              ),
            ),
            Center(child: _buildErrorState(_paymentError!, context)),
          ],
        ),
      );
    }
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Entry()),
          (route) => false,
        );
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   leading: IconButton(
          //     icon: Icon(Icons.arrow_back, size: 60.w, color: Color(0xFFBC81FF)),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Opacity(
                opacity: 0.56,
                child: Image.asset(
                  height: 874.h,
                  width: 402.w,
                  "assets/background.png",
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),
                    // Animated checkmark
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _circleController, 
                        _checkController,
                        _bounceController
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _bounceAnimation.value,
                          child: SizedBox(
                            width: 183.34.w,
                            height: 183.34.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer glow
                                Container(
                                  width: 183.34.w,
                                  height: 183.34.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFBC81FF).withOpacity(_glowAnimation.value),
                                        blurRadius: 20.r,
                                        spreadRadius: 10.r,
                                      ),
                                    ],
                                  ),
                                ),
                                // Circle background with scale animation
                                Transform.scale(
                                  scale: _circleAnimation.value,
                                  child: Container(
                                    width: 183.34.w,
                                    height: 183.34.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Color(0xFFBC81FF), width: 2),
                                    ),
                                  ),
                                ),
                                // Custom drawn checkmark with drawing animation
                                CustomPaint(
                                  size: Size(143.w, 143.h),
                                  painter: CheckmarkPainter(
                                    progress: _checkAnimation.value,
                                    color: Color(0xFFBC81FF),
                                    strokeWidth: 4.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 32.43.h),
                    // Animated text with fade-in
                    AnimatedBuilder(
                      animation: _checkController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _checkController.value,
                          child: AnimatedBuilder(
                            animation: _bounceController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, 10 * (1 - _bounceController.value)),
                                child: child,
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  'Payment',
                                  style: TextStyle(
                                    fontSize: 41.r,
                                    color: Color(0xFFBC81FF),
                                    fontFamily: 'Orbitron_Regular',
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8.0.r,
                                        color: const Color(0xFFBC81FF).withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Succesful!',
                                  style: TextStyle(
                                    fontSize: 41.r,
                                    color: Color(0xFFBC81FF),
                                    fontFamily: 'Orbitron_Regular',
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8.0.r,
                                        color: const Color(0xFFBC81FF).withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15.h),
                    // Amount with shine effect
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _bounceController.value,
                          child: Text(
                            '₹ ${widget.amount}',
                            style: TextStyle(
                              fontSize: 45.r,
                              color: Color(0xFFBC81FF),
                              fontFamily: 'Orbitron_Regular',
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0.r,
                                  color: const Color(0xFFBC81FF).withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _bounceController.value,
                          child: Text(
                            widget.vendor,
                            style: TextStyle(
                              fontSize: 25.r,
                              color: Color(0xFFBC81FF),
                              fontFamily: 'Orbitron_Regular',
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 318.w,
                      child: Divider(color: Color(0xFFBC81FF), thickness: 1),
                    ),
                    SizedBox(height: 15.h),
                    // Transaction timestamp with fade-in effect
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _bounceController.value,
                          child: Text(
                            'Time: ${DateFormat('hh:mm a').format(DateTime.now())}, ${DateFormat('d MMM').format(DateTime.now())}',
                            style: TextStyle(
                              fontSize: 30.r,
                              color: Color(0xFFBC81FF),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Orbitron_Regular',
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30.h),
                    // Animated back button with hover effect
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return AnimatedOpacity(
                          opacity: _bounceController.value,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFBC81FF).withOpacity(0.3),
                                  blurRadius: 10.r,
                                  spreadRadius: 1.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Entry()),
                                  (route) => false,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF171717),
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(color: Color(0xFFBC81FF), width: 1),
                                ),
                                height: 66.h,
                                width: 272.w,
                                child: Center(
                                  child: Text(
                                    'Home',
                                    style: TextStyle(
                                      fontSize: 20.r,
                                      color: Color(0xFFBC81FF),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'PlayfairDisplaySC',
                                      letterSpacing: 10.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Color(0xFFC73C3C), size: 60.w),
            SizedBox(height: 20.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                fontSize: 18.r,
              ),
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentsPage()),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFC73C3C),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              child: Text(
                'Go Back',
                style: TextStyle(
                  fontSize: 16.r,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}