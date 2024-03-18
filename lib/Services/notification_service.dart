import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';
  final _storage = const FlutterSecureStorage();

  Future<List<dynamic>> getNotifications() async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.get(
      Uri.parse('$_baseUrl/database/students/$studentId/notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }

    return [];
  }
  Future<void> updateNotificationReadStatus(String notificationId, bool read) async {
    final token = await _storage.read(key: 'token');

    final response = await http.put(
      Uri.parse('$_baseUrl/database/student-notifications/$notificationId'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'read': read}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update notification read status');
    }
  }
}