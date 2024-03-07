// chat_screen.dart
import 'package:flutter/material.dart';
import '../../Components/app_menu.dart';
import '../../Models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(sender: 'User', text: 'Hello!'),
    Message(sender: 'Bot', text: 'Hi there! How can I help you?'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      drawer: DisplayableMenu(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.sender),
                  subtitle: Text(message.text),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // TODO: Send message functionality (use API when available)
              // For now, add a dummy message to the list
              _addMessage(Message(sender: 'User', text: 'Dummy message'));
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
