import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import '../../Models/task_model.dart';
import '../../Services/tasks_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<StudentTask>>(
              future: _studentTasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final studentTasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: studentTasks.length,
                    itemBuilder: (context, index) {
                      final studentTask = studentTasks[index];
                      final task = studentTask.task;
                      final isCompleted = studentTask.completed == 1;
                      return Container(
                        color: isCompleted ? null : kPrimaryColor.withOpacity(0.5),
                        child: ListTile(
                          title: Text(task.name),
                          subtitle: Text(task.content),
                          trailing: Checkbox(
                            value: isCompleted,
                            onChanged: (value) {
                              setState(() {
                                studentTask.completed = value! ? 1 : 0;
                              });
                              _tasksService.updateTaskCompletion(studentTask.id, studentTask.completed);
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No tasks available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
