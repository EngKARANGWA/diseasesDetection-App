import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 20),
          _buildSettingsList(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.green,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.green),
          ),
          const SizedBox(height: 12),
          const Text(
            'John Doe', // Mock data
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'farmer@gmail.com', // Mock data
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to Edit Profile screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          context,
          icon: Icons.notifications,
          title: 'Notifications',
          onTap: () {},
        ),
        _buildSettingsTile(
          context,
          icon: Icons.lock,
          title: 'Change Password',
          onTap: () {},
        ),
        _buildSettingsTile(
          context,
          icon: Icons.help,
          title: 'Help & Support',
          onTap: () {},
        ),
        const Divider(),
        _buildSettingsTile(
          context,
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          isLogout: true,
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.green),
      title: Text(
        title,
        style: TextStyle(color: isLogout ? Colors.red : Colors.black87),
      ),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
} 