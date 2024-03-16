import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import '../../Services/settings_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants.dart';

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
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchSettingsData();
    _loadTheme();
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

  Future<ThemeData> _loadTheme() async {
    final themeString = await _storage.read(key: 'theme');
    print('Loaded theme: $themeString');
    if (themeString == 'Oscuro') {
      return ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1F2128),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF2B2D3E),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: Typography.material2021().white.copyWith(
          bodyMedium: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            color: Colors.green,
            fontWeight: FontWeight.w300,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 18.0, // Set the desired font size for the label
            color: kPrimaryColor, // Set the color to kPrimaryColor
          ),
        ),
      );
    } else {
      return ThemeData.light();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeData>(
      future: _loadTheme(),
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
                title: const Text('Configuration'),
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
                              backgroundImage: settingsComplete.user.image.isNotEmpty
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
                                      labelText: 'Description',
                                    ),
                                    onChanged: (value) {
                                      settingsComplete.description = value;
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _settingsService.updateStudentDescription(_descriptionController.text);
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
                              'Date of Birth: ${DateFormat('yyyy-MM-dd').format(settingsComplete.dateOfBirth)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Sex: ${settingsComplete.sex.name}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Career: ${settingsComplete.career.name}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            SwitchListTile(
                              title: const Text(
                                'Theme',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              value: settingsComplete.settings.theme == 'Oscuro',
                              onChanged: (value) async {
                                final newTheme = value ? 'Oscuro' : 'Claro';
                                settingsComplete.settings.theme = newTheme;
                                await _settingsService.updateTheme(settingsComplete.settings.id, newTheme);
                                print('Theme updated to: $newTheme');
                                setState(() {});
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
