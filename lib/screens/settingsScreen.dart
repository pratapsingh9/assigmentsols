import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool darkThemeMode = false;
    return Scaffold(
      appBar: AppBar(
        title:const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Scan Duration'),
            subtitle: Text('4 seconds'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: const Text('Swtich Theme'),
            trailing: Switch(
              value: darkThemeMode,
              onChanged: (bool value) {
                // Implement beacon filtering
                darkThemeMode = !darkThemeMode;
              },
            ),
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {
              // Show about dialog
            },
          ),
        ],
      ),
    );
  }
}
