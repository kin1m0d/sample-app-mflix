import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class CommentDetailScreen extends StatefulWidget {
  final String commentId;
  const CommentDetailScreen({required this.commentId, super.key});

  @override
  State<CommentDetailScreen> createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  bool _loading = true;
  String? _errorMessage;
  Map<String, dynamic>? _comment;

  @override
  void initState() {
    super.initState();
    _fetchComment();
  }

  Future<void> _fetchComment() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    try {
      _comment = {
        'user': 'Alice',
        'comment': 'Great movie!',
        'date': '2025-12-26',
      };
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to load comment details.';
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
        onRetry: _fetchComment,
      );
    }
    final comment = _comment!;
    return Scaffold(
      appBar: AppBar(title: const Text('Comment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('User: ${comment['user']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Date: ${comment['date']}'),
            const SizedBox(height: 16),
            Text(comment['comment'] ?? ''),
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
