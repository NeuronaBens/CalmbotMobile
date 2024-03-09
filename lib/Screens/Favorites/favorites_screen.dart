import 'package:flutter/material.dart';

import '../../Models/message.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Message> _bookmarkedMessages = [];

  @override
  void initState() {
    super.initState();
    // Assuming you have access to a list of all messages
    List<Message> allMessages = [
      // Add your messages here
    ];
    _bookmarkedMessages =
        allMessages.where((message) => message.bookmarked).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: ListView.builder(
        itemCount: _bookmarkedMessages.length,
        itemBuilder: (context, index) {
          final message = _bookmarkedMessages[index];
          return ListTile(
            title: Text(message.text),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enviado por: ${message.sender ? 'Tú' : 'Calmbot'}'),
                Text('Fecha: ${message.dateSent.toString()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
