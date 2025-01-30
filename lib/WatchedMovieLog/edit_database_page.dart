import 'package:flutter/material.dart';
import 'database.dart';

class EditDatabasePage extends StatefulWidget {
  final MovieDatabase database;

  EditDatabasePage({required this.database});

  @override
  _EditDatabasePageState createState() => _EditDatabasePageState();
}

class _EditDatabasePageState extends State<EditDatabasePage> {
  Future<List<Map<String, dynamic>>>? _moviesFuture;

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  void _refreshMovies() {
    setState(() {
      _moviesFuture = widget.database.getAllMovies();
    });
  }

  Future<void> _deleteMovie(BuildContext context, int id, String movieName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Movie'),
        content: Text('Are you sure you want to delete "$movieName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.database.deleteMovie(id);
        _refreshMovies();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Movie deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting movie: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Database'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading movies')); 
          }
          final movies = snapshot.data;
          return ListView.builder(
            itemCount: movies!.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                title: Text(movie['name']),
                subtitle: Text('Year: ${movie['year']}, Genre: ${movie['genre']}, Rating: ${movie['rating'].toStringAsFixed(1)} ⭐'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final editedMovie = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMoviePage(movie: movie, database: widget.database),
                          ),
                        );
                        if (editedMovie != null) {
                          // Update the movie in the database
                          await widget.database.updateMovie(editedMovie['id'], editedMovie);
                          _refreshMovies();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteMovie(context, movie['id'], movie['name']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditMoviePage extends StatefulWidget {
  final Map<String, dynamic> movie;
  final MovieDatabase database;

  EditMoviePage({required this.movie, required this.database});

  @override
  _EditMoviePageState createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final List<String> _selectedGenres = [];
  double _rating = 5.0;

  final List<String> _availableGenres = [
    'Action', 'Adventure', 'Animation', 'Biography', 'Comedy',
    'Crime', 'Documentary', 'Drama', 'Family', 'Fantasy',
    'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi',
    'Thriller', 'War', 'Western'
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.movie['name'];
    _yearController.text = widget.movie['year'].toString();
    _selectedGenres.addAll(widget.movie['genre'].split(', '));
    _rating = widget.movie['rating'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8.0,
      children: _availableGenres.map((genre) {
        final isSelected = _selectedGenres.contains(genre);
        return FilterChip(
          label: Text(genre),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedGenres.add(genre);
              } else {
                _selectedGenres.remove(genre);
              }
            });
          },
          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        );
      }).toList(),
    );
  }

  String _getRatingDisplay(double value) {
    return '${value.toStringAsFixed(1)} ⭐';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Movie'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveMovie,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Movie Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.movie),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a movie name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Year of Release',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a year';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < 1888 || year > DateTime.now().year + 5) {
                    return 'Please enter a valid year';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Genres',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              _buildGenreChips(),
              SizedBox(height: 16),
              Text(
                'Rating: ${_getRatingDisplay(_rating)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _rating,
                min: 0,
                max: 10,
                divisions: 100,
                label: _getRatingDisplay(_rating),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveMovie,
        icon: Icon(Icons.save),
        label: Text('Save Changes'),
      ),
    );
  }

  void _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGenres.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one genre')),
        );
        return;
      }

      final movie = {
        'id': widget.movie['id'],
        'name': _nameController.text,
        'year': int.parse(_yearController.text),
        'genre': _selectedGenres.join(', '),
        'rating': _rating,
        'date_of_entry': widget.movie['date_of_entry'], // Preserve original date
      };

      try {
        await widget.database.updateMovie(movie['id'], movie);
        Navigator.pop(context, movie);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating movie: $e')),
        );
      }
    }
  }
}
