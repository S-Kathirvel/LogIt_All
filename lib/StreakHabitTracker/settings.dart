// Settings page for Streak Habit Tracker

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure correct import

class StreakHabitTrackerSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: FutureBuilder<List<String>>(
        future: _getHabitList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading habits')); 
          }
          final habits = snapshot.data ?? [];
          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(habits[index]),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _getHabitList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().toList(); // Retrieve all habit names stored
  }
}
