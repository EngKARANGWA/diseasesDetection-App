import 'package:flutter/material.dart';
import 'screens/landingpage.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';
import 'screens/auth/forgotpassword.dart';
import 'screens/Dashboards/farmer.dart'; // Import the FarmerDashboard screen
import 'screens/Dashboards/farmer_home.dart'; // Import the FarmerHome screen
import 'screens/Dashboards/agronomist.dart';
import 'screens/Dashboards/admin.dart';
import 'screens/navibar/historypage.dart';

void main() {
  runApp(const PotatoDiseaseApp());
}

class PotatoDiseaseApp extends StatelessWidget {
  const PotatoDiseaseApp({super.key});

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
        '/farmer_dashboard': (context) => const FarmerHome(), // Use FarmerHome with bottom navigation
        '/agronomist_dashboard': (context) => const AgronomistDashboard(),
        '/admin_dashboard': (context) => const AdminDashboard(),
        '/history': (context) => const HistoryPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}