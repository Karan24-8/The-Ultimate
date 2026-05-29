import 'dart:convert';
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class GatePassScreen extends StatefulWidget {
  const GatePassScreen({super.key});
  @override
  _GatePassScreenState createState() => _GatePassScreenState();
}

class _GatePassScreenState extends State<GatePassScreen> {
  final _emailController = TextEditingController();
  Map<String, dynamic>? passData;
  String? errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPass();
  }

  String formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      _showErrorSnackBar();
      return timestamp;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

    Future<void> fetchPass() async {
      setState(() {
        isLoading = true;
        errorMessage = null;
        passData = null;
      });

      try {
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          passData = {
            "name": "KARAN NARENDRA POTE",
            "college": "BITSG",
            "type": "BITSIAN",
            "id": "Mx7U0KEksS45",
            "photo": null,
          };
        });
      } catch (e) {
        errorMessage = "Offline test failed";
      } finally {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B10),
      appBar: AppBar(
        title: Text(
          'Gate Pass',
          style: TextStyle(
            fontFamily: 'Orbitron_Regular',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Refresh Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF8F5BFF), width: 1.w),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: ElevatedButton(
                  onPressed: isLoading ? null : fetchPass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                  child: isLoading
                      ? LoadingAnimationWidget.fourRotatingDots(
                          color: const Color(0xFFB388FF),
                          size: 30.w,
                        )
                      : Text(
                          'Refresh Pass',
                          style: TextStyle(
                            fontFamily: 'Orbitron_Regular',
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24.h),

              // Error Message
              if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A0F14),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFFF3355)),
                  ),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      fontFamily: 'Orbitron_Regular',
                      fontSize: 14.sp,
                      color: const Color(0xFFFF3355),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Pass Data
              if (passData != null) ...[
                SizedBox(height: 24.h),

                // Pass Details Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141420).withOpacity(0.7),
                    border: Border.all(
                      color: const Color(0xFF8F5BFF).withOpacity(0.6),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pass Details',
                        style: TextStyle(
                          fontFamily: 'Orbitron_Regular',
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildDetailRow('Name', passData?["name"] ?? ""),
                      _buildDetailRow('College', passData?["college"] ?? ""),
                      _buildDetailRow('Type', passData?["type"] ?? ""),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Barcode Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141420).withOpacity(0.7),
                    border: Border.all(
                      color: const Color(0xFF8F5BFF).withOpacity(0.6),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Pass Barcode',
                        style: TextStyle(
                          fontFamily: 'Orbitron_Regular',
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: passData?["id"] ?? '',
                          width: 220.w,
                          height: 80.h,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontFamily: 'Orbitron_Regular',
                fontSize: 14.sp,
                color: const Color(0xFFB388FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Orbitron_Regular',
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error! Please try again later',
          style: TextStyle(fontFamily: 'Orbitron_Regular'),
        ),
        backgroundColor: const Color(0xFFFF3355),
      ),
    );
  }
}
