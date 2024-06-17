import 'package:finance_tracker/repository/repository_repayment.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/debt_loan.dart';
import '../model/repayment.dart';
import 'add_repayment_sceen.dart';

class RepaymentHistoryScreen extends StatefulWidget {
  final DebtLoan initialData;
  final Database database;

  RepaymentHistoryScreen(this.initialData, this.database);

  @override
  _RepaymentHistoryScreenState createState() => _RepaymentHistoryScreenState();
}

class _RepaymentHistoryScreenState extends State<RepaymentHistoryScreen> {
  late DebtLoan _debtLoan;
  late List<Repayment> _repayments = [];
  late RepaymentRepository repaymentRepository;
  late double total = 0;

  @override
  void initState() {
    repaymentRepository = RepaymentRepository(widget.database);
    loadAll();
  }

  Future<void> loadAll() async {
    _debtLoan = widget.initialData;
    _repayments = await repaymentRepository.getAllByDebtLoanId(_debtLoan.id);
    for (var repayment in _repayments) {
      total += repayment.repaymentAmount;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('История погашений'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Описание: ${_debtLoan.note}'
              '\nСумма: ${_debtLoan.amount.toStringAsFixed(2)}'
              '\nДата взятия: ${_debtLoan.loanDate.toLocal().toString().split(' ')[0]}'
              '\nОстаток: ${(_debtLoan.amount - total).toStringAsFixed(2)}'
              '\nДата возврата: ${_debtLoan.repaymentDate.toLocal().toString().split(' ')[0]}'
              '\nСумма возврата: ${_debtLoan.repaymentAmount.toStringAsFixed(2)}'
              '\nСтатус: ${_debtLoan.amount - _debtLoan.balance == 0 ? "Closed" : "Open"}',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _repayments.length,
              itemBuilder: (context, index) {
                final repayment = _repayments[index];
                return ListTile(
                  subtitle: Text(
                    'Сумма: ${repayment.repaymentAmount.toStringAsFixed(2)}'
                    '\nNote: ${repayment.note}'
                    '\nДата платежа: ${repayment.repaymentDate.toLocal().toString().split(' ')[0]}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          _createRecord(
              context,
              AddRepaymentScreen(
                  {'debtLoanId': _debtLoan.id}
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _createRecord(BuildContext context, StatefulWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((map) {
      if (map != null) {
        add(map["new"]);
      }
    });
  }

  Future<void> add(Repayment record) async {
    repaymentRepository.add(record);
    loadAll();
  }
}
