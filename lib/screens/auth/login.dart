import 'package:flutter/material.dart';

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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() => isLoading = true);

                            // Static credentials
                            final credentials = {
                              'farmer@gmail.com': 'farmer@123',
                              'agronomist@gmail.com': 'agronomist@123',
                              'admin@gmail.com': 'admin@123',
                            };

                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() => isLoading = false);

                              if (credentials[email.trim()] ==
                                  password.trim()) {
                                // Navigate to respective dashboard
                                if (email.trim() == 'farmer@gmail.com') {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/farmer_dashboard',
                                  );
                                } else if (email.trim() ==
                                    'agronomist@gmail.com') {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/agronomist_dashboard',
                                  );
                                } else if (email.trim() == 'admin@gmail.com') {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/admin_dashboard',
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid email or password'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                const SizedBox(height: 16),
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
