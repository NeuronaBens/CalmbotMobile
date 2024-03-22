// message_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import '../../../Models/message.dart';
import '../../../Services/bad_message_service.dart';
import '../../../Services/bookmarked_service.dart';
import '../../../Services/voice_service.dart';
import '../../../Utils/show_report_dialog.dart';

class MessageWidget extends StatefulWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  MessageWidgetState createState() => MessageWidgetState();
}

class MessageWidgetState extends State<MessageWidget> {
  final BookmarkedMessageService _bookmarkedService = BookmarkedMessageService();
  final VoiceService _voiceService = VoiceService();
  bool _isSpeaking = false;

  void _toggleSpeech() {
    setState(() {
      if (_isSpeaking) {
        _voiceService.stopSpeech();
      } else {
        _voiceService.textToSpeech(widget.message.text);
      }
      _isSpeaking = !_isSpeaking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.message.sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        constraints: BoxConstraints(
          maxWidth:
          MediaQuery.of(context).size.width * 0.75, // 2/3 of screen width
        ),
        decoration: BoxDecoration(
          color: widget.message.sender
              ? kPrimaryColor.withOpacity(0.75)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: widget.message.sender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              widget.message.text, // Use an empty string if message.text is null
              style: TextStyle(
                color: widget.message.sender ? Colors.white : Colors.black,
              ),
            ),
            if (!widget.message.sender)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(_isSpeaking ? Icons.stop : Icons.play_arrow),
                    onPressed: _toggleSpeech,
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
                          await _bookmarkedService.toggleBookmark(widget.message.id);
                          break;
                        case 2:
                        // Implement "Eliminar" functionality
                          await BadMessageService().deleteMessage(widget.message.id);
                          break;
                        case 3:
                        // Implement "Reportar" functionality
                          await showReportDialog(context, widget.message.id);
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
