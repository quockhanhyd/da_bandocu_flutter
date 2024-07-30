import 'dart:convert';

class User {
  final int userId;
  final String userName;
  final String password;
  final String fullName;
  final int roleId;
  final String roleName;

  User({
    required this.userId,
    required this.userName,
    required this.password,
    required this.fullName,
    required this.roleId,
    required this.roleName,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'password': password,
    'fullName': fullName,
    'roleId': roleId,
    'roleName': roleName,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['userId'],
    userName: json['userName'],
    password: json['password'],
    fullName: json['fullName'],
    roleId: json['roleId'],
    roleName: json['roleName'],
  );
}