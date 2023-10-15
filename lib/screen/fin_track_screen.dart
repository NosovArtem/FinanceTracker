import 'package:finance_tracker/repository/repository_category.dart';
import 'package:finance_tracker/screen/add_fin_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

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
  Map<String, List<FinancialRecord>> map = {};
  List<String> groupedRecords = [];
  List<ExpenseCategory> listCategory = [];
  double totalSpent = 0.0;
  Map<String, double> dailySpent = {};
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    List<FinancialRecord> records = await repository.getAllByMonth(currentDate);
    listCategory = await repositoryCategory.getAll();
    totalSpent = calcMonthSpent(records);
    map = groupItemsByDate(records);
    groupedRecords = getGroupKeys(map);
    dailySpent = calcDaySpent(records);
    setState(() {});
  }

  List<String> getGroupKeys(Map<String, List<FinancialRecord>> map) {
    final List<String> grouped = [];

    for (final item in map.keys) {
      grouped.add(item);
    }
    return grouped;
  }

  Map<String, double> calcDaySpent(List<FinancialRecord> expenses) {
    Map<String, double> dailyExpenses = {};

    for (var item in expenses) {
      String formattedDate = getDateKey(item.date);
      if (dailyExpenses.containsKey(formattedDate)) {
        double d = dailyExpenses[formattedDate] ?? 0.0;
        dailyExpenses[formattedDate] = d + item.amount;
      } else {
        dailyExpenses[formattedDate] = item.amount;
      }
    }
    return dailyExpenses;
  }

  String getDateKey(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }

  Map<String, List<FinancialRecord>> groupItemsByDate(
      List<FinancialRecord> items) {
    final Map<String, List<FinancialRecord>> grouped = {};

    for (final item in items) {
      String formattedDate = getDateKey(item.date);
      if (grouped.containsKey(formattedDate)) {
        List<FinancialRecord>? list = grouped[formattedDate];
        list?.add(item);
      } else {
        List<FinancialRecord> l = [item];
        grouped[formattedDate] = l;
      }
    }
    return grouped;
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
          showPopupWithButtons(context, 'Выберите категорию');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getCardList() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: groupedRecords.length,
      itemBuilder: (context, index) {
        final dateKey = groupedRecords[index];
        return Card(
          child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(155, 183, 123, 70),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      dateKey,
                      style: TextStyle(fontSize: 15),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dailySpent[dateKey].toString(),
                          style: TextStyle(
                              fontSize: 25, color: Colors.yellowAccent),
                        ),
                      ],
                    ))
                  ],
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: map[dateKey]!.length,
                  itemBuilder: (BuildContext context, int innerIndex) {
                    return getInnerRow(dateKey, map[dateKey]![innerIndex]);
                  },
                ),
              ])),
        );
      },
    );
  }

  Widget getInnerRow(String dateKey, FinancialRecord record) {
    return Row(
      children: [
        Image.memory(
          record.category.iconObj.icon,
          width: 30,
          height: 30,
        ),
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
                        widget.database,
                        getFR(record),
                        listCategory,
                      ));
                },
                icon: Icon(Icons.edit)),
          ],
        ))
      ],
    );
  }

  Future<void> showPopupWithButtons(BuildContext context, String title) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
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
                              widget.database,
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
        if (map["new"] != null) {
          update(map["new"]);
        } else {
          delete(map["delete"]);
        }
        setState(() {});
      }
    });
  }
}
