import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

enum SessionsListState { loading, error, loaded }

class SessionsListScreen extends StatefulWidget {
  const SessionsListScreen({super.key});

  @override
  State<SessionsListScreen> createState() => _SessionsListScreenState();
}

class _SessionsListScreenState extends State<SessionsListScreen> {
  SessionsListState _state = SessionsListState.loading;
  String? _errorMessage;
  List<Map<String, String>> _sessions = [];

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    setState(() {
      _state = SessionsListState.loading;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    try {
      // Simulated data
      _sessions = [
        {'sessionId': 'A1', 'info': 'Session 1'},
        {'sessionId': 'B2', 'info': 'Session 2'},
        {'sessionId': 'C3', 'info': 'Session 3'},
      ];
      setState(() {
        _state = SessionsListState.loaded;
      });
    } catch (e) {
      setState(() {
        _state = SessionsListState.error;
        _errorMessage = 'Failed to load sessions.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case SessionsListState.loading:
        content = const LoadingIndicator();
        break;
      case SessionsListState.error:
        content = ErrorMessage(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _fetchSessions,
        );
        break;
      case SessionsListState.loaded:
        content = RefreshIndicator(
          onRefresh: _fetchSessions,
          child: ListView.builder(
            itemCount: _sessions.length,
            itemBuilder: (context, index) {
              final session = _sessions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(session['sessionId'] ?? ''),
                  subtitle: Text(session['info'] ?? ''),
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
      floatingActionButton: _state == SessionsListState.loaded
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add Session',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
