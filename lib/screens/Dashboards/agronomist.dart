import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../navibar/profile_page.dart';

class AgronomistDashboard extends StatefulWidget {
  const AgronomistDashboard({super.key});

  @override
  State<AgronomistDashboard> createState() => _AgronomistDashboardState();
}

class _AgronomistDashboardState extends State<AgronomistDashboard> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    _DashboardScreen(
      buildSummaryCards: _buildSummaryCards,
      buildDiseaseChart: _buildDiseaseChart,
    ),
    _FarmerManagementScreen(buildFarmerManagement: _buildFarmerManagement),
    _ReportScreen(buildReportGeneration: _buildReportGeneration),
    const ProfilePage(),
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
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Farmers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _summaryCard('Farmers', '128', Icons.people, Colors.blue),
        _summaryCard('Alerts', '5', Icons.warning, Colors.orange),
        _summaryCard('Reports', '23', Icons.assessment, Colors.purple),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseChart(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regional Disease Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: [
                    _makeGroupData(0, 5, color: Colors.red),
                    _makeGroupData(1, 8, color: Colors.orange),
                    _makeGroupData(2, 15, color: Colors.green),
                  ],
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(fontWeight: FontWeight.bold);
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Late Blight';
                              break;
                            case 1:
                              text = 'Early Blight';
                              break;
                            case 2:
                              text = 'Healthy';
                              break;
                            default:
                              text = '';
                              break;
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, {Color color = Colors.blue}) {
    return BarChartGroupData(
      x: x,
      barRods: [BarChartRodData(toY: y, color: color, width: 22)],
    );
  }

  Widget _buildFarmerManagement(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Farmers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _farmerTile('John Doe', '2 new detections'),
            _farmerTile('Jane Smith', 'No new alerts'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('VIEW ALL FARMERS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _farmerTile(String name, String status) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(status),
      trailing: ElevatedButton(
        onPressed: () {
          // TODO: Implement messaging
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text('Message', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildReportGeneration(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Generate weekly disease report for your region.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement report generation
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Generate', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Tab Screens ---

class _DashboardScreen extends StatelessWidget {
  final Widget Function() buildSummaryCards;
  final Widget Function(BuildContext) buildDiseaseChart;
  const _DashboardScreen({required this.buildSummaryCards, required this.buildDiseaseChart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Agronomist Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildSummaryCards(),
          const SizedBox(height: 20),
          buildDiseaseChart(context),
        ],
      ),
    );
  }
}

class _FarmerManagementScreen extends StatelessWidget {
  final Widget Function(BuildContext) buildFarmerManagement;
  const _FarmerManagementScreen({required this.buildFarmerManagement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Manage Farmers', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildFarmerManagement(context),
      ),
    );
  }
}

class _ReportScreen extends StatelessWidget {
  final Widget Function(BuildContext) buildReportGeneration;
  const _ReportScreen({required this.buildReportGeneration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildReportGeneration(context),
      ),
    );
  }
}
