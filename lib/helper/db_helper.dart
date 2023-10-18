import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = "FinTracker.db";
  static const _databaseVersion = 4;

  static const _icons = "icons";
  static const _cat = "categories";

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
    CREATE TABLE '$_cat' (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    icon_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (icon_id) REFERENCES icons (id)
    );
    ''');

    await db.execute('''
    CREATE TABLE '$_icons' (
    id INTEGER PRIMARY KEY AUTOINCREMENT DEFAULT 1000,
    icon BLOB
    );
    ''');

    await db.execute('''
    CREATE TABLE 'users' (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL, 
    last_name TEXT, 
    email TEXT, 
    phone_number TEXT 
    );
   ''');

    await db.execute('''
    CREATE TABLE debts_loans (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL, 
    is_debt INTEGER, 
    loan_date DATE NOT NULL,
    amount REAL NOT NULL,
    balance REAL NOT NULL,
    repayment_date DATE,
    repayment_amount REAL,
    note TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
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
    CREATE TABLE savings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_name TEXT NOT NULL,
    goal_name TEXT NOT NULL,
    currency TEXT NOT NULL,
    amount REAL NOT NULL,
    note TEXT 
    );
    ''');
    await insertIcons(db);
    await loadDefaultCategory(db);
  }

  Future<void> loadDefaultCategory(Database db) async {
    db.insert(_cat, {"id": 1, "icon_id": 11, "name": "groceries"});
    db.insert(_cat, {"id": 2, "icon_id": 2, "name": "bill"});
    db.insert(_cat, {"id": 3, "icon_id": 7, "name": "dog"});
    db.insert(_cat, {"id": 4, "icon_id": 6, "name": "doctor"});
    db.insert(_cat, {"id": 5, "icon_id": 5, "name": "children"});
    db.insert(_cat, {"id": 6, "icon_id": 9, "name": "entertainment"});
    db.insert(_cat, {"id": 7, "icon_id": 17, "name": "sport"});
    db.insert(_cat, {"id": 8, "icon_id": 16, "name": "repair"});
    db.insert(_cat, {"id": 9, "icon_id": 10, "name": "gift"});
    db.insert(_cat, {"id": 10, "icon_id": 14, "name": "other"});
  }

  Future<void> insertIcons(Database db) async {
    List<String> bases = [
      'assets/icons/airplane.png',
      'assets/icons/bill.png',
      'assets/icons/bus.png',
      'assets/icons/car.png',
      'assets/icons/children.png',
      'assets/icons/doctor.png',
      'assets/icons/dog.png',
      'assets/icons/dress.png',
      'assets/icons/electronics.png',
      'assets/icons/gift.png',
      'assets/icons/grocery.png',
      'assets/icons/health-insurance.png',
      'assets/icons/house.png',
      'assets/icons/other.png',
      'assets/icons/party.png',
      'assets/icons/repair.png',
      'assets/icons/sport.png',
    ];

    for (int i = 0; i < bases.length; i++) {
      var base = bases[i];
      final ByteData data = await rootBundle.load(base);
      final Uint8List bytes = data.buffer.asUint8List();
      int index = i + 1;
      db.insert(_icons, {"id": index, "icon": bytes});
    }
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
