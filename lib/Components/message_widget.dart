// message_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import '../Models/message.dart';
import '../Services/bad_message_service.dart';
import '../Services/bookmarked_service.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final BookmarkedMessageService _bookmarkedService = BookmarkedMessageService();

  MessageWidget({super.key, required this.message});

  Future<void> _showReportDialog(BuildContext context, String messageId) async {
    String reportReason = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Reportar Mensaje',
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            onChanged: (value) {
              reportReason = value;
            },
            decoration: const InputDecoration(
              hintText: 'Explica el problema...',
              hintStyle: TextStyle(color: Colors.black54),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                await BadMessageService().reportMessage(messageId, reportReason);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Enviar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

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
          color: message.sender
              ? kPrimaryColor.withOpacity(0.75)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: message.sender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text, // Use an empty string if message.text is null
              style: TextStyle(
                color: message.sender ? Colors.white : Colors.black,
              ),
            ),
            if (!message.sender)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      // Implement voice reading functionality
                    },
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Text("Hacer Favorito"),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text("Eliminar"),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Text("Reportar"),
                      ),
                    ],
                    onSelected: (value) async {
                      // Handle selected menu item
                      switch (value) {
                        case 1:
                        // Implement "Hacer Favorito" functionality
                          await _bookmarkedService.toggleBookmark(message.id);
                          break;
                        case 2:
                        // Implement "Eliminar" functionality
                          await BadMessageService().deleteMessage(message.id);
                          break;
                        case 3:
                        // Implement "Reportar" functionality
                          await _showReportDialog(context, message.id);
                          break;
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}