import 'package:flutter/material.dart';
import 'screens/landingpage.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';
import 'screens/auth/forgotpassword.dart';

void main() {
  runApp(const PotatoDiseaseApp());
}

class PotatoDiseaseApp extends StatelessWidget {
  const PotatoDiseaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potato Disease Detection',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgotpassword': (context) => const ForgotPasswordPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}