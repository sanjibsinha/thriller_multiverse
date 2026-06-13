import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_open,
            size: 60,
            color: Color(0xFFD32F2F), // Signature Red
          ),
          const SizedBox(height: 20),
          const Text(
            'ডেটাবেস আনলকড',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'ওপেন সোর্স মুভমেন্ট। লেখা থেকে ওয়েব ডিজাইন—পুরো সিস্টেমটাই ওপেন সোর্স ফিলোজফিতে তৈরি। নো পে-ওয়াল। নো সাবস্ক্রিপশন। বিক্রম, মতিলাল আর পিজি-র ডার্ক ক্রাইম ফাইলগুলো সবার জন্য ১০০% ফ্রি।',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          const Divider(color: Color(0xFF2C2C2C), thickness: 1.5),
          const SizedBox(height: 40),
          
          const Text(
            'সাপোর্ট করুন',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          
          // Updated QR Code Box with Original Image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white, // White background so the QR is easily scannable
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFFD32F2F), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/qr_code.png', // Ensure the name exactly matches your file
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('ইমেজ লোড হয়নি', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '9831657474@ybl', // এখানে আপনার আসল UPI ID বসিয়ে নেবেন
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD32F2F),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}