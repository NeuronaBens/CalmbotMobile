import 'package:flutter/material.dart';
import '../../Models/user.dart';
import '../../Models/student.dart';
import '../../Models/settings.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  late User user;
  late Student student;
  late Settings settings;

  @override
  void initState() {
    super.initState();
    // Initialize user, student, and settings with mock data
    user = User(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      password: 'password',
      image:
          'https://www.ohchr.org/sites/default/files/styles/hero_image_2/public/2021-07/Ethiopia-UN0418425.jpg',
      deletedAt: DateTime.now(),
      roleId: 1,
    );
    student = Student(
      studentId: 1,
      description: 'Student description',
      careerId: 1,
      dateOfBirth: DateTime(1990, 1, 1),
      sexId: 1,
    );
    settings = Settings(
      id: 1,
      dataCollection: true,
      theme: 'light',
      studentId: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuración'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(user.image),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: user.name),
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        // Handle confirmation for name change
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: student.description),
                        decoration: const InputDecoration(
                          labelText: 'Descripción del estudiante',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        // Handle confirmation for name change
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                SwitchListTile(
                  title: const Text('Tema'),
                  value: settings.theme == 'dark',
                  onChanged: (value) {
                    setState(() {
                      settings.theme = value ? 'dark' : 'light';
                    });
                  },
                  secondary: const Icon(Icons.brightness_6),
                )
              ],
            ),
          ),
        ));
  }
}
