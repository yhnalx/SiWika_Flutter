import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const SiWikaApp());
}

class SiWikaApp extends StatelessWidget {
  const SiWikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SiWika",
      theme: ThemeData(useMaterial3: true, fontFamily: "Roboto"),
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route: (_) => const SplashScreen(),
        SignUpScreen.route: (_) => const SignUpScreen(),
        DashboardScreen.route: (_) => const DashboardScreen(),
      },
    );
  }
}
