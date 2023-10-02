import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/popup_helper.dart';
import '../../model/expense_category.dart';
import '../../repository/repository.dart';
import '../../repository/repository_category.dart';
import 'add_category_screen.dart';

class ExpenseCategoryScreen extends StatefulWidget {
  Database database;

  ExpenseCategoryScreen(this.database);

  @override
  _ExpenseCategoryScreenState createState() => _ExpenseCategoryScreenState();
}

class _ExpenseCategoryScreenState extends State<ExpenseCategoryScreen> {
  late Repository<ExpenseCategory> repository =
      ExpenseCategoryRepository(widget.database);
  List<ExpenseCategory> category = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    List<ExpenseCategory> list = await repository.getAll();
    setState(() {
      category = list;
    });
  }

  Future<void> add(ExpenseCategory record) async {
    repository.add(record);
    _load();
  }

  Future<void> update(ExpenseCategory record) async {
    repository.update(record);
    _load();
  }

  void delete(ExpenseCategory record) {
    repository.delete(record.id);
    _load();
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
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: category.length,
        itemBuilder: (context, index) {
          final record = category[index];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(155, 183, 123, 70),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Image.asset(
                            //   'assets/icons/100/height-100.png',
                            //   width: 28.0,
                            //   height: 28.0,
                            // ),
                            // SizedBox(width: 8.0),
                            Text(
                              record.name,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              showConfirmationDialog(context, () {
                                delete(record);
                              });
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ))
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          _createRecord(context, AddCategoryScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
