import 'package:finance_tracker/screen/users.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/helper.dart';
import '../model/debt_loan.dart';
import '../model/user.dart';
import '../widget/date.dart';

class CreateDebtLoanScreen extends StatefulWidget {
  final Database database;
  final Map<String, dynamic> initialData;
  final int isDebt;

  CreateDebtLoanScreen(
      {required this.database,
      required this.initialData,
      required this.isDebt});

  @override
  _CreateDebtLoanScreenState createState() => _CreateDebtLoanScreenState();
}

class _CreateDebtLoanScreenState extends State<CreateDebtLoanScreen> {
  TextEditingController _noteController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _repaymentAmountController = TextEditingController();
  TextEditingController _loanDateController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  late DateTimePickerWidget dateOfGet;
  final TextEditingController getDateController = TextEditingController();
  final TextEditingController getTimeController = TextEditingController();
  late DateTimePickerWidget dateOfTake;
  final TextEditingController takeDateController = TextEditingController();
  final TextEditingController takeTimeController = TextEditingController();

  User? user;

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    _loanDateController.dispose();
    _balanceController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DateTime dateTime = widget.initialData['date'] ?? DateTime.now();
    dateOfGet = DateTimePickerWidget(
      initialDate: dateTime,
      controllerDate: getDateController,
      controllerTime: getTimeController,
    );
    DateTime dateTime1 = widget.initialData['date'] ?? DateTime.now();
    dateOfTake = DateTimePickerWidget(
      initialDate: dateTime1,
      controllerDate: takeDateController,
      controllerTime: takeTimeController,
    );
  }

  void _addBorrowerAndLender(BuildContext context, StatefulWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((map) {
      if (map != null) {
        if (map["user"] != null) {
          user = map["user"];
        }
        setState(() {});
      }
    });
  }

  Widget getBorrowOrLender(Database database, String title, User? user) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(user == null ? title : "${user.lastName} ${user.firstName}"),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        _addBorrowerAndLender(context, UsersScreen(database, title));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String str = widget.isDebt == 1 ? "Borrowers" : "Lenders";
    return Scaffold(
        appBar: AppBar(
          title: Text('Добавление нового долга или займа'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.attach_money),
                            labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                      ),
                      getBorrowOrLender(widget.database, str, user),
                      dateOfGet,
                      TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.note_add),
                            labelText: 'Note'),
                      ),
                      SizedBox(height: 70.0),
                      Text('Дата возврата'),
                      dateOfTake,
                      Center(
                        heightFactor: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            DateTime d = DateTime.parse(getDateController.text);
                            TimeOfDay t =
                                parseTimeOfDay(getTimeController.text);
                            DateTime d1 =
                                DateTime.parse(takeDateController.text);
                            TimeOfDay t1 =
                                parseTimeOfDay(takeTimeController.text);
                            final newDebtLoan = DebtLoan(
                              id: -1,
                              userId: user!.id,
                              loanDate: DateTime(
                                  d.year, d.month, d.day, t.hour, t.minute),
                              amount: double.parse(_amountController.text),
                              balance: double.parse(_balanceController.text),
                              repaymentDate: DateTime(d1.year, d1.month, d1.day,
                                  t1.hour, t1.minute),
                              repaymentAmount:
                                  double.parse(_repaymentAmountController.text),
                              note: _noteController.text,
                              isDebt: widget.isDebt,
                            );
                            Navigator.pop(
                                context, {"old": null, "new": newDebtLoan});
                          },
                          child: Text('Добавить'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
