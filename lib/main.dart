// main.dart (MAKE SURE THIS EXISTS)
import 'package:flutter/material.dart';
import 'package:pie/screens/introduction_screen.dart';
import 'package:pie/screens/login_screen.dart';
import 'package:pie/screens/splash_screen.dart';
import 'package:pie/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/intro': (_) => const IntroScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(), // ✅ MUST BE PRESENT
      },
      home: const SplashScreen(),
    );
  }
}