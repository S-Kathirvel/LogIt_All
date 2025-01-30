import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
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
      } else if (format == 'json') {
        await _exportToJson(movies, filePath);
      } else {
        await _exportToExcel(movies, filePath);
      }

      setState(() {
        _lastExportPath = filePath;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
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

  Future<void> _exportToJson(List<Map<String, dynamic>> movies, String filePath) async {
    final jsonString = jsonEncode(movies);
    final file = File(filePath);
    await file.writeAsString(jsonString);
  }

  Future<void> _exportToExcel(List<Map<String, dynamic>> movies, String filePath) async {
    final excel = Excel.createExcel();
    final sheet = excel['Movies'];

    // Add headers with style
    final headers = ['Name', 'Year', 'Genre', 'Rating', 'Date Added'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
      );
    }

    // Add data
    for (var i = 0; i < movies.length; i++) {
      final movie = movies[i];
      final row = i + 1;
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = TextCellValue(movie['name']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        .value = TextCellValue(movie['year'].toString());
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
        .value = TextCellValue(movie['genre']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
        .value = TextCellValue(movie['rating'].toString());
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
        .value = TextCellValue(movie['dateAdded'] ?? '');
    }

    // Set column widths
    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 15.0);
    }

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _exportToFile('csv'),
              child: Text('Export as CSV'),
            ),
            ElevatedButton(
              onPressed: () => _exportToFile('json'),
              child: Text('Export as JSON'),
            ),
            ElevatedButton(
              onPressed: () => _exportToFile('xlsx'),
              child: Text('Export as XLSX'),
            ),
            if (_isExporting)
              CircularProgressIndicator(),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_lastExportPath != null)
              Text('Last exported to: $_lastExportPath'),
          ],
        ),
      ),
    );
  }
}
