import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

enum EmbeddedMoviesListState { loading, error, loaded }

class EmbeddedMoviesListScreen extends StatefulWidget {
  const EmbeddedMoviesListScreen({super.key});

  @override
  State<EmbeddedMoviesListScreen> createState() => _EmbeddedMoviesListScreenState();
}

class _EmbeddedMoviesListScreenState extends State<EmbeddedMoviesListScreen> {
  EmbeddedMoviesListState _state = EmbeddedMoviesListState.loading;
  String? _errorMessage;
  List<Map<String, String>> _embeddedMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchEmbeddedMovies();
  }

  Future<void> _fetchEmbeddedMovies() async {
    setState(() {
      _state = EmbeddedMoviesListState.loading;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    try {
      // Simulated data
      _embeddedMovies = [
        {'title': 'Short Film 1', 'info': 'Embedded extra'},
        {'title': 'Short Film 2', 'info': 'Bonus content'},
        {'title': 'Short Film 3', 'info': 'Behind the scenes'},
      ];
      setState(() {
        _state = EmbeddedMoviesListState.loaded;
      });
    } catch (e) {
      setState(() {
        _state = EmbeddedMoviesListState.error;
        _errorMessage = 'Failed to load embedded movies.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case EmbeddedMoviesListState.loading:
        content = const LoadingIndicator();
        break;
      case EmbeddedMoviesListState.error:
        content = ErrorMessage(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _fetchEmbeddedMovies,
        );
        break;
      case EmbeddedMoviesListState.loaded:
        content = RefreshIndicator(
          onRefresh: _fetchEmbeddedMovies,
          child: ListView.builder(
            itemCount: _embeddedMovies.length,
            itemBuilder: (context, index) {
              final movie = _embeddedMovies[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(movie['title'] ?? ''),
                  subtitle: Text(movie['info'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
        break;
    }
    return Scaffold(
      body: content,
      floatingActionButton: _state == EmbeddedMoviesListState.loaded
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add Embedded Movie',
              child: const Icon(Icons.add_to_photos),
            )
          : null,
    );
  }
}
