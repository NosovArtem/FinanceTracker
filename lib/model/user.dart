import 'package:finance_tracker/model/obj.dart';

class User extends Obj {
  int id;
  String username;
  String password;

  User({
    required this.id,
    required this.username,
    required this.password,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
