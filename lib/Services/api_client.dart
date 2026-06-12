import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tnt/Config/app_config.dart';

/// Describes a file to attach in a multipart request.
class MultipartFileInput {
  final String field; // form field name (e.g. 'avatar', 'cover')
  final String path;  // absolute file path on device

  const MultipartFileInput({required this.field, required this.path});
}

class ApiClient {
  /// POST request — returns the decoded JSON map.
  /// Throws [Exception] on non-2xx status codes.
  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, String> body,
  ) async {
    final response = await http
        .post(Uri.parse('$kBaseUrl$path'), body: body)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Server error: ${response.statusCode}');
  }

  /// GET request — returns the decoded JSON map.
  /// Pass [queryParams] for URL query parameters (e.g. ?user_id=34).
  /// Throws [Exception] on non-200 status codes.
  static Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$kBaseUrl$path')
        .replace(queryParameters: queryParams);
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Server error: ${response.statusCode}');
  }

  /// Multipart POST — sends text [fields] and optional image [files].
  /// Throws [Exception] on non-2xx status codes.
  static Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String>? fields,
    List<MultipartFileInput> files = const [],
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$kBaseUrl$path'),
    );
    if (fields != null) request.fields.addAll(fields);
    for (final f in files) {
      request.files.add(await http.MultipartFile.fromPath(f.field, f.path));
    }
    final streamed = await request.send().timeout(const Duration(seconds: 20));
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode == 200 || streamed.statusCode == 201) {
      return jsonDecode(body) as Map<String, dynamic>;
    }
    throw Exception('Server error: ${streamed.statusCode}');
  }

  /// GET request — returns the decoded JSON list.
  /// Throws [Exception] on non-200 status codes.
  static Future<List<dynamic>> getList(String path) async {
    final response = await http
        .get(Uri.parse('$kBaseUrl$path'))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Server error: ${response.statusCode}');
  }
}
