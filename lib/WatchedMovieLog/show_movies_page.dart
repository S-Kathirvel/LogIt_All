import 'package:flutter/material.dart';
import 'database.dart';
import 'add_movie_page.dart';
import 'settings_page.dart';
import 'edit_database_page.dart';

class ShowMoviesPage extends StatefulWidget {
  final MovieDatabase database;

  ShowMoviesPage({required this.database});

  @override
  _ShowMoviesPageState createState() => _ShowMoviesPageState();
}

class _ShowMoviesPageState extends State<ShowMoviesPage> {
  Future<List<Movie>>? _future;

  @override
  void initState() {
    super.initState();
    _future = widget.database.getMovies();
  }

  void refreshMovies() {
    setState(() {
      _future = widget.database.getMovies(); // Refresh the movie list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watched Movies')), 
      body: FutureBuilder<List<Movie>>(
        future: _future, 
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
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMoviePage(database: widget.database, refreshMovies: refreshMovies)),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage(database: widget.database)),
            );
          }
        },
      ),
    );
  }
}
