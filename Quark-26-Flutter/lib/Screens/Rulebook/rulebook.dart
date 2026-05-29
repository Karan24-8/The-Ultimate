import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class Rulebook extends StatefulWidget {
  const Rulebook({super.key});

  @override
  State<Rulebook> createState() => _RulebookState();
}

class _RulebookState extends State<Rulebook> {
  int _reloadKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Rulebook",
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 40.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 32.r,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('RuleBook').snapshots(),
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Firestore Error (Likely no internet to fetch link)
          if (snapshot.hasError) {
            return _buildMessage(
              "Unable to connect to Database.\nPlease check your internet connection.",
              Icons.wifi_off,
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Rulebook found. If Offline Connect to Internet", style: TextStyle(color: Colors.white)));
          }

          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final String pdfUrl = data['Link'] ?? '';

          if (pdfUrl.isEmpty) {
            return const Center(child: Text("PDF Link is empty"));
          }

          // 3. PDF View
          return Container(
            key: ValueKey(_reloadKey),
            child: const PDF().cachedFromUrl(
              pdfUrl,
              placeholder: (progress) => Center(
                child: Text(
                  '$progress %',
                  style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
              ),
              // 4. PDF Download Error (Likely no internet to download file)
              errorWidget: (error) => _buildMessage(
                "Could not load PDF.\nPlease check your internet connection.",
                Icons.signal_wifi_connected_no_internet_4,
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper widget to show the message and retry button
  Widget _buildMessage(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60.r, color: Colors.grey),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _reloadKey++; // Triggers a rebuild to try again
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }
}