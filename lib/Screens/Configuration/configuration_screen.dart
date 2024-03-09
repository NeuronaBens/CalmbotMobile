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
      collectionId: 'collection1',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.image),
            ),
            const SizedBox(height: 16),
            _buildTextField('Url perfil', user.image),
            const SizedBox(height: 16),
            _buildTextField('Nombre', user.name),
            const SizedBox(height: 16),
            _buildTextField('Correo', user.email),
            const SizedBox(height: 16),
            _buildDropdownButton(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement clear conversation history logic
              },
              child: const Text('Borrar historial de conversación'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Implement update logic
          },
          child: const Text('Actualizar'),
        ),
      ],
    );
  }

  Widget _buildDropdownButton() {
    return Row(
      children: [
        const Text('Tema:'),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: settings.theme,
          onChanged: (String? newValue) {
            setState(() {
              settings.theme = newValue!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: 'light',
              child: Text('Claro'),
            ),
            DropdownMenuItem(
              value: 'dark',
              child: Text('Oscuro'),
            ),
          ],
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Implement update logic
          },
          child: const Text('Actualizar'),
        ),
      ],
    );
  }
}
