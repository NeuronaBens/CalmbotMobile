class Notification {
  int id;
  String name;
  String content;
  DateTime dateSent;
  int adminId;

  Notification(
      {required this.id,
      required this.name,
      required this.content,
      required this.dateSent,
      required this.adminId});
}
