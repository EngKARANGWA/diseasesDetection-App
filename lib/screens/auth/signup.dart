import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/db_helper.dart';
import 'agronomistregistor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String names = '';
  String telephone = '';
  String district = '';
  String sector = '';
  String cell = '';
  String village = '';
  String companyName = '';
  bool isLoading = false;
  String userType = 'farmer'; // default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
              ],
              onChanged: (value) {
                if (value == 'agronomist') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AgronomistRegisterPage(),
                    ),
                  );
                } else {
                  setState(() {
                    userType = value!;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            // Show the correct form based on userType
            if (userType == 'farmer')
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Names',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter your names'
                                  : null,
                      onSaved: (value) => names = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Telephone',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter your telephone number'
                                  : null,
                      onSaved: (value) => telephone = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'District',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter your district'
                                  : null,
                      onSaved: (value) => district = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Sector',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter your sector'
                                  : null,
                      onSaved: (value) => sector = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Cell',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter your cell'
                                  : null,
                      onSaved: (value) => cell = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Village',
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter your village'
                                  : null,
                      onSaved: (value) => village = value ?? '',
                    ),
                    const SizedBox(height: 16),
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
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              final form = _formKey.currentState;
                              if (form != null && form.validate()) {
                                form.save();
                                setState(() => isLoading = true);
                                try {
                                  print('password: $password, confirmPassword: $confirmPassword');
                                  final response = await http.post(
                                    Uri.parse('http://10.0.2.2:5000/api/farmer/signup'),
                                    headers: {'Content-Type': 'application/json'},
                                    body: json.encode({
                                      'names': names,
                                      'telephone': telephone,
                                      'district': district,
                                      'sector': sector,
                                      'cell': cell,
                                      'village': village,
                                      'email': email,
                                      'password': password,
                                      'confirmPassword': password,
                                    }),
                                  );
                                  setState(() => isLoading = false);
                                  if (response.statusCode == 201 || response.statusCode == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Registration successful! Please login.'),
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(context, '/login');
                                  } else {
                                    final errorMsg = json.decode(response.body)['message'] ?? 'Registration failed.';
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
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            if (userType == 'supplier')
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Names',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter your names' : null,
                      onSaved: (value) => names = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Telephone',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Enter your telephone number' : null,
                      onSaved: (value) => telephone = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'District',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter your district' : null,
                      onSaved: (value) => district = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Sector',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter your sector' : null,
                      onSaved: (value) => sector = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter your company name' : null,
                      onSaved: (value) => companyName = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || value.isEmpty ? 'Enter your email' : null,
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
                      validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
                      onSaved: (value) => password = value ?? '',
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () async {
                                final form = _formKey.currentState;
                                if (form != null && form.validate()) {
                                  form.save();
                                  setState(() => isLoading = true);
                                  try {
                                    final response = await http.post(
                                      Uri.parse('http://10.0.2.2:5000/api/supplier/signup'),
                                      headers: {'Content-Type': 'application/json'},
                                      body: json.encode({
                                        'names': names,
                                        'telephone': telephone,
                                        'district': district,
                                        'sector': sector,
                                        'companyName': companyName,
                                        'email': email,
                                        'password': password,
                                        'confirmPassword': password,
                                      }),
                                    );
                                    setState(() => isLoading = false);
                                    if (response.statusCode == 201 || response.statusCode == 200) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Registration successful! Please login.'),
                                        ),
                                      );
                                      Navigator.pushReplacementNamed(context, '/login');
                                    } else {
                                      final errorMsg = json.decode(response.body)['message'] ?? 'Registration failed.';
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
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
