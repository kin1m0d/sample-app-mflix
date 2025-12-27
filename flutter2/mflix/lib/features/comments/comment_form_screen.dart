import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class CommentFormScreen extends StatefulWidget {
  final String? commentId;
  const CommentFormScreen({this.commentId, super.key});

  @override
  State<CommentFormScreen> createState() => _CommentFormScreenState();
}

class _CommentFormScreenState extends State<CommentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;
  String _user = '';
  String _comment = '';

  @override
  void initState() {
    super.initState();
    if (widget.commentId != null) {
      _loadComment();
    }
  }

  Future<void> _loadComment() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _user = 'Alice';
      _comment = 'Great movie!';
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
      appBar: AppBar(title: Text(widget.commentId == null ? 'Add Comment' : 'Edit Comment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _user,
                decoration: const InputDecoration(labelText: 'User'),
                validator: (v) => v == null || v.isEmpty ? 'User required' : null,
                onSaved: (v) => _user = v ?? '',
              ),
              TextFormField(
                initialValue: _comment,
                decoration: const InputDecoration(labelText: 'Comment'),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Comment required' : null,
                onSaved: (v) => _comment = v ?? '',
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
