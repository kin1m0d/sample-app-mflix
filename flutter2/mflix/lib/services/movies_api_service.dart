import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class MoviesApiService {
  static String get _baseUrl => AppConfig.apiBaseUrl.endsWith('/')
      ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
      : AppConfig.apiBaseUrl;

  static Future<List<Map<String, dynamic>>> fetchMovies({String? filter}) async {
    final uri = Uri.parse('$_baseUrl/movies/').replace(queryParameters: filter != null && filter.isNotEmpty ? {'title': filter} : null);
    print('[MoviesApiService] GET: ' + uri.toString());
    final response = await http.get(uri);
    print('[MoviesApiService] Status: ' + response.statusCode.toString());
    print('[MoviesApiService] Body: ' + response.body);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load movies: ${response.statusCode} ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchMovieById(String id) async {
    final uri = Uri.parse('$_baseUrl/movies/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie');
    }
  }

  // Add create, update, delete methods as needed
}
