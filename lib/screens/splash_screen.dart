import 'dart:async';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = "/";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, SignUpScreen.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your actual logo asset if you already have it
            // Image.asset("assets/siwika_logo.png", width: 180),
            const Icon(
              Icons.waving_hand_rounded,
              size: 90,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              "SiWika",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4B74FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
