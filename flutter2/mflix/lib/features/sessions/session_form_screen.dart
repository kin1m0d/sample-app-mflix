import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class SessionFormScreen extends StatefulWidget {
  final String? sessionId;
  const SessionFormScreen({this.sessionId, super.key});

  @override
  State<SessionFormScreen> createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends State<SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;
  String _sessionId = '';
  String _info = '';
  String _details = '';

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      _loadSession();
    }
  }

  Future<void> _loadSession() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _sessionId = 'A1';
      _info = 'Session 1';
      _details = 'Session details here.';
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
      appBar: AppBar(title: Text(widget.sessionId == null ? 'Add Session' : 'Edit Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _sessionId,
                decoration: const InputDecoration(labelText: 'Session ID'),
                validator: (v) => v == null || v.isEmpty ? 'Session ID required' : null,
                onSaved: (v) => _sessionId = v ?? '',
              ),
              TextFormField(
                initialValue: _info,
                decoration: const InputDecoration(labelText: 'Info'),
                onSaved: (v) => _info = v ?? '',
              ),
              TextFormField(
                initialValue: _details,
                decoration: const InputDecoration(labelText: 'Details'),
                maxLines: 3,
                onSaved: (v) => _details = v ?? '',
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
