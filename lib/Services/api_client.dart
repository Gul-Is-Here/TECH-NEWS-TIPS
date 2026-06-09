import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'https://technewstips.com/api';

  /// POST request — returns the decoded JSON map.
  /// Throws [Exception] on non-2xx status codes.
  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, String> body,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Server error: ${response.statusCode}');
  }

  /// GET request — returns the decoded JSON list.
  /// Throws [Exception] on non-200 status codes.
  static Future<List<dynamic>> getList(String path) async {
    final response = await http.get(Uri.parse('$_baseUrl$path'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Server error: ${response.statusCode}');
  }
}
