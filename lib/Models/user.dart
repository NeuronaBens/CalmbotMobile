class User {
  String id;
  String name;
  String email;
  String password;
  String image;
  DateTime deletedAt;
  String roleId;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.image,
      required this.deletedAt,
      required this.roleId});
}
