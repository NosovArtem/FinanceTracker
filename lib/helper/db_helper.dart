import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = "FinTracker22.db";
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE 'user' (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    password TEXT NOT NULL
    );
   ''');

    await db.execute('''
    CREATE TABLE 'financial_record' (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    note TEXT,
    date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (category_id) REFERENCES categories (id)
    );
    ''');

    await db.execute('''
    CREATE TABLE 'category' (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
    );
    ''');

    await db
        .execute('''INSERT INTO 'category' VALUES(1, 'groceries');''');
    await db.execute('''INSERT INTO 'category' VALUES(2, 'bill');''');
    await db.execute('''INSERT INTO 'category' VALUES(3, 'archi');''');
    await db.execute('''INSERT INTO 'category' VALUES(4, 'doctor');''');
    await db
        .execute('''INSERT INTO 'category' VALUES(5, 'ready food');''');
    await db.execute('''INSERT INTO 'category' VALUES(6, 'other');''');

    await db.execute('''
    CREATE TABLE debts_loans (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    borrower_id INTEGER NOT NULL, 
    lender_id INTEGER NOT NULL,
    loan_date DATE NOT NULL,
    amount REAL NOT NULL,
    balance REAL NOT NULL,
    repayment_date DATE,
    repayment_amount REAL,
    note TEXT,
    status TEXT,
    FOREIGN KEY (borrower_id) REFERENCES borrowers(id),
    FOREIGN KEY (lender_id) REFERENCES lenders(id)
    );
    ''');

    await db.execute('''
    CREATE TABLE repayments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    debt_loan_id INTEGER NOT NULL, 
    repayment_date DATE NOT NULL, 
    repayment_amount REAL NOT NULL, 
    note TEXT, 
    FOREIGN KEY (debt_loan_id) REFERENCES debts_loans(id)
    );
    ''');

    await db.execute('''
    CREATE TABLE borrowers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL, 
    last_name TEXT NOT NULL, 
    email TEXT, 
    phone_number TEXT 
    );
    ''');

    await db.execute('''
    CREATE TABLE lenders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name TEXT NOT NULL, 
    contact_person TEXT, 
    email TEXT, 
    phone_number TEXT 
    );
    ''');

    await db.execute('''
    CREATE TABLE savings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_name TEXT NOT NULL,
    goal_name TEXT NOT NULL,
    currency TEXT NOT NULL,
    amount REAL NOT NULL,
    note TEXT 
    );
    ''');
  }

// --------------------------------------------------------

  Future<void> backup() async {
    Fluttertoast.showToast(msg: 'Экспорт базы данных начат...');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String sourcePath = join(appDocDir.path,
        join(await getDatabasesPath(), DatabaseHelper.databaseName));

    try {
      await _database?.close();

      final sourceFile = File(sourcePath);

      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('yyyy_MM_dd_HH_mm').format(now);
      final destination = await getTemporaryDirectory();
      final destinationFile = File(
          join(destination.path, '${formattedDateTime}_backup_database.db'));

      await sourceFile.copy(destinationFile.path);

      Share.shareFiles([destinationFile.path], text: 'Поделиться файлом');
      await _initDatabase();
      print(
          'Резервная копия базы данных успешно сохранена в: ${destinationFile.path}');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Ошибка при создании резервной копии базы данных: $e',
          backgroundColor: Colors.red);
      print('Ошибка при создании резервной копии базы данных: $e');
    }
  }

  Future<void> restore(String dumpFilePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath =
        join(appDocDir.path, join(await getDatabasesPath(), databaseName));

    final backupFile = File(dumpFilePath);
    await backupFile.copy(databasePath);

    final newDatabaseFile = File(databasePath);
    if (await newDatabaseFile.exists()) {
      Fluttertoast.showToast(
          msg: 'База данных успешно восстановлена из бэкапа.');
    } else {
      Fluttertoast.showToast(
          msg: 'Ошибка восстановления базы данных из бэкапа.',
          backgroundColor: Colors.red);
    }
  }
}
