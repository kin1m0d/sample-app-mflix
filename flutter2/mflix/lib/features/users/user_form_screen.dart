import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class UserFormScreen extends StatefulWidget {
  final String? userId;
  const UserFormScreen({this.userId, super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _loadUser();
    }
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _name = 'Alice';
      _email = 'alice@example.com';
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
      appBar: AppBar(title: Text(widget.userId == null ? 'Add User' : 'Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
                onSaved: (v) => _name = v ?? '',
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Email required' : null,
                onSaved: (v) => _email = v ?? '',
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
