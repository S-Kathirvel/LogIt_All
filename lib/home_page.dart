import 'package:flutter/material.dart';
import 'StreakHabitTracker/Habits_page.dart'; // Importing App1's home page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Kv\'s Utility Apps',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: <Widget>[
          _buildAppCard(
            context: context,
            emoji: '🔥',
            title: 'Streak Habit\nManager',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HabitsPage()),
              );
            },
          ),
          _buildAppCard(
            context: context,
            emoji: '📚',
            title: 'Read Books Log',
            onTap: () {
              _showComingSoonDialog(context, 'Read Books Log');
            },
          ),
          _buildAppCard(
            context: context,
            emoji: '🎬',
            title: 'Watched Movies Log',
            onTap: () {
              _showComingSoonDialog(context, 'Watched Movies Log');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppCard({
    required BuildContext context,
    required String emoji,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                emoji,
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(height: 12.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String appName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appName),
          content: Text('Coming soon!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
