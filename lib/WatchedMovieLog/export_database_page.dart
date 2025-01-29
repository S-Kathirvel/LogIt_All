import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'database.dart';

class ExportDatabasePage extends StatefulWidget {
  final MovieDatabase database;

  ExportDatabasePage({required this.database});

  @override
  _ExportDatabasePageState createState() => _ExportDatabasePageState();
}

class _ExportDatabasePageState extends State<ExportDatabasePage> {
  bool _isExporting = false;
  String? _lastExportPath;
  String? _errorMessage;

  Future<void> _exportToFile(String format) async {
    setState(() {
      _isExporting = true;
      _errorMessage = null;
      _lastExportPath = null;
    });

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

      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final fileName = 'watched_movies_$timestamp.$format';
      final filePath = '${directory.path}/$fileName';

      if (format == 'csv') {
        await _exportToCsv(movies, filePath);
      } else {
        await _exportToExcel(movies, filePath);
      }

      setState(() {
        _lastExportPath = filePath;
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully exported to $filePath'),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OPEN',
            onPressed: () {
              // TODO: Implement file opening functionality
            },
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    } finally {
      setState(() {
        _isExporting = false;
      });
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

    // Add header with style
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: '#CCCCCC',
      horizontalAlign: HorizontalAlign.Center,
    );

    final headers = ['Name', 'Year', 'Genre', 'Rating', 'Date Added'];
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = headers[i]
        ..cellStyle = headerStyle;
    }

    // Add data
    for (var i = 0; i < movies.length; i++) {
      final movie = movies[i];
      final row = i + 1;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        ..value = movie['name'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        ..value = movie['year'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
        ..value = movie['genre'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
        ..value = movie['rating'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
        ..value = movie['date_of_entry'];
    }

    // Auto-fit columns
    for (var col in sheet.columns) {
      sheet.setColAutoFit(col);
    }

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export Database'),
        actions: [
          if (_isExporting)
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Options',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Choose a format to export your movie database:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.description),
                            label: Text('Export as CSV'),
                            onPressed: _isExporting ? null : () => _exportToFile('csv'),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.table_chart),
                            label: Text('Export as Excel'),
                            onPressed: _isExporting ? null : () => _exportToFile('xlsx'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessage != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                ),
              ),
            if (_lastExportPath != null)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Export',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(_lastExportPath!),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Export Formats',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: Text('CSV Format'),
                        subtitle: Text('Simple, widely compatible format. Best for importing into other applications.'),
                      ),
                      ListTile(
                        leading: Icon(Icons.table_chart),
                        title: Text('Excel Format'),
                        subtitle: Text('Rich formatting with headers and column sizing. Best for viewing and analysis.'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
