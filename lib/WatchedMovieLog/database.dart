import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MovieDatabase {
  static final MovieDatabase _instance = MovieDatabase._internal();
  factory MovieDatabase() => _instance;
  MovieDatabase._internal() {
    print('MovieDatabase instance created');
  }

  Database? _database;
  bool _isInitializing = false;

  Future<Database> get database async {
    print('Getting database instance...');
    if (_database != null) {
      print('Returning existing database instance');
      return _database!;
    }
    
    // Prevent multiple simultaneous initializations
    while (_isInitializing) {
      print('Waiting for existing initialization to complete...');
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    _isInitializing = true;
    print('Starting database initialization...');
    
    try {
      _database = await _initDatabase();
      print('Database initialized successfully');
      return _database!;
    } catch (e, stackTrace) {
      print('Error initializing database: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  Future<Database> _initDatabase() async {
    print('Initializing database...');
    final String path = join(await getDatabasesPath(), 'watched_movies.db');
    print('Database path: $path');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Creating new database tables...');
        await db.execute(
          'CREATE TABLE watched_movies(id INTEGER PRIMARY KEY, name TEXT, year INTEGER, genre TEXT, rating REAL, date_of_entry TEXT)',
        );
        print('Database tables created successfully');
      },
    );
  }

  Future<int> addMovie(Map<String, dynamic> movie) async {
    try {
      print('Adding movie: ${movie['name']}');
      final db = await database;
      final result = await db.insert('watched_movies', movie);
      print('Movie added successfully with id: $result');
      return result;
    } catch (e) {
      print('Error adding movie: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllMovies() async {
    try {
      print('Getting all movies...');
      final db = await database;
      final result = await db.query('watched_movies', orderBy: 'date_of_entry DESC');
      print('Retrieved ${result.length} movies from database');
      return result;
    } catch (e) {
      print('Error getting movies: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getMovie(int id) async {
    try {
      print('Getting movie with id: $id');
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'watched_movies',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      print('Movie retrieval result: ${results.isNotEmpty ? 'found' : 'not found'}');
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      print('Error getting movie: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    try {
      print('Searching movies with query: $query');
      final db = await database;
      final results = await db.query(
        'watched_movies',
        where: 'name LIKE ? OR genre LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'date_of_entry DESC',
      );
      print('Found ${results.length} movies matching query');
      return results;
    } catch (e) {
      print('Error searching movies: $e');
      return [];
    }
  }

  Future<int> updateMovie(int id, Map<String, dynamic> movie) async {
    try {
      print('Updating movie with id: $id');
      final db = await database;
      final result = await db.update(
        'watched_movies',
        movie,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Movie update result: $result rows affected');
      return result;
    } catch (e) {
      print('Error updating movie: $e');
      return 0;
    }
  }

  Future<int> deleteMovie(int id) async {
    try {
      print('Deleting movie with id: $id');
      final db = await database;
      final result = await db.delete(
        'watched_movies',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Movie deletion result: $result rows affected');
      return result;
    } catch (e) {
      print('Error deleting movie: $e');
      return 0;
    }
  }

  Future<void> deleteAllMovies() async {
    try {
      print('Deleting all movies...');
      final db = await database;
      await db.delete('watched_movies');
      print('All movies deleted successfully');
    } catch (e) {
      print('Error deleting all movies: $e');
    }
  }
}
