import 'package:flutter/material.dart';

import '../helper/helper.dart';
import '../model/debt_loan.dart';
import '../widget/date.dart';

class CreateDebtLoanScreen extends StatefulWidget {
  final Map<String, dynamic> initialData;

  CreateDebtLoanScreen(this.initialData);

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

  @override
  Widget build(BuildContext context) {
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
                        controller: _noteController,
                        decoration: InputDecoration(labelText: 'Заметка'),
                      ),
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(labelText: 'Сумма'),
                        keyboardType: TextInputType.number,
                      ),

                      Text('Дата взятия'),
                      dateOfGet,

                      // dateOfTake,
                      TextField(
                        controller: _balanceController,
                        decoration: InputDecoration(labelText: 'Остаток'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: _statusController,
                        decoration: InputDecoration(labelText: 'Статус'),
                      ),
                      TextField(
                        controller: _repaymentAmountController,
                        decoration:
                            InputDecoration(labelText: 'Cумма возврата'),
                      ),

                      Text('Дата возврата'),
                      dateOfTake,

                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime d = DateTime.parse(getDateController.text);
                          TimeOfDay t = parseTimeOfDay(getTimeController.text);
                          DateTime d1 = DateTime.parse(takeDateController.text);
                          TimeOfDay t1 =
                              parseTimeOfDay(takeTimeController.text);
                          final newDebtLoan = DebtLoan(
                            id: 1,
                            borrowerId: 1,
                            lenderId: 1,
                            loanDate: DateTime(
                                d.year, d.month, d.day, t.hour, t.minute),
                            amount: double.parse(_amountController.text),
                            balance: double.parse(_balanceController.text),
                            repaymentDate: DateTime(
                                d1.year, d1.month, d1.day, t1.hour, t1.minute),
                            repaymentAmount:
                                double.parse(_repaymentAmountController.text),
                            note: _noteController.text,
                            status: _statusController.text,
                          );
                          Navigator.pop(
                              context, {"old": null, "new": newDebtLoan});
                        },
                        child: Text('Добавить'),
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
