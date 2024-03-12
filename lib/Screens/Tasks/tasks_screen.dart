import 'package:flutter/material.dart';
import '../../Models/student_task.dart';
import '../../Models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Dummy data for demonstration purposes
  List<Task> tasks = [
    Task(id: 1, name: 'Task 1', content: 'Content for Task 1'),
    Task(id: 2, name: 'Task 2', content: 'Content for Task 2'),
    Task(id: 3, name: 'Task 3', content: 'Content for Task 3'),
  ];

  List<StudentTask> studentTasks = [
    StudentTask(id: 1, completed: false, studentId: 1, taskId: 1),
    StudentTask(id: 2, completed: true, studentId: 1, taskId: 2),
    StudentTask(id: 3, completed: false, studentId: 1, taskId: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final studentTask =
                    studentTasks.firstWhere((st) => st.taskId == task.id);
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text(task.content),
                  trailing: Checkbox(
                    value: studentTask.completed,
                    onChanged: (value) {
                      setState(() {
                        studentTask.completed = value!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
