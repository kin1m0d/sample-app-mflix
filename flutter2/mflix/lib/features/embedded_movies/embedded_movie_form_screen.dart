import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class EmbeddedMovieFormScreen extends StatefulWidget {
  final String? embeddedMovieId;
  const EmbeddedMovieFormScreen({this.embeddedMovieId, super.key});

  @override
  State<EmbeddedMovieFormScreen> createState() => _EmbeddedMovieFormScreenState();
}

class _EmbeddedMovieFormScreenState extends State<EmbeddedMovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;
  String _title = '';
  String _info = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    if (widget.embeddedMovieId != null) {
      _loadEmbeddedMovie();
    }
  }

  Future<void> _loadEmbeddedMovie() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _title = 'Short Film 1';
      _info = 'Embedded extra';
      _description = 'A short behind-the-scenes film.';
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
    await Future.delayed(const Duration(seconds: 1));
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
      appBar: AppBar(title: Text(widget.embeddedMovieId == null ? 'Add Embedded Movie' : 'Edit Embedded Movie')),
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
                initialValue: _info,
                decoration: const InputDecoration(labelText: 'Info'),
                onSaved: (v) => _info = v ?? '',
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
