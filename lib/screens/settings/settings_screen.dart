import 'package:flutter/material.dart';
import 'package:unitime/utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Settings',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopCard(context),
            const SizedBox(height: 24),
            Text('Settings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
            const SizedBox(height: 10),
            _buildSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.school, size: 30, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text('My Courses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text('Version 5.1.2',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: Text('GO TO Premium with My Courses',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSettingsItem(Icons.color_lens_outlined, 'Theme Color',
              trailing: Icon(Icons.arrow_forward_ios, size: 16)),
          const Divider(height: 1),
          _buildSettingsItem(Icons.language_outlined, 'Change Language',
              trailing: Icon(Icons.arrow_forward_ios, size: 16)),
          const Divider(height: 1),
          _buildSettingsItem(Icons.cloud_upload_outlined, 'Create Backup File',
              trailing: Icon(Icons.lock_outline, size: 18)),
          const Divider(height: 1),
          _buildSettingsItem(Icons.restore_outlined, 'Restore Date',
              trailing: Icon(Icons.lock_outline, size: 18)),
          const Divider(height: 1),
          _buildSettingsItem(Icons.notifications_off_outlined,
              'Cancel All Scheduled Notifications',
              trailing: Icon(Icons.arrow_forward_ios, size: 16)),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: trailing,
      onTap: () {},
    );
  }
}
