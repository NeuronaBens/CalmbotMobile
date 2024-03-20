import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import '../../Components/app_menu.dart';
import '../../Models/message.dart';
import '../../Services/auth_service.dart';
import '../../Services/chat_service.dart';
import '../../Utils/load_theme.dart';
import 'message_list.dart';
import 'input_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();
          },
        ),
      );
    } else {
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
    final lastMessage = _messages.isNotEmpty ? _messages.last : null;

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

    setState(() {
      _messages.add(userMessage);
    });

    final machineMessageFuture = _chatService.sendMessage(text);

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
                  MessageList(messages: _messages, isLoading: _isLoading),
                  InputField(onSendMessage: _sendMessage),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}