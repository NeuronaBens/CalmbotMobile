import 'package:flutter/material.dart';
import '../../Services/bookmarked_service.dart';
import '../../constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  final _bookmarkedMessageService = BookmarkedMessageService();
  List<dynamic> _bookmarkedMessages = [];

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedMessages();
  }

  Future<void> _fetchBookmarkedMessages() async {
    final messages = await _bookmarkedMessageService.getBookmarkedMessages();
    setState(() {
      _bookmarkedMessages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bienvenido a ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tus Marcadores',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aquí podrás ver y gestionar los mensajes que has guardado durante las sesiones.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                for (int index = 0; index < _bookmarkedMessages.length; index++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bookmarkedMessages[index]['text'],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Enviado por: ${_bookmarkedMessages[index]['sender'] ? 'Tú' : 'Calmbot'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Fecha: ${_bookmarkedMessages[index]['date_send'].toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
