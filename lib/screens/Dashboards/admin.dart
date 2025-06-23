import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../auth/agronomistregistor.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const _OverviewScreen(),
    AgronomistRegisterPage(),
    const _UserManagementScreen(),
    const _ReportsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add Agronomist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

class _OverviewScreen extends StatelessWidget {
  const _OverviewScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('System Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatCard('Farmers', '128', Icons.person, Colors.blue),
              _buildStatCard('Agronomists', '12', Icons.support_agent, Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Disease Hotspots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData()), // Placeholder
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserManagementScreen extends StatefulWidget {
  const _UserManagementScreen();

  @override
  State<_UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<_UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRole = 'All';

  final List<Map<String, String>> allUsers = [
    {'name': 'John Doe', 'email': 'farmer@gmail.com', 'password': 'farmer@123', 'role': 'Farmer'},
    {'name': 'Jane Smith', 'email': 'jane.s@example.com', 'password': 'password456', 'role': 'Farmer'},
    {'name': 'Dr. Emily Carter', 'email': 'agronomist@gmail.com', 'password': 'agronomist@123', 'role': 'Agronomist'},
  ];

  List<Map<String, String>> get filteredUsers {
    return allUsers.where((user) {
      final matchesRole = _selectedRole == 'All' || user['role'] == _selectedRole;
      final matchesSearch = user['name']!.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesRole && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
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
                  DropdownMenuItem(value: 'Farmer', child: Text('Farmer')),
                  DropdownMenuItem(value: 'Agronomist', child: Text('Agronomist')),
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
      return const Center(child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text('No users found.'),
      ));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...users.map((user) => ListTile(
              leading: Icon(user['role'] == 'Farmer' ? Icons.eco : Icons.science),
              title: Text(user['name']!),
              subtitle: Text("Email: "+user['email']!+"\nPassword: "+user['password']!+"\nRole: "+user['role']!),
              trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              isThreeLine: true,
            )),
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
              const Text('Generate detailed reports for regions, diseases, and date ranges.', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate Report'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
