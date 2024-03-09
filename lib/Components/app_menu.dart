import 'package:flutter/material.dart';

import '../Screens/Chat/chat_screen.dart';
import '../Screens/Configuration/configuration_screen.dart';
import '../Screens/Favorites/favorites_screen.dart';
import '../Screens/Notifications/notification_screen.dart';
import '../Screens/Tasks/tasks_screen.dart';

class DisplayableMenu extends StatelessWidget {
  const DisplayableMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Text('Calmbot'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Favoritos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TasksScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfigurationScreen(),
                ),
              );
            },
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 0.1,
          ),
          SizedBox(
            height: 100,
            child: Row(
              children: <Widget>[
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    print('Logout');
                  },
                ),
                const Text('Calmbot - v1.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
