class Task {
  String id;
  String name;
  String content;

  Task({required this.id, required this.name, required this.content});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      content: json['content'],
    );
  }
}

class StudentTask {
  String id;
  int completed;
  String studentId;
  String taskId;
  Task task;

  StudentTask({
    required this.id,
    required this.completed,
    required this.studentId,
    required this.taskId,
    required this.task,
  });

  factory StudentTask.fromJson(Map<String, dynamic> json) {
    return StudentTask(
      id: json['id'],
      completed: json['completed'],
      studentId: json['student_id'],
      taskId: json['task_id'],
      task: Task.fromJson(json['task']),
    );
  }
}