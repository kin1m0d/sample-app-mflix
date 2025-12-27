import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class UsersApiService {
  static String get _baseUrl => AppConfig.apiBaseUrl.endsWith('/')
      ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
      : AppConfig.apiBaseUrl;

  static Future<List<Map<String, dynamic>>> fetchUsers({String? filter}) async {
    final uri = Uri.parse('$_baseUrl/users/').replace(queryParameters: filter != null && filter.isNotEmpty ? {'name': filter} : null);
    print('[UsersApiService] GET: ' + uri.toString());
    final response = await http.get(uri);
    print('[UsersApiService] Status: ' + response.statusCode.toString());
    print('[UsersApiService] Body: ' + response.body);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load users: \\${response.statusCode} \\${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchUserById(String id) async {
    final uri = Uri.parse('$_baseUrl/users/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }

  // Add create, update, delete methods as needed
}
