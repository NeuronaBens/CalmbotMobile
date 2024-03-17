import 'package:flutter/material.dart';
import '../../Models/notification_model.dart';
import '../../Services/notification_service.dart';
import '../../Utils/load_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<dynamic> _studentNotifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final notifications = await _notificationService.getNotifications();
    setState(() {
      _studentNotifications = notifications;
    });
  }
  Future<void> toggleNotificationReadStatus(String notificationId, bool read) async {
    await _notificationService.updateNotificationReadStatus(notificationId, read);
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeData>(
      future: loadTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading theme: ${snapshot.error}');
        } else {
          final theme = snapshot.data!;
          return Theme(
            data: theme,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Notificaciones'),
              ),
              body: _studentNotifications.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _studentNotifications.length,
                itemBuilder: (context, index) {
                  final studentNotification = StudentNotification(
                    id: _studentNotifications[index]['id'],
                    studentId: _studentNotifications[index]['student_id'],
                    notificationId: _studentNotifications[index]['notification_id'],
                    read: _studentNotifications[index]['read'],
                  );
                  final notification = NotificationC(
                    id: _studentNotifications[index]['notification']['id'],
                    name: _studentNotifications[index]['notification']['name'],
                    content: _studentNotifications[index]['notification']['content'],
                    dateSent: DateTime.parse(_studentNotifications[index]['notification']['date_sent']),
                    adminId: _studentNotifications[index]['notification']['admin_id'],
                  );

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        studentNotification.read ? Icons.mark_email_read : Icons.mark_email_unread,
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
                        toggleNotificationReadStatus(
                          studentNotification.id,
                          !studentNotification.read,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

}