import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool isLoading = false;
  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
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
                const Text(
                  'Enter your email to receive password reset instructions.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter your email' : null,
                  onSaved: (value) => email = value ?? '',
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
                              setState(() {
                                isLoading = true;
                              });
                              // TODO: Implement password reset logic
                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  isLoading = false;
                                  isSent = true;
                                });
                              });
                            }
                          },
                          child: const Text(
                            'Send Reset Link',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                if (isSent)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'A password reset link has been sent to your email.',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}