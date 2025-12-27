import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class SessionDetailScreen extends StatefulWidget {
  final String sessionId;
  const SessionDetailScreen({required this.sessionId, super.key});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  bool _loading = true;
  String? _errorMessage;
  Map<String, dynamic>? _session;

  @override
  void initState() {
    super.initState();
    _fetchSession();
  }

  Future<void> _fetchSession() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    try {
      _session = {
        'sessionId': 'A1',
        'info': 'Session 1',
        'details': 'Session details here.'
      };
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to load session details.';
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
        onRetry: _fetchSession,
      );
    }
    final session = _session!;
    return Scaffold(
      appBar: AppBar(title: const Text('Session Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Session ID: ${session['sessionId']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Info: ${session['info']}'),
            const SizedBox(height: 16),
            Text(session['details'] ?? ''),
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
