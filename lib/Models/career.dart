class Career {
  String id;
  String name;
  String description;

  Career({required this.id, required this.name, required this.description});

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
