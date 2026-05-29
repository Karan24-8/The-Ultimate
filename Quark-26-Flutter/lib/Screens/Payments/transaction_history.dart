import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../Services/payments.dart';
import '../../models/transaction.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  late Future<Map<String, dynamic>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = Services().transactions();
  }

  Future<void> _blockAccount() async {
    try {
      await Services().blockaccount();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account has been blocked.',
              style: TextStyle(
                fontFamily: 'Orbitron_Regular',
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xFFC73C3C),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to block account: $e',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xFFC73C3C),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showBlockAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF0F0D30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFFCE4BB2), width: 1),
          ),
          title: Text(
            'Block Account',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Orbitron_Regular',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to block this account? You will NOT be able to make any more payments and this action is irreversible.',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Orbitron_Regular',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFC73C3C),
                  fontFamily: 'Orbitron_Regular',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _blockAccount();
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Color(0xFFFFD88E),
                  fontFamily: 'Orbitron_Regular',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.block, color: Color(0xFFCE4BB2), size: 24.w),
            color: Color(0xFF0F0D30),
            onSelected: (value) {
              if (value == 'block_account') {
                _showBlockAccountConfirmation();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'block_account',
                  child: Row(
                    children: [
                      Icon(Icons.block, color: Color(0xFFC73C3C)),
                      SizedBox(width: 8.w),
                      Text(
                        'Block Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Orbitron_Regular',
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  height: 874.h,
                  width: 402.w,
                  "assets/background.png",
                  fit: BoxFit.cover,
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        color: Color(0xFFCE4BB2),
                        size: 45.w,
                      ),

                      SizedBox(height: 20.h),

                      Text(
                        'Loading Transactions...',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Orbitron_Regular',
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  height: 874.h,
                  width: 402.w,
                  "assets/background.png",
                  fit: BoxFit.cover,
                ),

                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Color(0xFFC73C3C),
                          size: 60.w,
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          'Failed to fetch transactions. Kindly check your network connection and try again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Orbitron_Regular',
                            fontSize: 18.sp,
                          ),
                        ),

                        SizedBox(height: 20.h),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _transactionsFuture = Services().transactions();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCE4BB2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),

                          child: Text(
                            'Retry',
                            style: TextStyle(fontFamily: 'Orbitron_Regular'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            final balance = snapshot.data!['balance'];
            final transactions =
                snapshot.data!['transactions'] as List<Transaction>;

            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  height: 874.h,
                  width: 402.w,
                  "assets/background.png",
                  fit: BoxFit.cover,
                ),

                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),

                      Text(
                        'TRANSACTION\nHISTORY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Orbitron_Regular',
                          fontSize: 32.sp,
                          letterSpacing: 3.2,
                          height: 1.25,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Balance Card (from Waves25)
                      Container(
                        width: 250.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 20.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 40.w,
                              color: const Color(0xFFBC81FF),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Remaining Balance',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                                fontFamily: 'Orbitron_Regular',
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '₹$balance',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Orbitron_Regular',
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Expanded(
                        child: transactions.isEmpty
                            ? Center(
                                child: Text(
                                  'No transactions found',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Orbitron_Regular',
                                    fontSize: 16.sp,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 10.h,
                                ),
                                itemCount: transactions.length,
                                separatorBuilder: (c, i) =>
                                    SizedBox(height: 16.h),
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  final dt = transaction.timestamp;
                                  final formattedDate =
                                      "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year % 100}";
                                  return TransactionItem(
                                    title: transaction.vendor,
                                    date: formattedDate,
                                    amount: "Rs. ${transaction.amount}",
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 343.w,
      height: 72.h,
      child: CustomPaint(
        painter: CyberCardPainter(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Albert Sans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Stack(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontFamily: 'Albert Sans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          fontFamily: 'Albert Sans',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Albert Sans',
                  color: const Color(0xFFE1C7FF),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CyberCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF14123D).withOpacity(0.48);

    final rect = Offset.zero & size;
    final gradientShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFCE4BB2), Color(0xFF5C24FF), Color(0xFF00D1FF)],
    ).createShader(rect);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = gradientShader;

    final path = Path();
    double cutSize = 15.0;

    path.moveTo(cutSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cutSize);
    path.lineTo(size.width - cutSize, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cutSize);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
