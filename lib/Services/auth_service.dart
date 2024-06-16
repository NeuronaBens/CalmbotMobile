import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];
  final _storage = const FlutterSecureStorage();

  Future<bool> signIn(String email, String password) async {
    //debug code
    print('doing sign in');
    //end of debug code
    final requestBody = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode >= 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];
      final user = jsonResponse['user'];
      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'user', value: jsonEncode(user));

      // Fetch the user's settings
      final settingsResponse = await http.get(
        Uri.parse('$_baseUrl/database/students/${user['id']}/settings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (settingsResponse.statusCode >= 200 &&
          settingsResponse.statusCode <= 300) {
        final settingsJson = jsonDecode(settingsResponse.body);
        final theme = settingsJson['theme'];
        await _storage.write(key: 'theme', value: theme);
      }

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
    await _storage.delete(key: 'user'); // Clear the user object
    await _storage.write(key: 'theme', value: "Claro");
    // Clear any other user-related data from storage
  }
}
