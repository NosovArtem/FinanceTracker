import 'package:finance_tracker/model/icon.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/expense_category.dart';
import '../repository/repository.dart';
import '../repository/repository_category.dart';
import 'add_icon_to_category.dart';

class AddCategoryScreen extends StatefulWidget {
  Database database;

  AddCategoryScreen(this.database);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController categoryController = TextEditingController();
  late Repository<ExpenseCategory> repository =
      ExpenseCategoryRepository(widget.database);
  List<ExpenseCategory> category = [];
  Widget selectedIconData = Icon(Icons.add);
  late IconObj iconObj;
  List<Widget> allFontAwesomeIcons = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    List<ExpenseCategory> list = await repository.getAll();
    for (final item in list) {
      Widget selec = Image.memory(
        item.iconObj.icon,
        width: 30,
        height: 30,
      );
      allFontAwesomeIcons.add(selec);
    }
    setState(() {
      category = list;
    });
  }

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
  }

  void _addIcon(BuildContext context, StatefulWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((map) {
      if (map != null) {
        if (map["icon"] != null) {
          iconObj = map["icon"];
          selectedIconData = Image.memory(
            iconObj.icon,
            width: 20,
            height: 20,
          );
        }
        setState(() {});
      }
    });
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
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.label_important),
                  labelText: 'Категория'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: selectedIconData, labelText: 'Иконка'),
              onTap: () {
                _addIcon(context, IconSelectionScreen(widget.database));
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  ExpenseCategory newRecord = ExpenseCategory(
                      id: -1, name: categoryController.text, iconObj: iconObj);

                  Navigator.pop(context, {"old": null, "new": newRecord});
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
