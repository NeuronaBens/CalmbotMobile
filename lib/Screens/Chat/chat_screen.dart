// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import '../../Components/app_menu.dart';
import '../../Components/message_widget.dart';
import '../../Models/message.dart';
import '../../Services/auth_service.dart';
import '../../Utils/load_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(
      id: "1",
      session: 1,
      position: 1,
      sender: true,
      deleted: false,
      bookmarked: false,
      dateSend: DateTime.now(),
      text: 'Hello!',
      studentId: "2",
    ),
    Message(
      id: "2",
      session: 1,
      position: 2,
      sender: false,
      deleted: false,
      bookmarked: false,
      dateSend: DateTime.now(),
      text: 'Hi there! How can I help you?',
      studentId: "2",
    ),
  ];

  final _authService =
      AuthenticationService(); // Create an instance of the authentication service

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
              ), // your app bar
              drawer: const DisplayableMenu(),
              body: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: _messages.map((message) {
                        return MessageWidget(
                          message: message,
                        );
                      }).toList(),
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
            onPressed: () {
              if (textController.text.isNotEmpty) {
                _addMessage(
                  Message(
                    id: "ddd",
                    session: 1,
                    position: _messages.length + 1,
                    sender: true,
                    deleted: false,
                    bookmarked: false,
                    dateSend: DateTime.now(),
                    text: textController.text,
                    studentId: "2",
                  ),
                );
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _addMessage(Message message) {
    setState(() {
      _messages.add(message);
    });
  }
}
