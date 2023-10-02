import 'package:finance_tracker/repository/repository_category.dart';
import 'package:finance_tracker/screen/add_fin_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/popup_helper.dart';
import '../model/expense_category.dart';
import '../model/financial_record.dart';
import '../repository/repository_fin_record.dart';
import '../utils/data_utils.dart';

class FinTrackScreen extends StatefulWidget {
  final BuildContext context;
  final Database database;

  FinTrackScreen(this.context, this.database);

  @override
  FinTrackScreenState createState() => FinTrackScreenState();
}

class FinTrackScreenState extends State<FinTrackScreen> {
  late FinancialRecordRepository repository =
      FinancialRecordRepository(widget.database);
  late ExpenseCategoryRepository repositoryCategory =
      ExpenseCategoryRepository(widget.database);
  List<FinancialRecord> mainRecords = [];
  List<ExpenseCategory> listCategory = [];
  Map<int, String> mapIdToCategory = {};

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    mainRecords = await repository.getAll();
    listCategory = await repositoryCategory.getAll();
    mapIdToCategory = await convertToIdToName(listCategory);
    setState(() {});
  }

  Future<void> add(FinancialRecord record) async {
    repository.add(record);
    loadAll();
  }

  Future<void> update(FinancialRecord record) async {
    repository.update(record);
    loadAll();
  }

  Future<void> delete(int id) async {
    repository.delete(id);
    loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: mainRecords.length,
        itemBuilder: (context, index) {
          final record = mainRecords[index];
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
                SizedBox(height: 5),
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
                          'Категория: ${mapIdToCategory[record.id]}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Image.asset(
                        //   'assets/icons/100/height-100.png',
                        //   width: 28.0,
                        //   height: 28.0,
                        // ),
                        // SizedBox(width: 8.0),
                        Text(
                          'Сумма: ${record.amount}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 35.0),
                    Text(
                      record.note.isEmpty ? "" : 'Заметка: ${record.note}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${DateFormat('yyyy-MM-dd HH:mm').format(record.date)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              _updateRecord(
                                  context,
                                  AddTransactionScreen(
                                    initialData: record,
                                    categoryList: listCategory,
                                  ));
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              showConfirmationDialog(context, () {
                                delete(record.id);
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
          showPopupWithButtons(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showPopupWithButtons(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Выберите категорию'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listCategory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _createRecord(
                            context,
                            AddTransactionScreen(
                              categoryList: listCategory,
                              selected: listCategory[index].name,
                            ));
                      },
                      child: Text(listCategory[index].name),
                    );
                  }),
            ));
      },
    );
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

  void _updateRecord(BuildContext context, StatefulWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((map) {
      if (map != null) {
        update(map["new"]);
        setState(() {});
      }
    });
  }

}
