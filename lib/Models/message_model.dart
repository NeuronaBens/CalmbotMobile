// message_model.dart
class Message {
  final String sender;
  final String text;
  final bool isUserMessage;
  bool isBookmarked;

  Message({
    required this.sender,
    required this.text,
    required this.isUserMessage,
    this.isBookmarked = false,
  });
}
