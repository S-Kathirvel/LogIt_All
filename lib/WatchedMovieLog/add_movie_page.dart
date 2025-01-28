import 'package:flutter/material.dart';
import 'database.dart';

class AddMoviePage extends StatefulWidget {
  final MovieDatabase database;
  final Function refreshMovies;

  AddMoviePage({required this.database, required this.refreshMovies});

  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _year = 2023;
  List<String> _genres = [];
  DateTime _dateWatched = DateTime.now();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Movie')), 
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Movie Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a movie name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Year of Release'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _year = int.parse(value);
                  });
                },
              ),
              // Genres selection
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Genres'),
                items: <String>[
                  'Action', 'Adult', 'Adventure', 'Animation', 'Biography', 'Comedy',
                  'Crime', 'Documentary', 'Drama', 'Family', 'Fantasy', 'Film Noir',
                  'Game Show', 'History', 'Horror', 'Musical', 'Music', 'Mystery',
                  'News', 'Reality-TV', 'Romance', 'Sci-Fi', 'Short', 'Sport',
                  'Talk-Show', 'Thriller', 'War', 'Western'
                ]
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      if (!_genres.contains(value)) {
                        _genres.add(value);
                      }
                    }
                  });
                },
              ),
              // Date picker
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _dateWatched,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _dateWatched)
                    setState(() {
                      _dateWatched = picked;
                    });
                },
                child: Text('Select Date Watched: ${_dateWatched.toLocal()}'.split(' ')[0]),
              ),
              // Rating input
              Slider(
                value: _rating,
                min: 0,
                max: 10,
                divisions: 10,
                label: _rating.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save movie to database
                    widget.database.addMovie(Movie(
                      name: _name,
                      yearOfRelease: _year,
                      genres: _genres,
                      dateWatched: _dateWatched,
                      rating: _rating,
                    ));
                    widget.refreshMovies(); // Call refreshMovies callback
                    Navigator.pop(context); // Navigate back to Show Movies Page
                  }
                },
                child: Text('Add Movie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
