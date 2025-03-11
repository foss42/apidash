import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/jwt_utils.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  // Login and store token
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        if (token != null) {
          await JwtUtils.saveToken(token);
          return true;
        }
      }
    } catch (e) {
      print("Login error: $e");
    }
    return false;
  }

  // Logout (delete token)
  Future<void> logout() async {
    await JwtUtils.deleteToken();
  }

  // Check if the user is authenticated
  Future<bool> isAuthenticated() async {
    return await JwtUtils.isAuthenticated();
  }

  // Retrieve user details from the stored JWT
  Future<Map<String, dynamic>> getUserInfo() async {
    return await JwtUtils.getPayload();
  }
}
