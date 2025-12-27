import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

enum CommentsListState { loading, error, loaded }

class CommentsListScreen extends StatefulWidget {
  const CommentsListScreen({super.key});

  @override
  State<CommentsListScreen> createState() => _CommentsListScreenState();
}

class _CommentsListScreenState extends State<CommentsListScreen> {
  CommentsListState _state = CommentsListState.loading;
  String? _errorMessage;
  List<Map<String, String>> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    setState(() {
      _state = CommentsListState.loading;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    try {
      // Simulated data
      _comments = [
        {'user': 'Alice', 'comment': 'Great movie!'},
        {'user': 'Bob', 'comment': 'Not my favorite.'},
        {'user': 'Charlie', 'comment': 'Would watch again.'},
      ];
      setState(() {
        _state = CommentsListState.loaded;
      });
    } catch (e) {
      setState(() {
        _state = CommentsListState.error;
        _errorMessage = 'Failed to load comments.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case CommentsListState.loading:
        content = const LoadingIndicator();
        break;
      case CommentsListState.error:
        content = ErrorMessage(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _fetchComments,
        );
        break;
      case CommentsListState.loaded:
        content = RefreshIndicator(
          onRefresh: _fetchComments,
          child: ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              final comment = _comments[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(comment['user'] ?? ''),
                  subtitle: Text(comment['comment'] ?? ''),
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
      floatingActionButton: _state == CommentsListState.loaded
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add Comment',
              child: const Icon(Icons.add_comment),
            )
          : null,
    );
  }
}
