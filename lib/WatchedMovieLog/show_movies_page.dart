import 'package:flutter/material.dart';
import 'database.dart';
import 'add_movie_page.dart';
import 'settings_page.dart'; // Assuming SettingsPage is defined in settings_page.dart

class ShowMoviesPage extends StatefulWidget {
  final MovieDatabase database;

  ShowMoviesPage({required this.database});

  @override
  _ShowMoviesPageState createState() => _ShowMoviesPageState();
}

class _ShowMoviesPageState extends State<ShowMoviesPage> {
  late Future<List<Map<String, dynamic>>> _moviesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  Future<void> _refreshMovies() async {
    setState(() {
      _isLoading = true;
      _moviesFuture = widget.database.getAllMovies();
    });

    try {
      await _moviesFuture;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading movies: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _navigateToAddMovie() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMoviePage(database: widget.database),
      ),
    );

    if (result == true) {
      _refreshMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watched Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshMovies,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(database: widget.database), 
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error loading movies',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _refreshMovies,
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              final movies = snapshot.data ?? [];

              if (movies.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie_outlined, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'No movies added yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _navigateToAddMovie,
                        child: Text('Add Your First Movie'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshMovies,
                child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(movie['name'] ?? ''),
                        subtitle: Text(
                          '${movie['year']} • ${movie['genre']}\nRating: ${movie['rating'].toStringAsFixed(1)}/10.0',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _navigateToAddMovie,
        child: Icon(Icons.add),
        tooltip: 'Add Movie',
      ),
    );
  }
}
