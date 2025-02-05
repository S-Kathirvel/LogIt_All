import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'database.dart';

class ExportDatabasePage extends StatefulWidget {
  final MovieDatabase database;

  const ExportDatabasePage({
    Key? key,
    required this.database,
  }) : super(key: key);

  @override
  _ExportDatabasePageState createState() => _ExportDatabasePageState();
}

class _ExportDatabasePageState extends State<ExportDatabasePage> {
  bool _isExporting = false;

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _exportToCSV() async {
    setState(() => _isExporting = true);

    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission is required to export database'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final movies = await widget.database.getMovies();
      final csvData = [
        ['Name', 'Genre', 'Rating', 'Date Added'], // Header
        ...movies.map((movie) => [
              movie['name'],
              movie['genre'],
              movie['rating'].toString(),
              movie['date_of_entry'],
            ]),
      ];

      final csvString = const ListToCsvConverter().convert(csvData);
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw Exception('Could not access external storage');

      final file = File('${directory.path}/movies_export.csv');
      await file.writeAsString(csvString);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database exported to: ${file.path}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export database: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Database'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Export to CSV'),
              subtitle: const Text(
                'Export your movie database to a CSV file that can be opened in Excel or Google Sheets',
              ),
              trailing: _isExporting
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.file_download),
              onTap: _isExporting ? null : _exportToCSV,
            ),
          ),
        ],
      ),
    );
  }
}
