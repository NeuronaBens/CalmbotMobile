import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import '../../Services/settings_service.dart';
import '../../Utils/load_theme.dart';
import '../../constants.dart';
import '../Chat/chat_screen.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  SettingsComplete? settingsComplete;
  final SettingsService _settingsService = SettingsService();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSettingsData();
    loadTheme(); //just this is needed to alter the theme.
  }

  Future<void> _fetchSettingsData() async {
    try {
      settingsComplete = await _settingsService.getSettingsRelatedMobile();
      _descriptionController.text = settingsComplete?.description ?? '';
      setState(() {});
    } catch (e) {
      // Handle error
      print('Error fetching settings data: $e');
    }
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
          print('Building ConfigurationScreen with theme: ${theme.brightness}');
          return Theme(
            data: theme,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Configuración'),
              ),
              body: FutureBuilder<SettingsComplete>(
                future: _settingsService.getSettingsRelatedMobile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final settingsComplete = snapshot.data!;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: settingsComplete
                                      .user.image.isNotEmpty
                                  ? NetworkImage(settingsComplete.user.image)
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              settingsComplete.user.name,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              settingsComplete.user.email,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 32.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Descripción',
                                    ),
                                    onChanged: (value) {
                                      settingsComplete.description = value;
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _settingsService.updateStudentDescription(
                                        _descriptionController.text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(32, 32),
                                    shape: const CircleBorder(),
                                  ),
                                  child: const Icon(Icons.check),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Fecha de Nacimiento: ${DateFormat('yyyy-MM-dd').format(settingsComplete.dateOfBirth)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Genero: ${settingsComplete.sex.name}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Carrera: ${settingsComplete.career.name}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            SwitchListTile(
                              title: const Text(
                                'Tema',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              value: settingsComplete.settings.theme == 'Oscuro',
                              onChanged: (value) async {
                                final newTheme = value ? 'Oscuro' : 'Claro';
                                settingsComplete.settings.theme = newTheme;
                                await _settingsService.updateTheme(
                                    settingsComplete.settings.id, newTheme);
                                print('Theme updated to: $newTheme');
                                setState(() {});

                                // Navigate to the chat screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }
}
