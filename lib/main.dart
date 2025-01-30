import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'home_page.dart';
import 'WatchedMovieLog/database.dart';
import 'WatchedMovieLog/show_movies_page.dart';

void main() async {
  print('Starting app initialization...');
  WidgetsFlutterBinding.ensureInitialized();
  print('Flutter binding initialized');
  
  try {
    final database = MovieDatabase();
    print('Movie database instance created');
    
    // Test database connection
    await database.database;
    print('Database connection test successful');
    
    print('Starting app with initialized database');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: HomePage(movieDatabase: database),
      ),
    );
  } catch (e, stackTrace) {
    print('Error during initialization: $e');
    print('Stack trace: $stackTrace');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error initializing app',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Instead of reloading the app, we can show a message or simply exit
                    print('App needs to be restarted manually.');
                  },
                  child: Text('Reload App'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}