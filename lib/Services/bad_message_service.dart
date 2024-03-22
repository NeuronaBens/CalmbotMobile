import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BadMessageService {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];
  final _storage = const FlutterSecureStorage();

  Future<void> deleteMessage(String messageId) async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$_baseUrl/database/messages/$messageId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final message = jsonDecode(response.body);
      final updatedMessage = {...message, 'deleted': !message['deleted']};

      final updateResponse = await http.put(
        Uri.parse('$_baseUrl/database/messages/$messageId'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(updatedMessage),
      );

      if (updateResponse.statusCode != 200) {
        print(updateResponse); //debug
        throw Exception('Failed to toggle delete');
      }
    } else {
      throw Exception('Failed to fetch message');
    }
  }

  Future<void> reportMessage(String messageId, String content) async {
    final token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$_baseUrl/database/complaints'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'content': content, 'message_id': messageId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to report message');
    }
  }
}