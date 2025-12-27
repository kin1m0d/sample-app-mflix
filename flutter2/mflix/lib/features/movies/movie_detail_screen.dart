import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../services/movies_api_service.dart';
import 'package:intl/intl.dart';


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
  bool _castExpanded = false;

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
    try {
      final movie = await MoviesApiService.fetchMovieById(widget.movieId);
      setState(() {
        _movie = movie;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to load movie details. $e';
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
    final title = movie['title'] ?? '';
    final year = movie['year']?.toString() ?? '';
    final genres = (movie['genres'] as List?)?.cast<String>() ?? [];
    final runtime = movie['runtime']?.toString() ?? '';
    final cast = (movie['cast'] as List?)?.cast<String>() ?? [];
    final plot = movie['fullplot'] ?? movie['plot'] ?? '';
    final directors = (movie['directors'] as List?)?.cast<String>() ?? [];
    final languages = (movie['languages'] as List?)?.cast<String>() ?? [];
    final released = movie['released'];
    final countries = (movie['countries'] as List?)?.cast<String>() ?? [];
    final rated = movie['rated'] ?? '';
    final imdb = movie['imdb'] as Map<String, dynamic>?;
    final imdbRating = imdb?['rating']?.toString() ?? '';
    final awards = (movie['awards']?['text'] ?? '').toString();
    final numComments = movie['num_mflix_comments']?.toString() ?? '0';
    final poster = movie['poster'] ?? '';

    String? formattedDate;
    if (released != null) {
      try {
        if (released is String) {
          formattedDate = DateFormat.yMMMd().format(DateTime.parse(released));
        } else if (released is Map && released['\$date'] != null) {
          final dateVal = released['\$date'];
          if (dateVal is Map && dateVal['\$numberLong'] != null) {
            final millis = int.tryParse(dateVal['\$numberLong'].toString());
            if (millis != null) {
              formattedDate = DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(millis));
            }
          } else if (dateVal is String) {
            formattedDate = DateFormat.yMMMd().format(DateTime.parse(dateVal));
          }
        }
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            if (poster.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    poster,
                    height: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  height: 120,
                  width: 90,
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 60),
                ),
              ),
            const SizedBox(height: 16),
            // Title & Year
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (year.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                    child: Text(
                      '($year)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Genres as Chips
            if (genres.isNotEmpty)
              Wrap(
                spacing: 8,
                children: genres.map((g) => Chip(label: Text(g))).toList(),
              ),
            const SizedBox(height: 8),
            // IMDb, Runtime, Rated
            Row(
              children: [
                if (imdbRating.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(imdbRating, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                if (imdbRating.isNotEmpty) const SizedBox(width: 16),
                if (runtime.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 18),
                      const SizedBox(width: 4),
                      Text('$runtime min'),
                    ],
                  ),
                if (runtime.isNotEmpty) const SizedBox(width: 16),
                if (rated.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(rated, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Plot Section
            Text('Plot', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(plot),
            const SizedBox(height: 16),
            // Details Section
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    if (directors.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Director(s)'),
                        subtitle: Text(directors.join(', ')),
                      ),
                    if (cast.isNotEmpty)
                      ExpansionTile(
                        leading: const Icon(Icons.people_outline),
                        title: const Text('Cast'),
                        initiallyExpanded: _castExpanded,
                        onExpansionChanged: (expanded) => setState(() => _castExpanded = expanded),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            child: Text(cast.join(', ')),
                          ),
                        ],
                      ),
                    if (languages.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Languages'),
                        subtitle: Wrap(
                          spacing: 6,
                          children: languages.map((l) => Chip(label: Text(l))).toList(),
                        ),
                      ),
                    if (formattedDate != null)
                      ListTile(
                        leading: const Icon(Icons.event),
                        title: const Text('Released'),
                        subtitle: Text(formattedDate),
                      ),
                    if (countries.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.public),
                        title: const Text('Countries'),
                        subtitle: Text(countries.join(', ')),
                      ),
                    if (awards.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.emoji_events_outlined),
                        title: const Text('Awards'),
                        subtitle: Text(awards),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Comments/Reviews Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.comment, size: 20),
                    const SizedBox(width: 4),
                    Text('$numComments comment${numComments == '1' ? '' : 's'}'),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View/Add Comments'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
