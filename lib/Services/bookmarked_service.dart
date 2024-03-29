import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookmarkedMessageService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';
  final _storage = const FlutterSecureStorage();

  Future<List<dynamic>> getBookmarkedMessages() async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.get(
      Uri.parse('$_baseUrl/database/students/$studentId/messages/bookmarked'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse;
    }

    return [];
  }
}