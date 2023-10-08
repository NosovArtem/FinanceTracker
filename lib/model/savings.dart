import 'obj.dart';

class Savings extends Obj {
  int id;
  String accountName;
  String goalName;
  String currency;
  double amount;
  String note;

  Savings({
    required this.id,
    required this.accountName,
    required this.goalName,
    required this.currency,
    required this.amount,
    required this.note,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'account_name': accountName,
      'goal_name': goalName,
      'currency': currency,
      'amount': amount,
      'note': note,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'account_name': accountName,
      'goal_name': goalName,
      'currency': currency,
      'amount': amount,
      'note': note,
    };
  }

  factory Savings.fromMap(Map<String, dynamic> map) {
    return Savings(
      id: map['id'],
      accountName: map['account_name'],
      goalName: map['goal_name'],
      currency: map['currency'],
      amount: map['amount'],
      note: map['note'],
    );
  }
}
