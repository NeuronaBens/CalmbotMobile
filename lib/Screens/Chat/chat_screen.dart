// chat_screen.dart
import 'package:flutter/material.dart';
import '../../Components/app_menu.dart';
import '../../Components/message_widget.dart';
import '../../Models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(
      id: 1,
      session: 'session1',
      position: 1,
      sender: true,
      deleted: false,
      bookmarked: false,
      dateSent: DateTime.now(),
      text: 'Hello!',
      studentId: 1,
    ),
    Message(
      id: 2,
      session: 'session1',
      position: 2,
      sender: false,
      deleted: false,
      bookmarked: false,
      dateSent: DateTime.now(),
      text: 'Hi there! How can I help you?',
      studentId: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return MessageWidget(
                  message: message,
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
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
                    id: _messages.length + 1,
                    session: 'session1',
                    position: _messages.length + 1,
                    sender: true,
                    deleted: false,
                    bookmarked: false,
                    dateSent: DateTime.now(),
                    text: textController.text,
                    studentId: 1,
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
