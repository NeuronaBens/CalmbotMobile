
import 'package:flutter_auth/Models/sex.dart';

import 'career.dart';

class Settings {
  String id;
  bool dataCollection;
  String theme;
  String studentId;

  Settings(
      {required this.id,
      required this.dataCollection,
      required this.theme,
      required this.studentId});
}

class SettingsComplete {
  String id;
  bool dataCollection;
  String theme;
  Student student;

  SettingsComplete({
    required this.id,
    required this.dataCollection,
    required this.theme,
    required this.student,
  });

  factory SettingsComplete.fromJson(Map<String, dynamic> json) {
    return SettingsComplete(
      id: json['id'],
      dataCollection: json['data_collection'],
      theme: json['theme'],
      student: Student.fromJson(json['student']),
    );
  }
}

class Student {
  String id;
  String? name;
  String? email;
  String? image;
  String roleId;
  String description;
  DateTime dateOfBirth;
  Sex sex;
  Career career;
  DateTime? deletedAt;

  Student({
    required this.id,
    this.name,
    this.email,
    this.image,
    required this.roleId,
    required this.description,
    required this.dateOfBirth,
    required this.sex,
    required this.career,
    this.deletedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['user']?['name'],
      email: json['user']?['email'],
      image: json['user']?['image'],
      roleId: json['user']['role_id'],
      description: json['description'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      sex: Sex.fromJson(json['sex']),
      career: Career.fromJson(json['career']),
      deletedAt: json['user']['deleted_at'] != null
          ? DateTime.parse(json['user']['deleted_at'])
          : null,
    );
  }
}



