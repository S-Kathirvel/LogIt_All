import 'package:flutter/material.dart';
import 'home_page.dart'; // Importing the home page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kv\'s Utility Apps',
      theme: ThemeData(
        brightness: Brightness.dark, // Set the app to dark mode
      ),
      home: HomePage(), // Set HomePage as the initial screen
    );
  }
}