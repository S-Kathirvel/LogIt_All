import 'package:flutter/material.dart';
import 'database.dart';

class EditMoviePage extends StatefulWidget {
  final Map<String, dynamic> movie;
  final MovieDatabase database;

  EditMoviePage({required this.movie, required this.database});

  @override
  _EditMoviePageState createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  late TextEditingController _nameController;
  late TextEditingController _yearController;
  late List<String> _selectedGenres;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.movie['name']);
    _yearController = TextEditingController(text: widget.movie['year'].toString());
    _selectedGenres = widget.movie['genre'].split(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Movie Name'),
            ),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(labelText: 'Release Year'),
              keyboardType: TextInputType.number,
            ),
            // Add more fields for genre, rating, etc.
            ElevatedButton(
              onPressed: () async {
                final movie = {
                  'id': widget.movie['id'],
                  'name': _nameController.text,
                  'year': int.parse(_yearController.text),
                  'genre': _selectedGenres.join(', '),
                  // Add other fields here
                };
                await widget.database.updateMovie(movie);
                Navigator.pop(context, movie);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
