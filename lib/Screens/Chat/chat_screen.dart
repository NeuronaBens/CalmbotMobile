import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import '../../Components/app_menu.dart';
import '../../Components/message_widget.dart';
import '../../Models/message.dart';
import '../../Services/auth_service.dart';
import '../../Services/chat_service.dart';
import '../../Utils/load_theme.dart';
import 'package:flutter_list_view/flutter_list_view.dart';

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
  bool _isLoading = true;

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
            return const WelcomeScreen();
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
      _isLoading = false;
    });
  }

  Future<void> _sendMessage(String text) async {
    // Get the last message from the message list
    final lastMessage = _messages.isNotEmpty ? _messages.last : null;

    // Create a new message object for the user-sent message
    final userMessage = Message(
      id: 'MSG-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      session: lastMessage != null ? lastMessage.session : 1,
      position: lastMessage != null ? lastMessage.position + 1 : 0,
      sender: true,
      deleted: false,
      bookmarked: false,
      dateSend: DateTime.now(),
      studentId: 'USR-${DateTime.now().millisecondsSinceEpoch}',
    );

    // Add the user-sent message to the message list
    setState(() {
      _messages.add(userMessage);
    });

    // Send the message and get the response from the chat service asynchronously
    final machineMessageFuture = _chatService.sendMessage(text);

    // Add the machine response to the message list when it's available
    machineMessageFuture.then((machineMessage) {
      setState(() {
        _messages.add(machineMessage);
      });
    });
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
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : FlutterListView(
                      delegate: FlutterListViewDelegate(
                            (BuildContext context, int index) {
                          final message = _messages[index];
                          return MessageWidget(message: message);
                        },
                        childCount: _messages.length,
                        initIndex:
                        _messages.length - 1, // Start at the last message
                        initOffset: 0,
                        initOffsetBasedOnBottom: true, // Scroll to the bottom
                      ),
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
