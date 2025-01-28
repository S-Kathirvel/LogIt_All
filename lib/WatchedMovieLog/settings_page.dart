import 'package:flutter/material.dart';
import 'database.dart';

class SettingsPage extends StatefulWidget {
  final MovieDatabase database;

  SettingsPage({required this.database});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                  // Here you can implement the logic to toggle the app theme
                });
              },
            ),
            ListTile(
              title: Text('Edit Database'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditDatabasePage(database: widget.database)),
                );
              },
            ),
            ListTile(
              title: Text('Export Database'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExportDatabasePage(database: widget.database)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditDatabasePage extends StatefulWidget {
  final MovieDatabase database;

  EditDatabasePage({required this.database});

  @override
  _EditDatabasePageState createState() => _EditDatabasePageState();
}

class _EditDatabasePageState extends State<EditDatabasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Database')),
      body: Center(
        child: Text('Edit Database Page'),
      ),
    );
  }
}

class ExportDatabasePage extends StatefulWidget {
  final MovieDatabase database;

  ExportDatabasePage({required this.database});

  @override
  _ExportDatabasePageState createState() => _ExportDatabasePageState();
}

class _ExportDatabasePageState extends State<ExportDatabasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Export Database')),
      body: Center(
        child: Text('Export Database Page'),
      ),
    );
  }
}
