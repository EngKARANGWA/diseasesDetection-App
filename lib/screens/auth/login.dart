import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  String userType = 'farmer'; // default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Set icon color to white
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/irishpotatoes.jpeg',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: userType,
                  decoration: const InputDecoration(
                    labelText: 'Select User Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'farmer', child: Text('Farmer')),
                    DropdownMenuItem(value: 'agronomist', child: Text('Agronomist')),
                    DropdownMenuItem(value: 'supplier', child: Text('Supplier')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter your email'
                              : null,
                  onSaved: (value) => email = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter your password'
                              : null,
                  onSaved: (value) => password = value ?? '',
                ),
                const SizedBox(height: 24),
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() => isLoading = true);
                              String apiUrl = '';
                              String dashboardRoute = '';
                              if (userType == 'farmer') {
                                apiUrl = 'http://10.0.2.2:5000/api/farmer/login';
                                dashboardRoute = '/farmer_dashboard';
                              } else if (userType == 'agronomist') {
                                apiUrl = 'http://10.0.2.2:5000/api/agronomist/login';
                                dashboardRoute = '/agronomist_dashboard';
                              } else if (userType == 'supplier') {
                                apiUrl = 'http://10.0.2.2:5000/api/supplier/login';
                                dashboardRoute = '/supplier_dashboard';
                              } else if (userType == 'admin') {
                                setState(() => isLoading = false);
                                if (email.trim() == 'admin@gmail.com' && password.trim() == 'admin@123') {
                                  Navigator.pushReplacementNamed(context, '/admin_dashboard');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Invalid admin credentials')),
                                  );
                                }
                                return;
                              }
                              try {
                                final response = await http.post(
                                  Uri.parse(apiUrl),
                                  headers: {'Content-Type': 'application/json'},
                                  body: json.encode({
                                    'email': email.trim(),
                                    'password': password.trim(),
                                  }),
                                );
                                setState(() => isLoading = false);
                                if (response.statusCode == 200 || response.statusCode == 201) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    dashboardRoute,
                                  );
                                } else {
                                  final errorMsg = json.decode(response.body)['message'] ?? 'Login failed.';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(errorMsg)),
                                  );
                                }
                              } catch (e) {
                                setState(() => isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgotpassword');
                  },
                  child: const Text('Forgot password?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
