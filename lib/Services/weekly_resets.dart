import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WeeklyResetsService {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];
  final _storage = const FlutterSecureStorage();

  Future<void> resetWeeklyTasks() async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    await http.delete(
      Uri.parse('$_baseUrl/database/students/$studentId/weekly-reset-tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<void> resetWeeklySummary() async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.post(
      Uri.parse('$_baseUrl/database/students/$studentId/weekly-reset'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('Failed to reset weekly summary');
    }
  }
}