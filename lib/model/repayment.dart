import 'obj.dart';

class Repayment extends Obj {
  int id;
  int debtLoanId;
  DateTime repaymentDate;
  double repaymentAmount;
  String note;

  Repayment({
    required this.id,
    required this.debtLoanId,
    required this.repaymentDate,
    required this.repaymentAmount,
    required this.note,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'debt_loan_id': debtLoanId,
      'repayment_date': repaymentDate.toIso8601String(),
      'repayment_amount': repaymentAmount,
      'note': note,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'debt_loan_id': debtLoanId,
      'repayment_date': repaymentDate.toIso8601String(),
      'repayment_amount': repaymentAmount,
      'note': note,
    };
  }

  factory Repayment.fromMap(Map<String, dynamic> map) {
    return Repayment(
      id: map['id'],
      debtLoanId: map['debt_loan_id'],
      repaymentDate: DateTime.parse(map['repayment_date']),
      repaymentAmount: map['repayment_amount'],
      note: map['note'],
    );
  }
}
