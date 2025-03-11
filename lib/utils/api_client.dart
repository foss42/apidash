import 'dart:convert';
import 'package:http/http.dart' as http;
import 'jwt_utils.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  // Get request headers with JWT authentication
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await JwtUtils.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET request with authentication
  Future<http.Response> get(String endpoint) async {
    return http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getAuthHeaders(),
    );
  }

  // POST request with authentication
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(body),
    );
  }

  // PUT request with authentication
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    return http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getAuthHeaders(),
      body: jsonEncode(body),
    );
  }

  // DELETE request with authentication
  Future<http.Response> delete(String endpoint) async {
    return http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getAuthHeaders(),
    );
  }
}
