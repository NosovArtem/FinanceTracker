import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';

import '../helper/db_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final dbHelper = DatabaseHelper.instance;

  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить запись'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Категория'),
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Сумма'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String category = categoryController.text;
                double amount = double.parse(amountController.text);
                var noteController;
                String note = noteController.text;

                MainRecord mr = MainRecord(
                    id: -1,
                    categoryId: 1,
                    amount: amount,
                    note: note,
                    date: DateTime.now());

                await dbHelper.insert(mr);

                Navigator.pop(context);
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
