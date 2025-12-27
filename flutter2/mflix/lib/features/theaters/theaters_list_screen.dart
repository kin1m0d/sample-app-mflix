import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../services/theaters_api_service.dart';
import 'theater_detail_screen.dart';

enum TheatersListState { loading, error, loaded }

class TheatersListScreen extends StatefulWidget {
  const TheatersListScreen({super.key});

  @override
  State<TheatersListScreen> createState() => _TheatersListScreenState();
}

class _TheatersListScreenState extends State<TheatersListScreen> {
  TheatersListState _state = TheatersListState.loading;
  String? _errorMessage;
  List<Map<String, dynamic>> _theaters = [];

  @override
  void initState() {
    super.initState();
    _fetchTheaters();
  }

  Future<void> _fetchTheaters() async {
    setState(() {
      _state = TheatersListState.loading;
      _errorMessage = null;
    });
    try {
      final theaters = await TheatersApiService.fetchTheaters();
      setState(() {
        _theaters = theaters;
        _state = TheatersListState.loaded;
      });
    } catch (e) {
      setState(() {
        _state = TheatersListState.error;
        _errorMessage = 'Failed to load theaters. $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case TheatersListState.loading:
        content = const LoadingIndicator();
        break;
      case TheatersListState.error:
        content = ErrorMessage(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _fetchTheaters,
        );
        break;
      case TheatersListState.loaded:
        content = RefreshIndicator(
          onRefresh: _fetchTheaters,
          child: ListView.builder(
            itemCount: _theaters.length,
            itemBuilder: (context, index) {
              final theater = _theaters[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(theater['name']?.toString() ?? ''),
                  subtitle: Text(theater['location']?.toString() ?? ''),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TheaterDetailScreen(
                          theaterId: theater['_id']?.toString() ?? '',
                          theater: theater,
                        ),
                      ),
                    );
                  },
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
      floatingActionButton: _state == TheatersListState.loaded
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add Theater',
              child: const Icon(Icons.add_business),
            )
          : null,
    );
  }
}
