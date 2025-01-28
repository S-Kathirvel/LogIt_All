import 'package:flutter/material.dart';
import 'home_page.dart';
import 'WatchedMovieLog/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = MovieDatabase();
  database.addDummyData(); 
  runApp(MyApp(movieDatabase: database));
}

class MyApp extends StatelessWidget {
  final MovieDatabase movieDatabase;

  MyApp({required this.movieDatabase, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watched Movies Log',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: ShowMoviesPage(database: movieDatabase),
    );
  }
}