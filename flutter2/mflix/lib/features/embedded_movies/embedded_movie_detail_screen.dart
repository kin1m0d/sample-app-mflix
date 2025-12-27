import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class EmbeddedMovieDetailScreen extends StatefulWidget {
  final String embeddedMovieId;
  const EmbeddedMovieDetailScreen({required this.embeddedMovieId, super.key});

  @override
  State<EmbeddedMovieDetailScreen> createState() => _EmbeddedMovieDetailScreenState();
}

class _EmbeddedMovieDetailScreenState extends State<EmbeddedMovieDetailScreen> {
  bool _loading = true;
  String? _errorMessage;
  Map<String, dynamic>? _embeddedMovie;

  @override
  void initState() {
    super.initState();
    _fetchEmbeddedMovie();
  }

  Future<void> _fetchEmbeddedMovie() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    try {
      _embeddedMovie = {
        'title': 'Short Film 1',
        'info': 'Embedded extra',
        'description': 'A short behind-the-scenes film.'
      };
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to load embedded movie details.';
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
        onRetry: _fetchEmbeddedMovie,
      );
    }
    final embeddedMovie = _embeddedMovie!;
    return Scaffold(
      appBar: AppBar(title: const Text('Embedded Movie Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Title: ${embeddedMovie['title']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Info: ${embeddedMovie['info']}'),
            const SizedBox(height: 16),
            Text(embeddedMovie['description'] ?? ''),
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
