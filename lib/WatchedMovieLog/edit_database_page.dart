import 'package:flutter/material.dart';
import 'database.dart';

class EditDatabasePage extends StatefulWidget {
  final MovieDatabase database;

  EditDatabasePage({required this.database});

  @override
  _EditDatabasePageState createState() => _EditDatabasePageState();
}

class _EditDatabasePageState extends State<EditDatabasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Database')), 
      body: FutureBuilder<List<Movie>>(
        future: widget.database.getMovies(), // Ensure this returns a Future<List<Movie>>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final movies = snapshot.data;
          return ListView.builder(
            itemCount: movies!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(movies[index].name),
                subtitle: Text('Released: ${movies[index].yearOfRelease} | Rating: ${movies[index].rating} | Genres: ${movies[index].genres.join(', ')}'),
                trailing: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditMoviePage(movie: movies[index], database: widget.database)),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Confirm deletion
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete this movie?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.database.deleteMovie(index);
                                  Navigator.of(context).pop(); // Close the dialog
                                  setState(() {}); // Refresh the list
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
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
  final Movie movie;
  final MovieDatabase database;

  EditMoviePage({required this.movie, required this.database});

  @override
  _EditMoviePageState createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _year;
  late List<String> _genres;
  late DateTime _dateWatched;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _name = widget.movie.name;
    _year = widget.movie.yearOfRelease;
    _genres = widget.movie.genres;
    _dateWatched = widget.movie.dateWatched;
    _rating = widget.movie.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Movie')), 
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
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
                initialValue: _year.toString(),
                decoration: InputDecoration(labelText: 'Year of Release'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a year';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _year = int.parse(value);
                  });
                },
              ),
              TextFormField(
                initialValue: _genres.join(', '),
                decoration: InputDecoration(labelText: 'Genres'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter genres';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _genres = value.split(',').map((e) => e.trim()).toList();
                  });
                },
              ),
              TextFormField(
                initialValue: _dateWatched.toString(),
                decoration: InputDecoration(labelText: 'Date Watched'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _dateWatched = DateTime.parse(value);
                  });
                },
              ),
              TextFormField(
                initialValue: _rating.toString(),
                decoration: InputDecoration(labelText: 'Rating'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _rating = double.parse(value);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update movie in database using index
                    widget.database.movies[widget.database.movies.indexOf(widget.movie)] = Movie(
                      name: _name,
                      yearOfRelease: _year,
                      genres: _genres,
                      dateWatched: _dateWatched,
                      rating: _rating,
                    );
                    Navigator.pop(context); // Navigate back to Edit Database Page
                  }
                },
                child: Text('Update Movie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
