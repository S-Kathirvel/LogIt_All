import 'package:flutter/material.dart';
import 'database.dart';
import 'settings_page.dart';

class AddMoviePage extends StatefulWidget {
  final MovieDatabase database;

  const AddMoviePage({
    Key? key,
    required this.database,
  }) : super(key: key);

  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _customGenreController = TextEditingController();
  double _rating = 0;
  List<String> _selectedGenres = [];
  bool _isCustomGenre = false;
  bool _isSaving = false;

  static const List<String> predefinedGenres = [
    "Action", "Adventure", "Animation", "Biography", "Comedy", "Crime", "Documentary", 
    "Drama", "Family", "Fantasy", "Film-Noir", "History", "Horror", "Musical", 
    "Mystery", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _customGenreController.dispose();
    super.dispose();
  }

  Future<void> _saveMovie() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final movie = {
        'name': _nameController.text,
        'year': _yearController.text,
        'genre': _selectedGenres.join(', '),
        'rating': _rating,
        'date_of_entry': DateTime.now().toIso8601String(),
      };

      await widget.database.addMovie(movie);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movie added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add movie: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Movie Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a movie name';
                }
                return null;
              },
              enabled: !_isSaving,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the year';
                }
                return null;
              },
              enabled: !_isSaving,
            ),
            const SizedBox(height: 16),
            Text('Select Genres:'),
            ...predefinedGenres.map((genre) {
              return CheckboxListTile(
                title: Text(genre),
                value: _selectedGenres.contains(genre),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedGenres.add(genre);
                    } else {
                      _selectedGenres.remove(genre);
                    }
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 16),
            Text(
              'Rating: ${_rating.toStringAsFixed(1)}',
              textAlign: TextAlign.center,
            ),
            Slider(
              value: _rating,
              min: 0,
              max: 10,
              divisions: 20,
              label: _rating.toStringAsFixed(1),
              onChanged: _isSaving ? null : (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveMovie,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Movie'),
            ),
          ],
        ),
      ),
    );
  }
}
