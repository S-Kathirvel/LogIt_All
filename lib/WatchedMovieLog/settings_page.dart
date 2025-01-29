import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'database.dart';
import 'edit_database_page.dart';

class SettingsPage extends StatefulWidget {
  final MovieDatabase database;

  SettingsPage({required this.database});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _isExporting = false;

  Future<void> _exportToFile(String format) async {
    setState(() => _isExporting = true);

    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission denied');
      }

      // Get movies from database
      final movies = await widget.database.getAllMovies();
      if (movies.isEmpty) {
        throw Exception('No movies to export');
      }

      // Get download directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access storage');
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final fileName = 'watched_movies_$timestamp.$format';
      final filePath = '${directory.path}/$fileName';

      if (format == 'csv') {
        await _exportToCsv(movies, filePath);
      } else {
        await _exportToExcel(movies, filePath);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully exported to $filePath'),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OPEN',
              onPressed: () {
                // Open file explorer to the exported file
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportToCsv(List<Map<String, dynamic>> movies, String filePath) async {
    final csvData = [
      ['Name', 'Year', 'Genre', 'Rating', 'Date Added'], // Header
      ...movies.map((movie) => [
        movie['name'],
        movie['year'],
        movie['genre'],
        movie['rating'],
        movie['date_of_entry'],
      ]),
    ];

    final csvString = ListToCsvConverter().convert(csvData);
    final file = File(filePath);
    await file.writeAsString(csvString);
  }

  Future<void> _exportToExcel(List<Map<String, dynamic>> movies, String filePath) async {
    final excel = Excel.createExcel();
    final sheet = excel['Movies'];

    // Add header
    sheet.appendRow(['Name', 'Year', 'Genre', 'Rating', 'Date Added']);

    // Add data
    for (var movie in movies) {
      sheet.appendRow([
        movie['name'],
        movie['year'],
        movie['genre'],
        movie['rating'],
        movie['date_of_entry'],
      ]);
    }

    // Auto-fit columns
    for (var col in sheet.columns) {
      sheet.setColAutoFit(col);
    }

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose export format:'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.description),
                  label: Text('CSV'),
                  onPressed: () {
                    Navigator.pop(context);
                    _exportToFile('csv');
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.table_chart),
                  label: Text('Excel'),
                  onPressed: () {
                    Navigator.pop(context);
                    _exportToFile('xlsx');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          if (_isExporting)
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SwitchListTile(
                  title: Text('Dark Mode'),
                  subtitle: Text('Toggle dark theme'),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() => _isDarkMode = value);
                    // TODO: Implement theme change using provider or other state management
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Database',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Database'),
                  subtitle: Text('Modify or delete movie entries'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDatabasePage(database: widget.database),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.upload_file),
                  title: Text('Export Database'),
                  subtitle: Text('Export as CSV or Excel file'),
                  onTap: _showExportDialog,
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'About',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
