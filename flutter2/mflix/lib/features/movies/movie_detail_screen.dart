import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;
  const MovieDetailScreen({required this.movieId, super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _loading = true;
  String? _errorMessage;
  Map<String, dynamic>? _movie;

  @override
  void initState() {
    super.initState();
    _fetchMovie();
  }

  Future<void> _fetchMovie() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    try {
      _movie = {
        'title': 'The Shawshank Redemption',
        'year': '1994',
        'director': 'Frank Darabont',
        'cast': 'Tim Robbins, Morgan Freeman',
        'description': 'Two imprisoned men bond over a number of years...'
      };
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to load movie details.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LoadingIndicator();
    }
    if (_errorMessage != null) {
      return ErrorMessage(
        message: _errorMessage!,
        onRetry: _fetchMovie,
      );
    }
    final movie = _movie!;
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'] ?? 'Movie Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Title: ${movie['title']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Year: ${movie['year']}'),
            Text('Director: ${movie['director']}'),
            Text('Cast: ${movie['cast']}'),
            const SizedBox(height: 16),
            Text(movie['description'] ?? ''),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
