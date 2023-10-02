import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:finance_tracker/model/expense_category.dart';
import 'package:finance_tracker/model/financial_record.dart';
import 'package:finance_tracker/repository/reposiitory_user.dart';
import 'package:finance_tracker/repository/repository_category.dart';
import 'package:finance_tracker/repository/repository_fin_record.dart';
import 'package:finance_tracker/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

import '../model/exel_data.dart';

class ImportExportExelScreen extends StatefulWidget {
  Database database;

  ImportExportExelScreen(this.database);

  @override
  _ImportExportExelScreenState createState() => _ImportExportExelScreenState();
}

class _ImportExportExelScreenState extends State<ImportExportExelScreen> {
  late UserRepository userRepository = UserRepository(widget.database);
  late ExpenseCategoryRepository exCatRepository = ExpenseCategoryRepository(
      widget.database);
  late FinancialRecordRepository finRecRepository = FinancialRecordRepository(
      widget.database);

  void exportToExcel() async {
    List<ExelData> data = [];
    List<FinancialRecord> financialRecords = await finRecRepository.getAll();
    List<ExpenseCategory> expenseCategories = await exCatRepository.getAll();
    Map<int, String> map = await convertToIdToName(expenseCategories);

    for (var value in financialRecords) {
      String cat = map[value.categoryId] ?? "";
      data.add(ExelData(id: value.id,
          userId: value.userId,
          category: cat,
          amount: value.amount,
          note: value.note,
          date: value.date));
    }

    var excel = Excel.createExcel();
    var sheet = excel[excel.tables.keys.first];

    // Add headers
    sheet.appendRow(['ID', 'UserID', 'CategoryID', 'Amount', 'Note', 'Date']);

    // Add data rows
    for (var item in data) {
      sheet.appendRow([
        item.id,
        item.userId,
        item.category,
        item.amount,
        item.note,
        item.date.toString()
      ]);
    }
    // Получите байты данных Excel
    var excelBytes = await excel.encode();

    // Сохраните файл
    var file = File('path_to_save_excel_file.xlsx');
    await file.writeAsBytes(Uint8List.fromList(excelBytes!));

    Share.shareFiles([file.path], text: 'Поделиться файлом');

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export/Import'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: exportToExcel,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.import_export),
                            Text(
                              'Export',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
