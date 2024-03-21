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