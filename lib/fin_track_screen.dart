import 'package:finance_tracker/screen/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'helper/db_helper.dart';
import 'helper/popup_helper.dart';
import 'model/transaction.dart';

class FinTrackScreen extends StatefulWidget {
  final BuildContext context;

  FinTrackScreen(this.context);

  @override
  FinTrackScreenState createState() => FinTrackScreenState();
}

class FinTrackScreenState extends State<FinTrackScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<MainRecord> records = [];
  List<MainRecord> filteredData = [];
  late String filterData;

  @override
  void initState() {
    super.initState();
    String? argument =
        ModalRoute.of(widget.context)!.settings.arguments as String?;
    filterData = argument ?? 'all';
    _loadrecords();
  }

  Future<void> _loadrecords() async {
    var records = await dbHelper.getAllRecords();
    setState(() {
      records = filter(records, filterData);
      records.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  filter(List<MainRecord> data, String filterData) {
    return data.where((item) => item.contains(filterData)).toList();
  }

  Future<void> addTransaction(MainRecord record) async {
    await dbHelper.insert(record);
    _loadrecords();
  }

  Future<void> updateTransaction(MainRecord record) async {
    await dbHelper.update(record);
    _loadrecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(), // Включаем прокрутку всегда
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
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

                record.getCardWidget(),

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
                        // IconButton(
                        //     onPressed: () {
                        //       updateRecord(
                        //           context, record.getEditScreenWidget());
                        //     },
                        //     icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              showConfirmationDialog(context, () {
                                _deleteRecord(record, index);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteRecord(MainRecord record, int index) {
    setState(() {
      dbHelper.remove(record.id);
      records.removeAt(index);
    });
  }

  void createRecord(BuildContext context, StatefulWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((map) {
      if (map != null) {
        records.add(map["new"]);
        addTransaction(map["new"]);
        setState(() {});
      }
    });
  }

  void updateRecord(BuildContext context, StatefulWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((map) {
      if (map != null) {
        records.remove(map["old"]);
        records.add(map["new"]);
        updateTransaction(map["new"]);
        setState(() {});
      }
    });
  }
}
