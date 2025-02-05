import 'package:flutter/material.dart';
import 'database.dart';

class EditMoviePage extends StatefulWidget {
  final MovieDatabase database;
  final Map<String, dynamic> movie;

  const EditMoviePage({
    Key? key,
    required this.database,
    required this.movie,
  }) : super(key: key);

  @override
  _EditMoviePageState createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _yearController;
  late TextEditingController _customGenreController;
  late double _rating;
  List<String> _selectedGenres = [];
  bool _isCustomGenre = false;
  bool _isSaving = false;

  static const List<String> predefinedGenres = [
    "Action", "Adventure", "Animation", "Biography", "Comedy", "Crime", "Documentary", 
    "Drama", "Family", "Fantasy", "Film-Noir", "History", "Horror", "Musical", 
    "Mystery", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western",
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.movie['name']);
    _yearController = TextEditingController(text: widget.movie['year']);
    _rating = widget.movie['rating']?.toDouble() ?? 0.0;
    final currentGenre = widget.movie['genre'] as String?;
    _selectedGenres = currentGenre != null ? currentGenre.split(', ') : [];
  }

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
      await widget.database.updateMovie(
        widget.movie['id'],
        {
          'name': _nameController.text,
          'year': _yearController.text,
          'genre': _selectedGenres.join(', '),
          'rating': _rating,
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movie updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update movie: $e'),
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
        title: const Text('Edit Movie'),
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
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
