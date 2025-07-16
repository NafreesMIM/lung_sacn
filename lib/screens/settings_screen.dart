import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching external URLs

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Example state for a setting

  // --- Helper function to launch URLs ---
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  // --- Function to handle data reset ---
  Future<void> _resetAllData() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reset All Data?'),
          content: const Text(
              'This will delete all your saved assessment results and preferences. This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red button for destructive action
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Implement your data reset logic here:
      // Examples:
      // await SharedPreferences.getInstance().then((prefs) => prefs.clear());
      // await databaseHelper.clearAllTables(); // If you use a local database

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All app data has been reset.')),
        );
      }
      // You might want to navigate back to a home screen or re-initialize app state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // --- General Settings Section ---
          _buildSettingsSectionTitle('General'),
          ListTile(
            title: const Text('App Version'),
            subtitle: Text('1.0.0'), // Replace with actual app version
            leading: Icon(Icons.info_outline, color: Colors.teal[700]),
            onTap: () {
              // Optionally show About dialog or more version info
              showAboutDialog(
                context: context,
                applicationName: 'LungScan+',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 Your Company/Name',
                children: [
                  const Text('An offline Android application for lung cancer risk prediction using explainable machine learning.'),
                ],
              );
            },
          ),
          const Divider(),

          // --- Notifications Section (Example) ---
          _buildSettingsSectionTitle('Notifications'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive alerts for health tips and reminders.'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // Implement actual notification toggle logic here
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? 'Notifications ON' : 'Notifications OFF')),
                );
              }
            },
            secondary: Icon(Icons.notifications_active, color: Colors.teal[700]),
            activeColor: Colors.teal[700], // Teal color for active switch
          ),
          const Divider(),

          // --- Data & Privacy Section ---
          _buildSettingsSectionTitle('Data & Privacy'),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('Understand how your data is used and protected.'),
            leading: Icon(Icons.privacy_tip_outlined, color: Colors.teal[700]),
            onTap: () {
              // Replace with your actual Privacy Policy URL
              _launchURL('https://your-website.com/privacy-policy');
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            subtitle: const Text('Review the terms and conditions of using this app.'),
            leading: Icon(Icons.description_outlined, color: Colors.teal[700]),
            onTap: () {
              // Replace with your actual Terms of Service URL
              _launchURL('https://your-website.com/terms-of-service');
            },
          ),
          ListTile(
            title: const Text('Reset All App Data'),
            subtitle: const Text('Clear all saved assessments and app settings.'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: _resetAllData,
          ),
          const Divider(),

          // --- About Section ---
          _buildSettingsSectionTitle('About'),
          ListTile(
            title: const Text('Acknowledgements'),
            subtitle: const Text('Libraries and resources used in this app.'),
            leading: Icon(Icons.handshake_outlined, color: Colors.teal[700]),
            onTap: () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Acknowledgements screen not implemented.')),
                );
              }
              // Navigate to an Acknowledgements screen
            },
          ),
          ListTile(
            title: const Text('Send Feedback'),
            subtitle: const Text('Help us improve the app.'),
            leading: Icon(Icons.feedback_outlined, color: Colors.teal[700]),
            onTap: () {
              // Implement email launch or feedback form
              _launchURL('mailto:support@yourcompany.com?subject=LungScan%2B%20Feedback');
            },
          ),
        ],
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSettingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal[800],
        ),
      ),
    );
  }
}