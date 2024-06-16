import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import '../../Models/task_model.dart';
import '../../Services/tasks_service.dart';
import '../../Utils/load_theme.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Future<List<StudentTask>> _studentTasksFuture;
  final TasksService _tasksService = TasksService();

  @override
  void initState() {
    super.initState();
    _studentTasksFuture = _tasksService.getStudentTasks();
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
          return Theme(
            data: theme,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Tareas'),
              ),
              body: Column(
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Tus Tareas',
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
                          'Aquí podrás ver y completar las tareas que Calmy te sugiere realizar para mejorar tu estado de animo.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: const Divider(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: FutureBuilder<List<StudentTask>>(
                      future: _studentTasksFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final studentTasks = snapshot.data!;
                          // ...
                          return ListView.builder(
                            itemCount: studentTasks.length,
                            itemBuilder: (context, index) {
                              final studentTask = studentTasks[index];
                              final task = studentTask.task;
                              final isCompleted = studentTask.completed == 1;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? Colors.white
                                        : kPrimaryColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius value as needed
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      task.name,
                                      style: TextStyle(
                                        color: isCompleted
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task.content,
                                      style: TextStyle(
                                        color: isCompleted
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    trailing: Checkbox(
                                      value: isCompleted,
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                            width: 1.0, color: Colors.white),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          studentTask.completed =
                                              value! ? 1 : 0;
                                        });
                                        _tasksService.updateTaskCompletion(
                                            studentTask.id,
                                            studentTask.completed);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          // ...
                        } else {
                          return const Center(
                              child: Text('No tasks available'));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
