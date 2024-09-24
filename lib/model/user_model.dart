class UserModel {
  String name;
  String email;
  String phone;
  bool? friend;
  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.friend=false
  });
}
