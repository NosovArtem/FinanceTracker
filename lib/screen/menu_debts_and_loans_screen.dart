import 'package:finance_tracker/repository/repository_debt_loan.dart';
import 'package:finance_tracker/screen/repayment_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/debt_loan.dart';
import 'add_debt_or_loan_screen.dart';

class DebtLoanListScreen extends StatefulWidget {
  final Database database;

  DebtLoanListScreen(this.database);

  @override
  _DebtLoanListScreenState createState() => _DebtLoanListScreenState();
}

class _DebtLoanListScreenState extends State<DebtLoanListScreen> {
  late Database database;
  late List<DebtLoan> _debtLoans = [];
  late DebtLoanRepository repository;

  @override
  void initState() {
    database = widget.database;
    repository = DebtLoanRepository(database);
    loadAll();
  }

  Future<void> loadAll() async {
    _debtLoans = await repository.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список долгов и займов'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Фильтр по названию',
              ),
              onChanged: (value) {
                setState(() {
                  _debtLoans = _filterDebtLoans(value);
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _debtLoans.length,
              itemBuilder: (context, index) {
                final debtLoan = _debtLoans[index];
                return ListTile(
                  title: Text(debtLoan.note),
                  subtitle: Text(
                    'Сумма: ${debtLoan.amount.toStringAsFixed(2)}'
                    '\nДата взятия: ${debtLoan.loanDate.toLocal().toString().split(' ')[0]}'
                    '\nОстаток: ${debtLoan.balance.toStringAsFixed(2)}'
                    '\nСтатус: ${debtLoan.status}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RepaymentHistoryScreen(debtLoan, database)),
                    );
                  },
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
            builder: (context) => CreateDebtLoanScreen({}),
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

  Future<void> add(DebtLoan record) async {
    repository.add(record);
    loadAll();
  }

  List<DebtLoan> _filterDebtLoans(String filter) {
    return _debtLoans
        .where((debtLoan) =>
            debtLoan.note.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }
}
