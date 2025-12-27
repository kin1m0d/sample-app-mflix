import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class TheatersApiService {
  static String get _baseUrl => AppConfig.apiBaseUrl.endsWith('/')
      ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
      : AppConfig.apiBaseUrl;

  static Future<List<Map<String, dynamic>>> fetchTheaters({String? filter}) async {
    final uri = Uri.parse('$_baseUrl/theaters/').replace(queryParameters: filter != null && filter.isNotEmpty ? {'name': filter} : null);
    print('[TheatersApiService] GET: ' + uri.toString());
    final response = await http.get(uri);
    print('[TheatersApiService] Status: ' + response.statusCode.toString());
    print('[TheatersApiService] Body: ' + response.body);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load theaters: \\${response.statusCode} \\${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchTheaterById(String id) async {
    final uri = Uri.parse('$_baseUrl/theaters/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load theater');
    }
  }

  // Add create, update, delete methods as needed
}
