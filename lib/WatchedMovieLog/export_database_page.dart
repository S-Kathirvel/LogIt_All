import 'package:flutter/material.dart';
import 'database.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExportDatabasePage extends StatelessWidget {
  final MovieDatabase database;

  ExportDatabasePage({required this.database});

  Future<void> exportDatabase() async {
    final String csvData = ListToCsvConverter().convert(await database.getMovies().then((movies) => movies.map((movie) => [movie.name, movie.yearOfRelease, movie.genres.join(','), movie.dateWatched.toIso8601String(), movie.rating]).toList()));
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/movies.csv';
    final file = File(path);
    await file.writeAsString(csvData);
    print('Database exported to $path'); // Log the path for confirmation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Export Database')), 
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await exportDatabase();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Database exported successfully!')));
          },
          child: Text('Export to CSV'),
        ),
      ),
    );
  }
}
