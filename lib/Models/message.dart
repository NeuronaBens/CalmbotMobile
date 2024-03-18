class Message {
  final String id;
  final int session;
  final int position;
  final bool sender;
  final bool deleted;
  final bool bookmarked;
  final DateTime dateSend;
  final String text;
  final String studentId;

  Message({
    required this.id,
    required this.session,
    required this.position,
    required this.sender,
    required this.deleted,
    required this.bookmarked,
    required this.dateSend,
    required this.text,
    required this.studentId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      session: json['session'],
      position: json['position'],
      sender: json['sender'],
      deleted: json['deleted'],
      bookmarked: json['bookmarked'],
      dateSend: DateTime.parse(json['date_send']),
      text: json['text'],
      studentId: json['student_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session': session,
      'position': position,
      'sender': sender,
      'deleted': deleted,
      'bookmarked': bookmarked,
      'date_send': dateSend.toIso8601String(),
      'text': text,
      'student_id': studentId,
    };
  }

  bool get isSentByUser => sender;
  bool get isSentByAI => !sender;

  String get senderName {
    return sender ? 'User' : 'AI';
  }
}