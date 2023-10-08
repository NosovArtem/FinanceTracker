import 'obj.dart';

class DebtLoan extends Obj {
  int id;
  int borrowerId;
  int lenderId;
  DateTime loanDate;
  double amount;
  double balance;
  DateTime repaymentDate;
  double repaymentAmount;
  String note;
  String status;

  DebtLoan({
    required this.id,
    required this.borrowerId,
    required this.lenderId,
    required this.loanDate,
    required this.amount,
    required this.balance,
    required this.repaymentDate,
    required this.repaymentAmount,
    required this.note,
    required this.status,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'borrower_id': borrowerId,
      'lender_id': lenderId,
      'loan_date': loanDate.toIso8601String(),
      'amount': amount,
      'balance': balance,
      'repayment_date': repaymentDate.toIso8601String(),
      'repayment_amount': repaymentAmount,
      'note': note,
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'borrower_id': borrowerId,
      'lender_id': lenderId,
      'loan_date': loanDate.toIso8601String(),
      'amount': amount,
      'balance': balance,
      'repayment_date': repaymentDate.toIso8601String(),
      'repayment_amount': repaymentAmount,
      'note': note,
      'status': status,
    };
  }

  factory DebtLoan.fromMap(Map<String, dynamic> map) {
    return DebtLoan(
      id: map['id'],
      borrowerId: map['borrower_id'],
      lenderId: map['lender_id'],
      loanDate: DateTime.parse(map['loan_date']),
      amount: map['amount'],
      balance: map['balance'],
      repaymentDate: DateTime.parse(map['repayment_date']),
      repaymentAmount: map['repayment_amount'],
      note: map['note'],
      status: map['status'],
    );
  }
}
