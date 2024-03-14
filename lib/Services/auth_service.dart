import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  // TODO: change to actual host
  static const String _baseUrl = 'http://10.0.2.2:3000/api/auth';
  final _storage = const FlutterSecureStorage();

  Future<bool> signIn(String email, String password) async {
    final requestBody = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];
      final user = jsonResponse['user'];
      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'user', value: jsonEncode(user));

      return true;
    }

    return false;
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    // Clear any other user-related data from storage
  }
}
