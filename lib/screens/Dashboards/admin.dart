import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    _OverviewScreen(),
    _UserManagementScreen(),
    _ReportsScreen(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
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

class _UserManagementScreen extends StatelessWidget {
  const _UserManagementScreen();

  // Mock data for users
  final List<Map<String, String>> farmers = const [
    {'name': 'John Doe', 'email': 'farmer@gmail.com', 'password': 'farmer@123'},
    {'name': 'Jane Smith', 'email': 'jane.s@example.com', 'password': 'password456'},
  ];

  final List<Map<String, String>> agronomists = const [
    {'name': 'Dr. Emily Carter', 'email': 'agronomist@gmail.com', 'password': 'agronomist@123'},
  ];

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
          _buildUserList('Farmers', Icons.eco, farmers),
          const SizedBox(height: 20),
          _buildUserList('Agronomists', Icons.science, agronomists),
        ],
      ),
    );
  }

  Widget _buildUserList(String title, IconData icon, List<Map<String, String>> users) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...users.map((user) => ListTile(
              leading: Icon(icon),
              title: Text(user['name']!),
              subtitle: Text("Email: ${user['email']}\nPassword: ${user['password']}"),
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
