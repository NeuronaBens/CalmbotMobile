import 'package:flutter/material.dart';

class DisplayableMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Text('Your App Name'),
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Tasks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TasksScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuration'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigurationScreen(),
                ),
              );
            },
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 0.1,
          ),
          Container(
            height: 100,
            child: Row(
              children: <Widget>[
                TextButton(
                  child: Text('Logout'),
                  onPressed: () {
                    print('Logout');
                  },
                ),
                Text('Your App Name - v1.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Center(
        child: Text('Chat Content'),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Screen'),
      ),
      body: Center(
        child: Text('Notifications Content'),
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Screen'),
      ),
      body: Center(
        child: Text('Tasks Content'),
      ),
    );
  }
}

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration Screen'),
      ),
      body: Center(
        child: Text('Configuration Content'),
      ),
    );
  }
}
