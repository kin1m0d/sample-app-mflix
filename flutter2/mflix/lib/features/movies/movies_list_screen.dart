import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

import 'movie_card.dart';
import 'movie_detail_screen.dart';
import 'extended_filter_dialog.dart';
import '../../services/movies_api_service.dart';
import 'movie_filter_state.dart';

enum MoviesListState { loading, error, loaded }

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  // Holds the current filter state
  MovieFilterState _filterState = MovieFilterState();

  void _showExtendedFilters() async {
    final result = await showDialog<MovieFilterState>(
      context: context,
      builder: (ctx) => ExtendedFilterDialog(filterState: _filterState),
    );
    if (result != null) {
      setState(() {
        _filterState = result;
      });
      _fetchMovies();
    }
  }
  MoviesListState _state = MoviesListState.loading;
  String? _errorMessage;
  List<Map<String, dynamic>> _movies = [];
  final TextEditingController _filterController = TextEditingController();
  // FilterBar state is now encapsulated in _filterState

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
      // Build query params based on filter state
      final Map<String, dynamic> params = {};
      final search = _filterState.search.trim();
      if (search.isNotEmpty) {
        params['title'] = search;
      }
      if (_filterState.selectedYear != null) {
        params['year'] = _filterState.selectedYear;
      }
      if (_filterState.selectedGenres.isNotEmpty) {
        params['genres'] = _filterState.selectedGenres;
      }
      if (_filterState.selectedLanguages.isNotEmpty) {
        params['languages'] = _filterState.selectedLanguages;
      }
      if (_filterState.rated != null && _filterState.rated!.isNotEmpty) {
        params['rated'] = _filterState.rated;
      }
      // Note: Backend does not support minRating directly, would need to filter client-side or extend API
      final movies = await MoviesApiService.fetchMoviesWithParams(params);
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
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Show filters',
                onPressed: _showExtendedFilters,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Movies found: ${_movies.length}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                          return GestureDetector(
                            onTap: () {
                              if (movie['_id'] != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MovieDetailScreen(movieId: movie['_id'].toString()),
                                  ),
                                );
                              }
                            },
                            child: MovieCard(
                              title: movie['title']?.toString() ?? '',
                              year: movie['year']?.toString() ?? '',
                              onEdit: () {},
                              onDelete: () {},
                            ),
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
