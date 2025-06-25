import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  List<Map<String, String>> allUsers = [];
  int farmerCount = 0;
  int agronomistCount = 0;
  int supplierCount = 0;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final agronomistResponse = await http.get(Uri.parse('http://10.0.2.2:5000/api/agronomist'));
      final farmerResponse = await http.get(Uri.parse('http://10.0.2.2:5000/api/farmer'));
      final supplierResponse = await http.get(Uri.parse('http://10.0.2.2:5000/api/supplier'));
      if (agronomistResponse.statusCode == 200 && farmerResponse.statusCode == 200 && supplierResponse.statusCode == 200) {
        final List<dynamic> agronomistData = json.decode(agronomistResponse.body);
        final List<dynamic> farmerData = json.decode(farmerResponse.body);
        final List<dynamic> supplierData = json.decode(supplierResponse.body);
        final agronomists = agronomistData
            .where((user) => user['role'] == 'agronomist' || user['role'] == null)
            .map<Map<String, String>>((user) => {
                  'name': user['names'] ?? '',
                  'email': user['organizationEmail'] ?? '',
                  'password': user['password'] ?? '',
                  'role': 'Agronomist',
                  'licensePath': user['licensePath'] ?? '',
                })
            .toList();
        final farmers = farmerData
            .map<Map<String, String>>((user) => {
                  'name': user['names'] ?? '',
                  'email': user['email'] ?? '',
                  'password': user['password'] ?? '',
                  'role': 'Farmer',
                  'district': user['district'] ?? '',
                  'sector': user['sector'] ?? '',
                  'cell': user['cell'] ?? '',
                  'village': user['village'] ?? '',
                })
            .toList();
        final suppliers = supplierData
            .map<Map<String, String>>((user) => {
                  'name': user['names'] ?? '',
                  'email': user['email'] ?? '',
                  'telephone': user['telephone'] ?? '',
                  'district': user['district'] ?? '',
                  'sector': user['sector'] ?? '',
                  'companyName': user['companyName'] ?? '',
                  'role': 'Supplier',
                })
            .toList();
        allUsers = [...agronomists, ...farmers, ...suppliers];
        farmerCount = farmers.length;
        agronomistCount = agronomists.length;
        supplierCount = suppliers.length;
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load users';
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

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      OverviewScreen(
        farmerCount: farmerCount,
        agronomistCount: agronomistCount,
        supplierCount: supplierCount,
        isLoading: isLoading,
        error: error,
      ),
      UserManagementScreen(
        allUsers: allUsers,
        isLoading: isLoading,
        error: error,
      ),
      const _ReportsScreen(),
    ];
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

class OverviewScreen extends StatelessWidget {
  final int farmerCount;
  final int agronomistCount;
  final int supplierCount;
  final bool isLoading;
  final String? error;
  const OverviewScreen({
    super.key,
    required this.farmerCount,
    required this.agronomistCount,
    required this.supplierCount,
    required this.isLoading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'System Statistics',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildStatCard('Farmers', farmerCount.toString(), Icons.person, Colors.blue),
                        _buildStatCard('Agronomists', agronomistCount.toString(), Icons.support_agent, Colors.orange),
                        _buildStatCard('Suppliers', supplierCount.toString(), Icons.store, Colors.purple),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Disease Hotspots',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: BarChart(BarChartData()), // Placeholder
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

class UserManagementScreen extends StatefulWidget {
  final List<Map<String, String>> allUsers;
  final bool isLoading;
  final String? error;
  const UserManagementScreen({
    super.key,
    required this.allUsers,
    required this.isLoading,
    required this.error,
  });

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRole = 'All';

  List<Map<String, String>> get allUsers => widget.allUsers;
  bool get isLoading => widget.isLoading;
  String? get error => widget.error;

  List<Map<String, String>> get filteredUsers {
    return allUsers.where((user) {
      final matchesRole =
          _selectedRole == 'All' || user['role'] == _selectedRole;
      final matchesSearch = user['name']!.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      return matchesRole && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              labelText: 'Search by name',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedRole,
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All Roles')),
                            DropdownMenuItem(value: 'Agronomist', child: Text('Agronomist')),
                            DropdownMenuItem(value: 'Farmer', child: Text('Farmer')),
                            DropdownMenuItem(value: 'Supplier', child: Text('Supplier')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildUserList(filteredUsers),
                  ],
                ),
    );
  }

  Widget _buildUserList(List<Map<String, String>> users) {
    if (users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No users found.'),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...users.map(
              (user) => ListTile(
                leading: Icon(
                  user['role'] == 'Farmer'
                      ? Icons.eco
                      : user['role'] == 'Supplier'
                          ? Icons.store
                          : Icons.science,
                ),
                title: Text(user['name']!),
                subtitle: Text(
                  user['role'] == 'Farmer'
                      ? "Email: ${user['email']!}\nDistrict: ${user['district'] ?? ''}\nSector: ${user['sector'] ?? ''}\nCell: ${user['cell'] ?? ''}\nVillage: ${user['village'] ?? ''}\nRole: ${user['role']!}"
                      : user['role'] == 'Supplier'
                          ? "Email: ${user['email']!}\nTelephone: ${user['telephone'] ?? ''}\nDistrict: ${user['district'] ?? ''}\nSector: ${user['sector'] ?? ''}\nCompany: ${user['companyName'] ?? ''}\nRole: ${user['role']!}"
                          : "Email: ${user['email']!}\nPassword: ${user['password']!}\nRole: ${user['role']!}",
                ),
                trailing: user['role'] == 'Agronomist' && user['licensePath'] != null && user['licensePath']!.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                        onPressed: () {
                          // Optionally, implement license viewing
                        },
                      )
                    : null,
                isThreeLine: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportsScreen extends StatelessWidget {
  const _ReportsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Generate detailed reports for regions, diseases, and date ranges.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate Report'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
