// message_widget.dart
import 'package:flutter/material.dart';
import '../Models/message_model.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isUserMessage;
  final VoidCallback? onDeleteMessage;
  final VoidCallback? onBookmarkMessage;

  const MessageWidget({
    super.key,
    required this.message,
    required this.isUserMessage,
    this.onDeleteMessage,
    this.onBookmarkMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.white60 : Colors.purple,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: isUserMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(message.text),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onDeleteMessage,
                    icon: const Icon(Icons.delete),
                    splashRadius: 18.0,
                  ),
                  IconButton(
                    onPressed: onBookmarkMessage,
                    icon: const Icon(Icons.bookmark),
                    splashRadius: 18.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
