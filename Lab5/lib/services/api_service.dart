// ============================================================
// services/api_service.dart
// Tầng HTTP thuần: chỉ gửi request và trả về raw response
// Không chứa business logic — đó là việc của Repository
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client _client;
  static const String baseUrl = 'https://dummyjson.com';

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String path) async {
    final response = await _client.get(Uri.parse('$baseUrl$path'));
    _checkStatus(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    _checkStatus(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final response = await _client.put(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    _checkStatus(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    _checkStatus(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _client.delete(Uri.parse('$baseUrl$path'));
    _checkStatus(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  void dispose() => _client.close();
}