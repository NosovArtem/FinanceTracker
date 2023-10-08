import 'package:finance_tracker/model/obj.dart';

class Lender extends Obj {
  int id;
  String companyName;
  String contactPerson;
  String email;
  String phoneNumber;

  Lender({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'company_name': companyName,
      'contact_person': contactPerson,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'company_name': companyName,
      'contact_person': contactPerson,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  factory Lender.fromMap(Map<String, dynamic> map) {
    return Lender(
      id: map['id'],
      companyName: map['company_name'],
      contactPerson: map['contact_person'],
      email: map['email'],
      phoneNumber: map['phone_number'],
    );
  }
}
