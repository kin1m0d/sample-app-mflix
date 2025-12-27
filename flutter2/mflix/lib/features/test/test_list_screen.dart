import 'package:flutter/material.dart';
import '../../services/test_api_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class TestListScreen extends StatefulWidget {
  const TestListScreen({super.key});

  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  String? _data;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTest();
  }

  Future<void> _fetchTest() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await TestApiService.fetchTest();
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LoadingIndicator();
    }
    if (_error != null) {
      return ErrorMessage(message: _error!, onRetry: _fetchTest);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Test Endpoint')),
      body: Center(
        child: Text(_data ?? 'No data'),
      ),
    );
  }
}
