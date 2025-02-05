import 'package:flutter/material.dart';
import 'database.dart';
import 'edit_movie_page.dart';
import 'add_movie_page.dart';

class EditDatabasePage extends StatefulWidget {
  final MovieDatabase database;

  const EditDatabasePage({
    Key? key,
    required this.database,
  }) : super(key: key);

  @override
  _EditDatabasePageState createState() => _EditDatabasePageState();
}

class _EditDatabasePageState extends State<EditDatabasePage> {
  List<Map<String, dynamic>> movies = [];

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  Future<void> _refreshMovies() async {
    final List<Map<String, dynamic>> updatedMovies = await widget.database.getMovies();
    setState(() {
      movies = updatedMovies;
    });
  }

  void _editMovie(Map<String, dynamic> movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMoviePage(
          database: widget.database,
          movie: movie,
          movieId: movie['id'],
          initialTitle: movie['name'],
          initialGenre: movie['genre'],
          initialRating: movie['rating'],
        ),
      ),
    ).then((_) => _refreshMovies());
  }

  Future<void> _deleteMovie(int id) async {
    await widget.database.deleteMovie(id);
    _refreshMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Database'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        padding: const EdgeInsets.all(24),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.black12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                movie['name'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Genre: ${movie['genre'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rating: ${movie['rating']?.toStringAsFixed(1) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editMovie(movie),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteMovie(movie['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMoviePage(
              database: widget.database,
            ),
          ),
        ).then((_) => _refreshMovies()),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class EditMoviePage extends StatefulWidget {
  final MovieDatabase database;
  final Map<String, dynamic> movie;
  final int movieId;
  final String initialTitle;
  final String initialGenre;
  final double initialRating;

  EditMoviePage({
    required this.database,
    required this.movie,
    required this.movieId,
    required this.initialTitle,
    required this.initialGenre,
    required this.initialRating,
  });

  @override
  _EditMoviePageState createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  late TextEditingController _titleController;
  late TextEditingController _genreController;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _genreController = TextEditingController(text: widget.initialGenre);
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Movie'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(fontSize: 12),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _genreController,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Genre',
                labelStyle: TextStyle(fontSize: 12),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Rating: ${_rating.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            Slider(
              value: _rating,
              min: 0,
              max: 10,
              divisions: 20,
              activeColor: Colors.black,
              inactiveColor: Colors.black26,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveMovie,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'SAVE CHANGES',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMovie() async {
    final updatedMovie = {
      'name': _titleController.text,
      'genre': _genreController.text,
      'rating': _rating,
      'date_of_entry': DateTime.now().toIso8601String(),
    };
    await widget.database.updateMovie(widget.movieId, updatedMovie);
    Navigator.pop(context);
  }
}

class AddMoviePage extends StatefulWidget {
  final MovieDatabase database;

  AddMoviePage({
    required this.database,
  });

  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  late TextEditingController _titleController;
  late TextEditingController _genreController;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _genreController = TextEditingController();
    _rating = 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(fontSize: 12),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _genreController,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Genre',
                labelStyle: TextStyle(fontSize: 12),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Rating: ${_rating.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            Slider(
              value: _rating,
              min: 0,
              max: 10,
              divisions: 20,
              activeColor: Colors.black,
              inactiveColor: Colors.black26,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveMovie,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'SAVE MOVIE',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMovie() async {
    final newMovie = {
      'name': _titleController.text,
      'genre': _genreController.text,
      'rating': _rating,
      'date_of_entry': DateTime.now().toIso8601String(),
    };
    await widget.database.addMovie(newMovie);
    Navigator.pop(context);
  }
}
