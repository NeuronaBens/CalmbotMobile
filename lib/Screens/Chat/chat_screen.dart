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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenido a',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black, // Set the color as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' Calmbot', // Add a space before Calmbot to separate it from the previous text
                      style: TextStyle(
                        fontSize: 24, // Adjust the font size as needed
                        color: Colors.purple, // Set the color as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Tu chatbot de autoayuda y manejo del estrés y la ansiedad',
                  style: TextStyle(
                    fontSize: 14, // Adjust the font size as needed
                    color: Colors.black, // Set the color as needed
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Inicia tu conversación con un saludo.',
                  style: TextStyle(
                    fontSize: 14, // Adjust the font size as needed
                    color: Colors.grey, // Set the color as needed
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Add a Divider with margin
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 32.0), // Adjust the vertical margin as needed
            child: const Divider(
              height: 20,
              thickness: 1,
              color: Colors.grey,
            ),
          ),
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
