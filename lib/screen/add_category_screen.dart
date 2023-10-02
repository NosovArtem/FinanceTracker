import 'package:flutter/material.dart';

import '../model/expense_category.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить категорию'),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                ExpenseCategory newRecord =
                    ExpenseCategory(id: -1, name: categoryController.text);
                Navigator.pop(context, {"old": null, "new": newRecord});
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
