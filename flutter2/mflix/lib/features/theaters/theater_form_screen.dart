import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';

class TheaterFormScreen extends StatefulWidget {
  final String? theaterId;
  const TheaterFormScreen({this.theaterId, super.key});

  @override
  State<TheaterFormScreen> createState() => _TheaterFormScreenState();
}

class _TheaterFormScreenState extends State<TheaterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;
  String _name = '';
  String _location = '';
  String _capacity = '';

  @override
  void initState() {
    super.initState();
    if (widget.theaterId != null) {
      _loadTheater();
    }
  }

  Future<void> _loadTheater() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _name = 'Cinema City';
      _location = 'Downtown';
      _capacity = '200';
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
      appBar: AppBar(title: Text(widget.theaterId == null ? 'Add Theater' : 'Edit Theater')),
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
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (v) => _location = v ?? '',
              ),
              TextFormField(
                initialValue: _capacity,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _capacity = v ?? '',
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
