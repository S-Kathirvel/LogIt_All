class Movie {
  String name;
  int yearOfRelease;
  List<String> genres;
  DateTime dateWatched;
  double rating;

  Movie({required this.name, required this.yearOfRelease, required this.genres, required this.dateWatched, required this.rating});
}

class MovieDatabase {
  List<Movie> movies = [];

  void addMovie(Movie movie) {
    movies.add(movie);
  }

  void deleteMovie(int index) {
    if (index >= 0 && index < movies.length) {
      movies.removeAt(index);
    }
  }

  Future<List<Movie>> getMovies() async {
    return movies;
  }

  void addDummyData() {
    movies.add(Movie(
      name: 'Inception',
      yearOfRelease: 2010,
      genres: ['Sci-Fi', 'Action'],
      dateWatched: DateTime.parse('2021-06-15'),
      rating: 8.8,
    ));
    movies.add(Movie(
      name: 'The Dark Knight',
      yearOfRelease: 2008,
      genres: ['Action', 'Drama'],
      dateWatched: DateTime.parse('2021-06-20'),
      rating: 9.0,
    ));
    movies.add(Movie(
      name: 'Interstellar',
      yearOfRelease: 2014,
      genres: ['Sci-Fi', 'Adventure'],
      dateWatched: DateTime.parse('2021-06-25'),
      rating: 8.6,
    ));
  }
}
