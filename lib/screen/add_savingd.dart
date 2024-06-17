import 'package:finance_tracker/model/savings.dart';
import 'package:flutter/material.dart';

class AddSavingsScreen extends StatefulWidget {
  @override
  _AddSavingsScreenState createState() => _AddSavingsScreenState();
}

class _AddSavingsScreenState extends State<AddSavingsScreen> {
  TextEditingController accountNameController = TextEditingController();
  TextEditingController goalNameController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    accountNameController.dispose();
    goalNameController.dispose();
    currencyController.dispose();
    amountController.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить накопления'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: accountNameController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance),
                  labelText: 'Счет/Имя'),
            ),
            TextFormField(
              controller: goalNameController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.golf_course), labelText: 'Цель'),
            ),
            TextFormField(
              controller: currencyController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.currency_exchange),
                  labelText: 'Валюта'),
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money), labelText: 'Сумма'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.format_line_spacing_sharp),
                  labelText: 'Note'),
            ),
            Center(
              heightFactor: 2,
              child: ElevatedButton(
                onPressed: () async {
                  Savings newSaving = Savings(
                    id: -1,
                    accountName: accountNameController.text,
                    goalName: goalNameController.text,
                    currency: currencyController.text,
                    amount: double.parse(amountController.text),
                    note: noteController.text,
                  );
                  Navigator.pop(context, {"old": null, "new": newSaving});
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                child: Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
