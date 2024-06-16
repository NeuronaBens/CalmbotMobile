import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/bad_message_service.dart';

Future<void> showReportDialog(BuildContext context, String messageId) async {
  String reportReason = '';

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Reportar Mensaje',
          style: TextStyle(color: Colors.black),
        ),
        content: TextField(
          onChanged: (value) {
            reportReason = value;
          },
          decoration: const InputDecoration(
            hintText: 'Explica el problema...',
            hintStyle: TextStyle(color: Colors.black54),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              await BadMessageService().reportMessage(messageId, reportReason);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Enviar',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}