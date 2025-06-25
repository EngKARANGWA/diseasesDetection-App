import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SupplierDashboard extends StatefulWidget {
  const SupplierDashboard({super.key});

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard> {
  List<Map<String, dynamic>> medicines = [];
  bool isLoading = true;
  String? error;
  // For demo, use a static supplierId. In real app, get from logged-in user.
  final String supplierId = 'YOUR_SUPPLIER_ID';

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/medicine?supplierId=$supplierId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        medicines = data.cast<Map<String, dynamic>>();
        setState(() => isLoading = false);
      } else {
        setState(() {
          error = 'Failed to load medicines';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> addMedicine(Map<String, dynamic> med) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/medicine'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({...med, 'supplierId': supplierId}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchMedicines();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medicine added!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add medicine.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void showAddMedicineDialog() {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    String quantity = '';
    String price = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medicine'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => name = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (v) => description = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter quantity' : null,
                onSaved: (v) => quantity = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
                onSaved: (v) => price = v ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                addMedicine({
                  'name': name,
                  'description': description,
                  'quantity': int.tryParse(quantity) ?? 0,
                  'price': double.tryParse(price) ?? 0.0,
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Your Medicines', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ElevatedButton.icon(
                            onPressed: showAddMedicineDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Medicine'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: medicines.isEmpty
                          ? const Center(child: Text('No medicines found.'))
                          : ListView.builder(
                              itemCount: medicines.length,
                              itemBuilder: (context, i) {
                                final med = medicines[i];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    title: Text(med['name'] ?? ''),
                                    subtitle: Text('Description: ${med['description'] ?? ''}\nQuantity: ${med['quantity'] ?? ''}\nPrice: ${med['price'] ?? ''}'),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
} 