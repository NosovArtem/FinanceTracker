import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = "FinTracker4.db";
  static const _databaseVersion = 1;

  static const String tableUser = 'user';
  static const String tableFinancialRecords = 'financial_record';
  static const String tableCategory = 'category';

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
          CREATE TABLE '$tableUser' (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          );
        ''');
    await db.execute('''
          CREATE TABLE '$tableFinancialRecords' (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            category_id INTEGER NOT NULL,
            amount REAL NOT NULL,
            note TEXT NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id),
            FOREIGN KEY (category_id) REFERENCES categories (id)
          );
        ''');
    await db.execute('''
          CREATE TABLE '$tableCategory' (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
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
      final destination = await getTemporaryDirectory();

      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('yyyy_MM_dd_HH_mm').format(now);
      final sourceFile = File(sourcePath);
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
