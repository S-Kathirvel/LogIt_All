import 'package:flutter/material.dart';
import 'StreakHabitTracker/Habits_page.dart';
import 'WatchedMovieLog/show_movies_page.dart';
import 'WatchedMovieLog/database.dart';

class HomePage extends StatefulWidget {
  final MovieDatabase movieDatabase;

  HomePage({Key? key, required this.movieDatabase}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      // Test database connection
      await widget.movieDatabase.database;
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      print('Error initializing database in HomePage: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _showComingSoonDialog(BuildContext context, String appName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Coming Soon'),
          content: Text('$appName will be available soon!'),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text('Error: $_error'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeDatabase,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowMoviesPage(database: widget.movieDatabase),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
