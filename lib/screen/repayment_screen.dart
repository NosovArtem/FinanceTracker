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
  late RepaymentRepository repository;

  @override
  void initState() {
    repository = RepaymentRepository(widget.database);
    loadAll();
  }

  Future<void> loadAll() async {
    _debtLoan = widget.initialData;
    _repayments = await repository.getAllByDebtLoanId(_debtLoan.id);
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
              '\nОстаток: ${_debtLoan.balance.toStringAsFixed(2)}'
              '\nrepaymentDate: ${_debtLoan.repaymentDate.toLocal().toString().split(' ')[0]}'
              '\nrepaymentAmount: ${_debtLoan.repaymentAmount.toStringAsFixed(2)}'
              '\nСтатус: ${_debtLoan.status}',
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
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => AddRepaymentScreen({}),
          ))
              .then((map) {
            if (map != null) {
              add(map["new"]);
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> add(Repayment record) async {
    repository.add(record);
    loadAll();
  }
}
