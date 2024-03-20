import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Function(String) onSendMessage;

  const InputField({Key? key, required this.onSendMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onSendMessage(textController.text);
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}