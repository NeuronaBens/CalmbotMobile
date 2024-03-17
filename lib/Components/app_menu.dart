import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Screens/Chat/chat_screen.dart';
import '../Screens/Configuration/configuration_screen.dart';
import '../Screens/Favorites/favorites_screen.dart';
import '../Screens/Login/login_screen.dart';
import '../Screens/Notifications/notification_screen.dart';
import '../Screens/Tasks/tasks_screen.dart';
import '../Services/auth_service.dart';

class DisplayableMenu extends StatelessWidget {
  const DisplayableMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: Colors.black), // Adjust width and color as needed
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  height: 75,
                  child: SvgPicture.asset('assets/icons/logo.svg'),
                ),
                const SizedBox(height: 8),
                const Text(
                  '     Calmbot     ',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
              ],
            ),
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
                  onPressed: () async {
                    final authService = AuthenticationService();
                    await authService.logout();
                    // Navigate to the login screen
                    SystemNavigator.pop();
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                        maintainState: false,
                      ),
                    );
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
