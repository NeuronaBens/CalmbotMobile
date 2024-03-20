import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import '../../../Components/message_widget.dart';
import '../../../Models/message.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final bool isLoading;

  const MessageList({
    Key? key,
    required this.messages,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterListView(
        delegate: FlutterListViewDelegate(
              (BuildContext context, int index) {
            final message = messages[index];
            return MessageWidget(message: message);
          },
          childCount: messages.length,
          initIndex: messages.length - 1, // Start at the last message
          initOffset: 0,
          initOffsetBasedOnBottom: true, // Scroll to the bottom
        ),
      ),
    );
  }
}