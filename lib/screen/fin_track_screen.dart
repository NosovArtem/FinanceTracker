import 'package:finance_tracker/repository/repository_category.dart';
import 'package:finance_tracker/screen/add_fin_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/popup_helper.dart';
import '../model/expense_category.dart';
import '../model/financial_record.dart';
import '../repository/repository_fin_record.dart';

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
  double totalSpent = 0.0;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    mainRecords = await repository.getAllByMonth(currentDate);
    listCategory = await repositoryCategory.getAll();
    totalSpent = calcMonthSpent(mainRecords);
    setState(() {});
  }

  double calcMonthSpent(List<FinancialRecord> list) {
    double totalSpent = 0.0;
    for (var value in list) {
      totalSpent = totalSpent + value.amount;
    }
    return totalSpent;
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

  void _previousMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    });
    loadAll();
  }

  void _nextMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    });
    loadAll();
  }

  Future<void> _refresh() async {
    // currentDate = DateTime.now();
    setState(() {
      loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMM().format(currentDate);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_left,
                  size: 50,
                ),
                onPressed: _previousMonth,
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: _refresh,
                    child: Text(
                      formattedDate,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  size: 50,
                ),
                onPressed: _nextMonth,
              ),
            ],
          ),
          Text('Сумма потраченных средств за месяц'),
          Text(
            '\РСД $totalSpent',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: getCardList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showPopupWithButtons(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getCardList() {
    return ListView.builder(
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
              Text(
                '${DateFormat('EEEE, d MMMM').format(record.date)}',
                style: TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 15.0),
                  Column(
                    children: [
                      Text(
                        record.category.name,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        record.note,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        record.amount.toString(),
                        style: TextStyle(fontSize: 25),
                      ),
                      IconButton(
                          onPressed: () {
                            _updateRecord(
                                context,
                                AddTransactionScreen(
                                  getFR(record),
                                  listCategory,
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
                              {
                                'cat_id': listCategory[index].id,
                                'cat_name': listCategory[index].name,
                              },
                              listCategory,
                            ));
                      },
                      child: Text(listCategory[index].name),
                    );
                  }),
            ));
      },
    );
  }

  Map<String, dynamic> getFR(FinancialRecord record) {
    return {
      'id': record.id,
      'userId': record.userId,
      'cat_id': record.category.id,
      'cat_name': record.category.name,
      'amount': record.amount,
      'note': record.note,
      'date': record.date,
    };
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
