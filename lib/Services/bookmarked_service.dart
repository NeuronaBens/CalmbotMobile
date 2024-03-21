import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookmarkedMessageService {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];
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

  Future<void> toggleBookmark(String messageId) async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$_baseUrl/database/messages/$messageId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final message = jsonDecode(response.body);
      final updatedMessage = {...message, 'bookmarked': !message['bookmarked']};

      final updateResponse = await http.put(
        Uri.parse('$_baseUrl/database/messages/$messageId'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(updatedMessage),
      );

      if (updateResponse.statusCode != 200) {
        throw Exception('Failed to toggle bookmark');
      }
    } else {
      throw Exception('Failed to fetch message');
    }
  }
}
