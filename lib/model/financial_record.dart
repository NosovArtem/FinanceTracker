import 'package:finance_tracker/model/obj.dart';

class FinancialRecord extends Obj{
  int id;
  int userId;
  int categoryId;
  double amount;
  String note;
  DateTime date;

  FinancialRecord({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.note,
    required this.date,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'user_id': userId,
      'category_id': categoryId,
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
      'category_id': categoryId,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory FinancialRecord.fromMap(Map<String, dynamic> map) {
    return FinancialRecord(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      amount: map['amount'],
      note: map['note'],
      date: DateTime.parse(map['date']),
    );
  }

}