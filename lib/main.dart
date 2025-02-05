import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'WatchedMovieLog/database.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = MovieDatabase();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final MovieDatabase database;

  const MyApp({
    Key? key,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogItAll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        movieDatabase: database,
      ),
    );
  }
}