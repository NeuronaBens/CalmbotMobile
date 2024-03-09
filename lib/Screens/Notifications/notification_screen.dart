import 'package:flutter/material.dart';
import '../../Models/notification.dart';
import '../../Models/student_notification.dart';

final dummyNotification = NotificationC(
  id: 1,
  name: 'New Update Available',
  content:
      'A new version of the app is available. Please update to enjoy the latest features and bug fixes.',
  dateSent: DateTime.now(),
  adminId: 1,
);

List<StudentNotification> studentNotifications = [
  StudentNotification(
    id: 1,
    notificationId: dummyNotification.id,
    studentId: 1,
    read: false,
  ),
  StudentNotification(
    id: 2,
    notificationId: dummyNotification.id,
    studentId: 2,
    read: true,
  ),
];

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: ListView.builder(
        itemCount: studentNotifications.length,
        itemBuilder: (context, index) {
          final studentNotification = studentNotifications[index];
          final notification =
              dummyNotification; // Assuming all notifications are the same for now

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                studentNotification.read
                    ? Icons.mark_email_read
                    : Icons.mark_email_unread,
                color: studentNotification.read ? Colors.green : Colors.red,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    notification.dateSent.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: Text(notification.content),
              onTap: () {
                // Handle notification tap
              },
            ),
          );
        },
      ),
    );
  }
}
