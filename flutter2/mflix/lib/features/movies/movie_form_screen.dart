import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class MovieFormScreen extends StatefulWidget {
  final String? movieId; // null for create, not null for edit
  const MovieFormScreen({this.movieId, super.key});

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;
  String _title = '';
  String _year = '';
  String _director = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    if (widget.movieId != null) {
      _loadMovie();
    }
  }

  Future<void> _loadMovie() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    // TODO: Replace with real API call
    setState(() {
      _title = 'The Shawshank Redemption';
      _year = '1994';
      _director = 'Frank Darabont';
      _description = 'Two imprisoned men bond over a number of years...';
      _loading = false;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    // TODO: Replace with real API call
    setState(() => _loading = false);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingIndicator();
    if (_errorMessage != null) {
      return ErrorMessage(message: _errorMessage!, onRetry: _submit);
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.movieId == null ? 'Add Movie' : 'Edit Movie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Title required' : null,
                onSaved: (v) => _title = v ?? '',
              ),
              TextFormField(
                initialValue: _year,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Year required' : null,
                onSaved: (v) => _year = v ?? '',
              ),
              TextFormField(
                initialValue: _director,
                decoration: const InputDecoration(labelText: 'Director'),
                onSaved: (v) => _director = v ?? '',
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (v) => _description = v ?? '',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
