import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:finance_tracker/model/debt_loan.dart';
import 'package:finance_tracker/model/expense_category.dart';
import 'package:finance_tracker/model/financial_record.dart';
import 'package:finance_tracker/model/repayment.dart';
import 'package:finance_tracker/model/savings.dart';
import 'package:finance_tracker/repository/reposiitory_user.dart';
import 'package:finance_tracker/repository/repository_category.dart';
import 'package:finance_tracker/repository/repository_fin_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';
import '../repository/repository_debt_loan.dart';
import '../repository/repository_repayment.dart';
import '../repository/repository_savings.dart';

class ImportExportExelScreen extends StatefulWidget {
  Database database;

  ImportExportExelScreen(this.database);

  @override
  _ImportExportExelScreenState createState() => _ImportExportExelScreenState();
}

class _ImportExportExelScreenState extends State<ImportExportExelScreen> {
  late FinancialRecordRepository recordRepository =
      FinancialRecordRepository(widget.database);
  late ExpenseCategoryRepository catRepository =
      ExpenseCategoryRepository(widget.database);
  late UserRepository userRepository = UserRepository(widget.database);
  late DebtLoanRepository debtLoanRepository =
      DebtLoanRepository(widget.database);
  late RepaymentRepository repaymentRepository =
      RepaymentRepository(widget.database);
  late SavingsRepository savingsRepository = SavingsRepository(widget.database);

  void exportToExcel() async {
    List<FinancialRecord> records = await recordRepository.getAll();
    List<ExpenseCategory> categories = await catRepository.getAll();
    List<User> users = await userRepository.getAll();
    List<DebtLoan> debts = await debtLoanRepository.getAll();
    List<Repayment> repayments = await repaymentRepository.getAll();
    List<Savings> savings = await savingsRepository.getAll();

    var excel = Excel.createExcel();

    // Добавляем страницы (листы)
    var expensesSheet = excel['Expenses'];
    var categoriesSheet = excel['Categories'];
    var contactsSheet = excel['Contacts'];
    var debtsSheet = excel['Debts'];
    var repaymentsSheet = excel['Repayments'];
    var savingsSheet = excel['Savings'];

    expensesSheet.appendRow([
      'ID',
      'UserID',
      'Category',
      'Amount',
      'Note',
      'Date',
      'Month',
    ]);
    for (var item in records) {
      expensesSheet.appendRow([
        item.id,
        item.userId,
        item.category.name,
        item.amount,
        item.note,
        item.date.toIso8601String(),
        DateFormat('YYYY-MM').format(item.date)
      ]);
    }

    categoriesSheet.appendRow([
      'ID',
      'NAME',
    ]);
    for (var item in categories) {
      categoriesSheet.appendRow([
        item.id,
        item.name,
      ]);
    }

    contactsSheet.appendRow([
      'ID',
      'FirstName',
      'LastName',
      'Email',
      'PhoneNumber',
    ]);
    for (var item in users) {
      contactsSheet.appendRow([
        item.id,
        item.firstName,
        item.lastName,
        item.email,
        item.phoneNumber,
      ]);
    }

    debtsSheet.appendRow([
      'ID',
      'UserId',
      'LoanDate',
      'Amount',
      'Balance',
      'RepaymentDate',
      'RepaymentAmount',
      'Note',
      'isDebt',
    ]);
    for (var item in debts) {
      debtsSheet.appendRow([
        item.id,
        item.userId,
        item.loanDate,
        item.amount,
        item.balance,
        item.repaymentDate,
        item.repaymentAmount,
        item.note,
        item.isDebt,
      ]);
    }

    repaymentsSheet.appendRow([
      'ID',
      'DebtLoanId',
      'RepaymentDate',
      'RepaymentAmount',
      'Note',
    ]);
    for (var item in repayments) {
      repaymentsSheet.appendRow([
        item.id,
        item.debtLoanId,
        item.repaymentDate,
        item.repaymentAmount,
        item.note,
      ]);
    }

    savingsSheet.appendRow([
      'ID',
      'AccountName',
      'GoalName',
      'Currency',
      'Amount',
      'Note',
    ]);
    for (var item in savings) {
      savingsSheet.appendRow([
        item.id,
        item.accountName,
        item.goalName,
        item.currency,
        item.amount,
        item.note,
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
