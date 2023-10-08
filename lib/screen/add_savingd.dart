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
              decoration: InputDecoration(labelText: 'Счет/Имя'),
            ),
            TextFormField(
              controller: goalNameController,
              decoration: InputDecoration(labelText: 'Цель'),
            ),
            TextFormField(
              controller: currencyController,
              decoration: InputDecoration(labelText: 'Валюта'),
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Сумма'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                Savings newSaving = Savings(
                  id: 1,
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
          ],
        ),
      ),
    );
  }
}
