import 'package:datingapp/pages/landingPage.dart';
import 'package:datingapp/pages/loginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        // Add more routes as needed
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
