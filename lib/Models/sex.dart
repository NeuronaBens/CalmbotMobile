class Sex {
  String id;
  String name;

  Sex({required this.id, required this.name});

  factory Sex.fromJson(Map<String, dynamic> json) {
    return Sex(
      id: json['id'],
      name: json['name'],
    );
  }
}
