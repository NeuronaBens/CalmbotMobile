class StudentNotification {
  final String id;
  final String studentId;
  final String notificationId;
  final bool read;

  StudentNotification({
    required this.id,
    required this.studentId,
    required this.notificationId,
    required this.read,
  });
}

class NotificationC {
  final String id;
  final String name;
  final String content;
  final DateTime dateSent;
  final String adminId;

  NotificationC({
    required this.id,
    required this.name,
    required this.content,
    required this.dateSent,
    required this.adminId,
  });
}