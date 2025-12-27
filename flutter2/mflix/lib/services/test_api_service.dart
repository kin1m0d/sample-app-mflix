import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class TestApiService {
  static String get _baseUrl => AppConfig.apiBaseUrl.endsWith('/')
      ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
      : AppConfig.apiBaseUrl;

  static Future<String> fetchTest() async {
    final uri = Uri.parse('$_baseUrl/test');
    print('[TestApiService] GET: ' + uri.toString());
    final response = await http.get(uri);
    print('[TestApiService] Status: ' + response.statusCode.toString());
    print('[TestApiService] Body: ' + response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load test: \\${response.statusCode} \\${response.body}');
    }
  }
}
