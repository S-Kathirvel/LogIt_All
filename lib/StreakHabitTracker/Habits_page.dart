// Home page for Streak Habit Tracker

import 'package:flutter/material.dart';
import 'dart:async';
import 'settings.dart';
import 'habit_info_page.dart'; // Import the Settings Page
// Import Habits page
import 'package:shared_preferences/shared_preferences.dart'; // Ensure correct import

class StreakHabitTrackerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Streak Habit Tracker')), // Title for Streak Habit Tracker
      body: Center(
        child: Text('Welcome to Streak Habit Tracker!'), // Placeholder content
      ),
    );
  }
}

// Habits page for Streak Habit Tracker


class HabitsPage extends StatefulWidget {
  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  Map<String, int> habitStreaks = {
    'Exercise': 0,
    'Reading': 0,
    'Meditation': 0,
  };

  // Function to save habit streak
  Future<void> saveHabit(String habitName, int streakCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(habitName, streakCount);
  }

  // Function to get habit streak
  Future<int> getHabitStreak(String habitName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(habitName) ?? 0;
  }

  void markHabit(String habit) {
    setState(() {
      if (habitStreaks[habit] != null && habitStreaks[habit]! > 0) {
        habitStreaks[habit] = 0; // Unmark habit
      } else {
        habitStreaks[habit] = (habitStreaks[habit] ?? 0) + 1; // Increment habit streak
      }
      saveHabit(habit, habitStreaks[habit]!); // Save updated streak count
    });
  }

  List<String> habits = ['Exercise', 'Reading', 'Meditation']; // Example habit names

  @override
  void initState() {
    super.initState();
    // Load habit streaks when the page is initialized
    habits.forEach((habit) async {
      habitStreaks[habit] = await getHabitStreak(habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Habits'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          ...habits.map((habit) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitInfoPage(habitName: habit)), // Pass the clicked habit name
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      habit,
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => markHabit(habit), // Call the function for the specific habit
                          child: Text(
                            (habitStreaks[habit] ?? 0) > 0 ? 'Undo' : 'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        SizedBox(width: 12),
                        if ((habitStreaks[habit] ?? 0) > 0) ...[
                          Text(
                            '🔥 ${habitStreaks[habit]}',
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a new habit
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: 1, // Set to 1 for Settings page
        onTap: (index) {
          if (index == 0) {
            // Logic to navigate to Home page
            Navigator.pop(context); // Assuming Home is the previous page
          } else {
            // Logic to navigate to Settings page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StreakHabitTrackerSettings()), // Link to SettingsPage
            );
          }
        },
      ),
    );
  }
}

void main() {
  // The Streak Habit Tracker is currently disabled for debugging purposes.
  // runApp(StreakHabitTrackerApp());
}
