class Message {
  int id;
  String session;
  int position;
  bool sender;
  bool deleted;
  bool bookmarked;
  DateTime dateSent;
  String text;
  int studentId;

  Message(
      {required this.id,
      required this.session,
      required this.position,
      required this.sender,
      required this.deleted,
      required this.bookmarked,
      required this.dateSent,
      required this.text,
      required this.studentId});
}
