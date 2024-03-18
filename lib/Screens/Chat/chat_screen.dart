import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/constants.dart';
import '../../Components/app_menu.dart';
import '../../Components/message_widget.dart';
import '../../Models/message.dart';
import '../../Services/auth_service.dart';
import '../../Services/chat_service.dart';
import '../../Utils/load_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = [];
  final _authService = AuthenticationService();
  final _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

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
    final messages = await _chatService.fetchMessages();
    setState(() {
      _messages = messages;
    });
  }

  Future<void> _sendMessage(String text) async {
    final message = await _chatService.sendMessage(text);
    setState(() {
      _messages.add(message);
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
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
              floatingActionButton: FloatingActionButton(
                onPressed: _scrollToBottom,
                child: const Icon(Icons.arrow_downward),
                mini: true,
                shape: const CircleBorder(),
                backgroundColor: kPrimaryColor,
                foregroundColor: kPrimaryLightColor,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
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