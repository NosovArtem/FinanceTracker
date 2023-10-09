import 'package:finance_tracker/model/savings.dart';
import 'package:finance_tracker/repository/repository_savings.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'add_savingd.dart';

class SavingsListScreen extends StatefulWidget {
  final Database database;

  SavingsListScreen(this.database);

  @override
  _SavingsListScreenState createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends State<SavingsListScreen> {
  late Database database;
  late List<Savings> savings = [];
  late SavingsRepository repository;

  @override
  void initState() {
    database = widget.database;
    repository = SavingsRepository(database);
    loadAll();
  }

  Future<void> loadAll() async {
    savings = await repository.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список накоплений'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Фильтр по названию',
              ),
              onChanged: (value) {
                setState(() {
                  savings = _filterSavingss(value);
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savings.length,
              itemBuilder: (context, index) {
                final saving = savings[index];
                return ListTile(
                  title: Text(saving.accountName),
                  subtitle: Text(
                    'Цель: ${saving.goalName}'
                    '\nВалюта: ${saving.currency}'
                    '\nNote: ${saving.note}'
                    '\nСумма: ${saving.amount}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => AddSavingsScreen(),
          ))
              .then((map) {
            if (map != null) {
              add(map["new"]);
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> add(Savings record) async {
    repository.add(record);
    loadAll();
  }

  List<Savings> _filterSavingss(String filter) {
    return savings
        .where((saving) =>
            saving.accountName.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }
}
