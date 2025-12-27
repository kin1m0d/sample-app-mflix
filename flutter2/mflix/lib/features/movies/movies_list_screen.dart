import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import 'movie_card.dart';
import '../../widgets/filter_bar.dart';
import '../../services/movies_api_service.dart';

enum MoviesListState { loading, error, loaded }

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  MoviesListState _state = MoviesListState.loading;
  String? _errorMessage;
  List<Map<String, dynamic>> _movies = [];
  String _filter = '';
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    setState(() {
      _state = MoviesListState.loading;
      _errorMessage = null;
    });
    try {
      final movies = await MoviesApiService.fetchMovies(filter: _filter);
      print('[MoviesListScreen] Movies loaded: ' + movies.length.toString());
      setState(() {
        _movies = movies;
        _state = MoviesListState.loaded;
      });
    } catch (e, stack) {
      print('[MoviesListScreen] Error: $e');
      print(stack);
      setState(() {
        _state = MoviesListState.error;
        _errorMessage = 'Failed to load movies. $e';
      });
    }
  }

  void _onFilterChanged(String value) {
    setState(() {
      _filter = value;
    });
    _fetchMovies();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case MoviesListState.loading:
        content = const LoadingIndicator();
        break;
      case MoviesListState.error:
        content = ErrorMessage(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _fetchMovies,
        );
        break;
      case MoviesListState.loaded:
        content = Column(
          children: [
            FilterBar(
              hintText: 'Search by title...',
              controller: _filterController,
              onChanged: (value) {
                _onFilterChanged(value);
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchMovies,
                child: _movies.isEmpty
                    ? const Center(child: Text('No movies found.'))
                    : ListView.builder(
                        itemCount: _movies.length,
                        itemBuilder: (context, index) {
                          final movie = _movies[index];
                          return MovieCard(
                            title: movie['title']?.toString() ?? '',
                            year: movie['year']?.toString() ?? '',
                            onEdit: () {},
                            onDelete: () {},
                          );
                        },
                      ),
              ),
            ),
          ],
        );
        break;
    }
    return Scaffold(
      body: content,
      floatingActionButton: _state == MoviesListState.loaded
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add Movie',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
