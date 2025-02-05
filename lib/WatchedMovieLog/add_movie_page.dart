import 'package:flutter/material.dart';
import 'database.dart';

class AddMoviePage extends StatefulWidget {
  final MovieDatabase database;

  AddMoviePage({required this.database});

  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _customGenreController = TextEditingController();
  List<String> genres = [
    'Action', 'Adventure', 'Animation', 'Biography', 'Comedy', 'Crime', 'Documentary', 
    'Drama', 'Family', 'Fantasy', 'Film-Noir', 'History', 'Horror', 'Musical', 
    'Mystery', 'Romance', 'Sci-Fi', 'Sport', 'Thriller', 'War', 'Western'
  ];
  List<bool> selectedGenres = List<bool>.filled(genres.length, false);
  String customGenre = '';
  double rating = 5.0;
  bool _isSaving = false;

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
        'year': int.parse(_yearController.text),
        'genre': selectedGenres.asMap().entries.where((entry) => entry.value).map((entry) => genres[entry.key]).toList().join(', ') + (customGenre.isNotEmpty ? ', $customGenre' : ''),
        'rating': rating,
        'date_of_entry': DateTime.now().toIso8601String(),
      };

      await widget.database.addMovie(movie);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Movie added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Pass true to indicate success
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
    return WillPopScope(
      onWillPop: () async {
        if (_isSaving) return false;
        Navigator.pop(context, false); // Pass false to indicate no changes
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Movie'),
          leading: _isSaving
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                ),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Movie Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the movie name';
                      }
                      return null;
                    },
                    enabled: !_isSaving,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _yearController,
                    decoration: InputDecoration(
                      labelText: 'Release Year',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the release year';
                      }
                      final year = int.tryParse(value);
                      if (year == null || year < 1888 || year > DateTime.now().year) {
                        return 'Please enter a valid year';
                      }
                      return null;
                    },
                    enabled: !_isSaving,
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      ...genres.asMap().entries.map((entry) {
                        int index = entry.key;
                        String genre = entry.value;
                        return CheckboxListTile(
                          title: Text(genre),
                          value: selectedGenres[index],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedGenres[index] = value!;
                            });
                          },
                        );
                      }).toList(),
                      TextField(
                        decoration: InputDecoration(labelText: 'Custom Genre'),
                        onChanged: (value) {
                          customGenre = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Rating: ${rating.round().toString()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: rating,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: rating.round().toString(),
                    onChanged: _isSaving ? null : (value) {
                      setState(() => rating = value);
                    },
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveMovie,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(_isSaving ? 'Saving...' : 'Save Movie'),
                    ),
                  ),
                ],
              ),
            ),
            if (_isSaving)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
