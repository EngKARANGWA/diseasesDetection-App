import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../services/agro_regstitor.dart';

class AgronomistRegisterPage extends StatefulWidget {
  const AgronomistRegisterPage({super.key});

  @override
  State<AgronomistRegisterPage> createState() => _AgronomistRegisterPageState();
}

class _AgronomistRegisterPageState extends State<AgronomistRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String names = '';
  String telephone = '';
  String district = '';
  String sector = '';
  String organizationEmail = '';
  String password = '';
  File? licenseFile;
  bool isLoading = false;

  Future<void> _pickLicenseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        licenseFile = File(result.files.single.path!);
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && licenseFile != null) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);
      final agroDb = AgroRegistitor();
      final existing = await agroDb.getAgronomistByEmail(organizationEmail);
      if (existing != null) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An agronomist with this email already exists.'),
          ),
        );
        return;
      }
      final agronomist = Agronomist(
        names: names,
        telephone: telephone,
        district: district,
        sector: sector,
        organizationEmail: organizationEmail,
        licensePath: licenseFile!.path,
        password: password,
      );
      await agroDb.insertAgronomist(agronomist);
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else if (licenseFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a license/certificate.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Agronomist',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Names',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Enter names' : null,
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
                              ? 'Enter telephone number'
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
                              ? 'Enter district'
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
                              ? 'Enter sector'
                              : null,
                  onSaved: (value) => sector = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Organization Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter organization email'
                              : null,
                  onSaved: (value) => organizationEmail = value ?? '',
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickLicenseFile,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'License/Certificate',
                      prefixIcon: Icon(Icons.upload_file),
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      children: [
                        if (licenseFile == null)
                          const Text(
                            'Tap to select file',
                            style: TextStyle(color: Colors.grey),
                          ),
                        if (licenseFile != null) ...[
                          if (licenseFile!.path.endsWith('.jpg') ||
                              licenseFile!.path.endsWith('.jpeg') ||
                              licenseFile!.path.endsWith('.png'))
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.file(
                                licenseFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            const Icon(Icons.picture_as_pdf, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              licenseFile!.path.split('/').last,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => setState(() => licenseFile = null),
                          ),
                        ],
                      ],
                    ),
                  ),
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
                              ? 'Enter password'
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
                        ),
                        onPressed: _submit,
                        child: const Text(
                          'Signup',
                          style: TextStyle(color: Colors.white),
                        ),
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
