import 'package:finance_tracker/model/icon.dart';
import 'package:finance_tracker/model/obj.dart';

import 'expense_category.dart';

class FinancialRecord extends Obj {
  int id;
  int userId;
  ExpenseCategory category;
  double amount;
  String note;
  DateTime date;

  FinancialRecord({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.note,
    required this.date,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'user_id': userId,
      'category_id': category.id,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': category.id,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory FinancialRecord.fromMap(Map<String, dynamic> map) {
    return FinancialRecord(
      id: map['id'],
      userId: map['user_id'],
      category: ExpenseCategory(
          id: map['cat_id'],
          name: map['cat_name'],
          iconObj: IconObj(id: map['i_id'], icon: map['i_icon'])),
      amount: map['amount'],
      note: map['note'],
      date: DateTime.parse(map['date']),
    );
  }
}
