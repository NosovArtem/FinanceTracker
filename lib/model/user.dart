import 'package:finance_tracker/model/obj.dart';

class User extends Obj {
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
    );
  }
}
