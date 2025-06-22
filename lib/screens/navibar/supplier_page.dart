import 'package:flutter/material.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allSuppliers = [];
  List<Map<String, dynamic>> _filteredSuppliers = [];

  // Mock supplier data
  @override
  void initState() {
    super.initState();
    _allSuppliers = [
      {
        'name': 'GreenHarvest Supplies',
        'location': 'Kigali, Rwanda',
        'phone': '+250 788 123 456',
        'products': ['Organic Fungicides', 'Pesticides', 'Fertilizers'],
        'image': 'assets/supplier1.png', // Placeholder
      },
      {
        'name': 'CropCare Solutions',
        'location': 'Musanze, Rwanda',
        'phone': '+250 788 789 012',
        'products': ['Chemical Pesticides', 'Herbicides', 'Growth Boosters'],
        'image': 'assets/supplier2.png', // Placeholder
      },
      {
        'name': 'FarmWell Hub',
        'location': 'Huye, Rwanda',
        'phone': '+250 788 345 678',
        'products': ['Seeds', 'Organic Pesticides', 'Farm Tools'],
        'image': 'assets/supplier3.png', // Placeholder
      },
    ];
    _filteredSuppliers = _allSuppliers;
    _searchController.addListener(_filterSuppliers);
  }

  void _filterSuppliers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSuppliers = _allSuppliers.where((supplier) {
        return supplier['name'].toLowerCase().contains(query) ||
            supplier['location'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Pesticide Suppliers', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _filteredSuppliers.isEmpty
                ? _buildEmptyState()
                : _buildSupplierList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name or location...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSupplierList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredSuppliers.length,
      itemBuilder: (context, index) {
        final supplier = _filteredSuppliers[index];
        return _buildSupplierCard(supplier);
      },
    );
  }

  Widget _buildSupplierCard(Map<String, dynamic> supplier) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.store, size: 40, color: Colors.green), // Placeholder
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        supplier['location'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            const Text(
              'Available Products:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: (supplier['products'] as List<String>).map((product) {
                return Chip(
                  label: Text(product),
                  backgroundColor: Colors.green[100],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement call functionality
                },
                icon: const Icon(Icons.call),
                label: Text('Call ${supplier['phone']}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No suppliers found.',
        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
      ),
    );
  }
} 