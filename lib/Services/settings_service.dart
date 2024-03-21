import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsComplete {
  final String studentId;
  late final String description;
  final DateTime dateOfBirth;
  final String sexId;
  final String careerId;
  final User user;
  final Career career;
  final Sex sex;
  final Settings settings;

  SettingsComplete({
    required this.studentId,
    required this.description,
    required this.dateOfBirth,
    required this.sexId,
    required this.careerId,
    required this.user,
    required this.career,
    required this.sex,
    required this.settings,
  });

  factory SettingsComplete.fromJson(Map<String, dynamic> json) {
    return SettingsComplete(
      studentId: json['student_id'],
      description: json['description'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      sexId: json['sex_id'],
      careerId: json['career_id'],
      user: User.fromJson(json['user']),
      career: Career.fromJson(json['career']),
      sex: Sex.fromJson(json['sex']),
      settings: Settings.fromJson(json['settings']),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String image;
  final dynamic deletedAt;
  final String roleId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    this.deletedAt,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      deletedAt: json['deleted_at'],
      roleId: json['role_id'],
    );
  }
}

class Career {
  final String id;
  final String name;
  final String description;

  Career({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Sex {
  final String id;
  final String name;

  Sex({
    required this.id,
    required this.name,
  });

  factory Sex.fromJson(Map<String, dynamic> json) {
    return Sex(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Settings {
  final String id;
  bool _dataCollection;
  String _theme;
  final String studentId;

  Settings({
    required this.id,
    required bool dataCollection,
    required String theme,
    required this.studentId,
  })  : _dataCollection = dataCollection,
        _theme = theme;

  bool get dataCollection => _dataCollection;
  set dataCollection(bool value) {
    _dataCollection = value;
  }

  String get theme => _theme;
  set theme(String value) {
    _theme = value;
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'],
      dataCollection: json['data_collection'],
      theme: json['theme'],
      studentId: json['student_id'],
    );
  }
}

class SettingsService {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];
  final _storage = const FlutterSecureStorage();

  Future<SettingsComplete> getSettingsRelatedMobile() async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.get(
      Uri.parse(
          '$_baseUrl/database/students/$studentId/get-settings-related-mobile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return SettingsComplete.fromJson(jsonResponse);
    }

    throw Exception('Failed to load settings');
  }

  Future<void> updateStudentDescription(String description) async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final body =
        jsonEncode({'student_id': studentId, 'description': description});

    final response = await http.put(
      Uri.parse('$_baseUrl/database/students/$studentId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }

  Future<void> updateTheme(String settingsId, String theme) async {
    final token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final body = jsonEncode({'id': settingsId, 'theme': theme});

    final response = await http.put(
      Uri.parse('$_baseUrl/database/students/$studentId/settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Update the theme in _storage
      await _storage.write(key: 'theme', value: theme);
    }
  }
}
