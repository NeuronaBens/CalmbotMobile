import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Models/message.dart';

class ChatService {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<Message>> fetchMessages() async {
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.get(
      Uri.parse('$_baseUrl/database/students/$studentId/messages/current-session'),
      headers: {'Authorization': 'Bearer ${await _storage.read(key: 'token')}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map<Message>((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  Future<Message> sendMessage(String text) async {
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.post(
      Uri.parse('$_baseUrl/database/students/$studentId/messages'),
      headers: {
        'Authorization': 'Bearer ${await _storage.read(key: 'token')}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': text}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return Message.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to send message');
    }
  }
}