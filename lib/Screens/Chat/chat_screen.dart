// chat_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../Components/app_menu.dart';
import '../../Components/message_widget.dart';
import '../../Models/message.dart';
import '../../Services/auth_service.dart';
import '../../Utils/load_theme.dart';

import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = [];
  final _authService = AuthenticationService();
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://10.0.2.2:3000/api';

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isAuthenticated = await _authService.isAuthenticated();

    if (!isAuthenticated) {
      // Navigate to the login screen or show an error message
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ChatScreen();
          },
        ),
      );
    } else {
      // Fetch existing messages from the last session
      await _fetchMessages();
    }
  }

  Future<void> _fetchMessages() async {
    final userJson = await _storage.read(key: 'user');
    final user = jsonDecode(userJson!);
    final studentId = user['id'];

    final response = await http.get(
      Uri.parse('$_baseUrl/database/students/$studentId/messages/current-session'),
      headers: {'Authorization': 'Bearer ${await _storage.read(key: 'token')}'},
    );


    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _messages = jsonResponse.map<Message>((json) => Message.fromJson(json)).toList();
      });
    }
  }

  Future<void> _sendMessage(String text) async {
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
      setState(() {
        _messages.add(Message.fromJson(jsonResponse));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeData>(
      future: loadTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading theme: ${snapshot.error}');
        } else {
          final theme = snapshot.data!;
          return Theme(
            data: theme,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Chat'),
              ),
              drawer: const DisplayableMenu(),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return MessageWidget(message: message);
                      },
                    ),
                  ),
                  _buildInputField(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildInputField() {
    final textController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                await _sendMessage(textController.text);
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}