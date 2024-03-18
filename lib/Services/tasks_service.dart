import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Models/task_model.dart';

class TasksService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';
  final _storage = const FlutterSecureStorage();

  Future<List<StudentTask>> getStudentTasks() async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.get(
      Uri.parse('$_baseUrl/database/students/$studentId/tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map<StudentTask>((json) => StudentTask.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> updateTaskCompletion(String taskId, int completed) async {
    final token = await _storage.read(key: 'token');

    await http.put(
      Uri.parse('$_baseUrl/database/student-tasks/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'completed': completed}),
    );
  }
}