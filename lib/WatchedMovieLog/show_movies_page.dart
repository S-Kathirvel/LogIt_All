import 'package:flutter/material.dart';
import 'database.dart';
import 'add_movie_page.dart';
import 'edit_movie_page.dart';
import 'settings_page.dart';

class ShowMoviesPage extends StatefulWidget {
  final MovieDatabase database;

  const ShowMoviesPage({
    Key? key,
    required this.database,
  }) : super(key: key);

  @override
  _ShowMoviesPageState createState() => _ShowMoviesPageState();
}

class _ShowMoviesPageState extends State<ShowMoviesPage> {
  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  Future<void> _refreshMovies() async {
    final movies = await widget.database.getMovies();
    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  Future<void> _deleteMovie(int id) async {
    await widget.database.deleteMovie(id);
    await _refreshMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watched Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    database: widget.database,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _movies.isEmpty
              ? const Center(child: Text('No movies added yet'))
              : ListView.builder(
                  itemCount: _movies.length,
                  itemBuilder: (context, index) {
                    final movie = _movies[index];
                    return Dismissible(
                      key: Key(movie['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        _deleteMovie(movie['id']);
                      },
                      child: ListTile(
                        title: Text(movie['name']),
                        subtitle: Text('Genre: ${movie['genre']} • Rating: ${movie['rating'].toStringAsFixed(1)}'),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMoviePage(
                                database: widget.database,
                                movie: movie,
                              ),
                            ),
                          );
                          _refreshMovies();
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMoviePage(
                database: widget.database,
              ),
            ),
          );
          if (result == true) {
            _refreshMovies();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
