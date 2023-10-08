import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:finance_tracker/model/expense_category.dart';
import 'package:finance_tracker/model/financial_record.dart';
import 'package:finance_tracker/repository/reposiitory_user.dart';
import 'package:finance_tracker/repository/repository_category.dart';
import 'package:finance_tracker/repository/repository_fin_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

class ImportExportExelScreen extends StatefulWidget {
  Database database;

  ImportExportExelScreen(this.database);

  @override
  _ImportExportExelScreenState createState() => _ImportExportExelScreenState();
}

class _ImportExportExelScreenState extends State<ImportExportExelScreen> {
  late UserRepository userRepository = UserRepository(widget.database);
  late ExpenseCategoryRepository exCatRepository =
      ExpenseCategoryRepository(widget.database);
  late FinancialRecordRepository finRecRepository =
      FinancialRecordRepository(widget.database);

  void exportToExcel() async {
    List<FinancialRecord> financialRecords = await finRecRepository.getAll();
    List<ExpenseCategory> exCatList = await exCatRepository.getAll();

    var excel = Excel.createExcel();
    var sheet = excel[excel.tables.keys.first];
    var sheet2 = excel[excel.tables.keys.last];

    // Add headers
    sheet.appendRow(['ID', 'UserID', 'Category', 'Amount', 'Note', 'Date']);

    // Add data rows
    for (var item in financialRecords) {
      sheet.appendRow([
        item.id,
        item.userId,
        item.category.name,
        item.amount,
        item.note,
        item.date.toString()
      ]);
    }
    // Add headers
    sheet2.appendRow(['ID', 'NAME']);

    for (var item in exCatList) {
      sheet.appendRow([
        item.id,
        item.name,
      ]);
    }
    // Получите байты данных Excel
    var excelBytes = await excel.encode();

    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy_MM_dd_HH_mm').format(now);
    final destination = await getTemporaryDirectory();
    final destinationFile =
        File(join(destination.path, '${formattedDateTime}_excel_file.xlsx'));

    // Сохраните файл
    await destinationFile.writeAsBytes(Uint8List.fromList(excelBytes!));

    Share.shareFiles([destinationFile.path], text: 'Поделиться файлом');
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
