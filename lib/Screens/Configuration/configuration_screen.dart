import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import '../../Services/settings_service.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  late SettingsComplete settingsComplete;
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _fetchSettingsData();
  }

  Future<void> _fetchSettingsData() async {
    try {
      settingsComplete = await _settingsService.getSettingsRelatedMobile();
      setState(() {});
    } catch (e) {
      // Handle error
      print('Error fetching settings data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    TextField(
                      controller: TextEditingController(
                          text: settingsComplete.description),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
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
                      title: const Text('Theme'),
                      value: settingsComplete.settings.theme == 'dark',
                      onChanged: (value) {
                        setState(() {
                          settingsComplete.settings.theme =
                              value ? 'dark' : 'light';
                          // Update theme setting
                        });
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
    );
  }
}
