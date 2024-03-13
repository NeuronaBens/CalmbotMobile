import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService { 
  static const String _baseUrl = 'https://your-next-js-server.com/api/auth';
  final _storage = const FlutterSecureStorage();

  Future<bool> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signin'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final token = response.body; // Assuming the server returns a JWT token
      await _storage.write(key: 'token', value: token);
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