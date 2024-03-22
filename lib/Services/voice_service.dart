// voice_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class VoiceService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY']!;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> textToSpeech(String text) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/audio/speech'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'tts-1',
        'input': text,
        'voice': 'alloy',
      }),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      await _audioPlayer.setAudioSource(MyCustomSource(bytes));
      await _audioPlayer.play();
    } else {
      throw Exception('Failed to convert text to speech');
    }
  }

  Future<void> stopSpeech() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
    }
  }
}

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;

  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
