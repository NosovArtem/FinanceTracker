import 'package:flutter/cupertino.dart';

import 'obj.dart';

class ExpenseCategory extends Obj {
  final int id;
  final String name;

  ExpenseCategory({required this.id, required this.name});

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ExpenseCategory.fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(
      id: map['id'],
      name: map['name'],
    );
  }

}
