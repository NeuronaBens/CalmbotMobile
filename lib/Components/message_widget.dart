// message_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import '../Models/message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        constraints: BoxConstraints(
          maxWidth:
          MediaQuery.of(context).size.width * 0.75, // 2/3 of screen width
        ),
        decoration: BoxDecoration(
          color: message.sender ? kPrimaryColor.withOpacity(0.75) : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.text ?? '', // Use an empty string if message.text is null
          style: TextStyle(
            color: message.sender ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}