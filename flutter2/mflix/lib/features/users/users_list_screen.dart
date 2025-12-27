import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../services/users_api_service.dart';

enum UsersListState { loading, error, loaded }

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  UsersListState _state = UsersListState.loading;
  String? _errorMessage;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _state = UsersListState.loading;
      _errorMessage = null;
    });
    try {
      final users = await UsersApiService.fetchUsers();
      setState(() {
        _users = users;
        _state = UsersListState.loaded;
      });
    } catch (e) {
      setState(() {
        _state = UsersListState.error;
        _errorMessage = 'Failed to load users. $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case UsersListState.loading:
        content = const LoadingIndicator();
        break;
      case UsersListState.error:
        content = ErrorMessage(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _fetchUsers,
        );
        break;
      case UsersListState.loaded:
        content = RefreshIndicator(
          onRefresh: _fetchUsers,
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(user['name']?.toString() ?? ''),
                  subtitle: Text(user['email']?.toString() ?? ''),
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
      floatingActionButton: _state == UsersListState.loaded
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add User',
              child: const Icon(Icons.person_add),
            )
          : null,
    );
  }
}
