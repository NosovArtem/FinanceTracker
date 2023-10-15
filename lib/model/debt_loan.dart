import 'obj.dart';

class DebtLoan extends Obj {
  int id;
  int userId;
  DateTime loanDate;
  double amount;
  double balance;
  DateTime repaymentDate;
  double repaymentAmount;
  String note;
  int isDebt;

  DebtLoan({
    required this.id,
    required this.userId,
    required this.loanDate,
    required this.amount,
    required this.balance,
    required this.repaymentDate,
    required this.repaymentAmount,
    required this.note,
    required this.isDebt,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'user_id': userId,
      'loan_date': loanDate.toIso8601String(),
      'amount': amount,
      'balance': balance,
      'repayment_date': repaymentDate.toIso8601String(),
      'repayment_amount': repaymentAmount,
      'note': note,
      'is_debt': isDebt,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'user_id': userId,
      'loan_date': loanDate.toIso8601String(),
      'amount': amount,
      'balance': balance,
      'repayment_date': repaymentDate.toIso8601String(),
      'repayment_amount': repaymentAmount,
      'note': note,
      'is_debt': isDebt,
    };
  }

  factory DebtLoan.fromMap(Map<String, dynamic> map) {
    return DebtLoan(
      id: map['id'],
      userId: map['user_id'],
      loanDate: DateTime.parse(map['loan_date']),
      amount: map['amount'],
      balance: map['balance'],
      repaymentDate: DateTime.parse(map['repayment_date']),
      repaymentAmount: map['repayment_amount'],
      note: map['note'],
      isDebt: map['is_debt'],
    );
  }
}
