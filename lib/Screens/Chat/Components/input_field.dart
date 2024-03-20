import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

class InputField extends StatefulWidget {
  final Function(String) onSendMessage;

  const InputField({Key? key, required this.onSendMessage}) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final textController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.onSendMessage(textController.text);
                textController.clear();
              }
            },
          ),
          AvatarGlow(
            animate: _isListening,
            glowColor: Theme.of(context).primaryColor,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
              onPressed: _listen,
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'es-ES', // Set the language to Spanish (Spain)
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3), 
          onResult: (val) => setState(() {
            textController.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              // You can handle the confidence rating here if needed
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
