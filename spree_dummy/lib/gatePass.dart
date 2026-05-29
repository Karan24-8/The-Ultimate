import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class GatePassScreen extends StatelessWidget {
  const GatePassScreen({super.key});

  // 🔥 Hardcoded values (edit these later)
  static const String dummyName = "Karan Pote";
  static const String dummyCollege = "XYZ Engineering College";
  static const String dummyType = "Participant";
  static const String dummyBarcodeValue = "DUMMY_PASS_123456";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text("Gate Pass"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 👤 Photo Placeholder
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                size: 100,
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 24),

            // 📋 Pass Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Pass Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Name: Karan Pote",
                      style: TextStyle(color: Colors.white)),
                  Text("College: XYZ Engineering College",
                      style: TextStyle(color: Colors.white)),
                  Text("Type: Participant",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔳 Barcode Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Pass Barcode",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: dummyBarcodeValue,
                      width: 250,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}