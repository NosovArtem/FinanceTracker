import 'package:finance_tracker/model/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = "FinTracker.db";
  static const _databaseVersion = 1;

  final String transactions = 'transactions';

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
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          );
        ''');

    await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
        ''');

    await db.execute('''
          CREATE TABLE $transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            category_id INTEGER NOT NULL,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id),
            FOREIGN KEY (category_id) REFERENCES categories (id)
          );
        ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db
        .update('users', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insert(MainRecord record) async {
    final Database db = await instance.database;
    return await db.insert(transactions, record.toMap());
  }

  Future<int> update(MainRecord record) async {
    final Database db = await instance.database;
    String tableRecords;
    return await db.update(transactions, record.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    var delete = db.delete(transactions,
        where: "recordsColumnId" + ' = ?', whereArgs: [id]);
    return await delete;
  }

  Future<List<MainRecord>> getAllRecords() async {
    Database db = await instance.database;
    // List<Map<String, dynamic>> diagnosisRecords = await db.rawQuery('''
    //   SELECT * FROM $tableRecords
    //   JOIN $tableDiagnosis
    //   ON $tableRecords.$recordsColumnId = $tableDiagnosis.$recordsColumnId
    // ''');

    List<Map<String, dynamic>> combinedRecordsFinal = [];

    return List.generate(combinedRecordsFinal.length, (i) {
      return MainRecord.fromMap(combinedRecordsFinal[i]);
    });
  }

// --------------------------------------------------------
//
// Future<void> backup() async {
//   Fluttertoast.showToast(msg: 'Экспорт базы данных начат...');
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String sourcePath = join(appDocDir.path,
//       join(await getDatabasesPath(), DatabaseHelper.databaseName));
//
//   try {
//     await _database?.close();
//     final destination = await getTemporaryDirectory();
//
//     DateTime now = DateTime.now();
//     String formattedDateTime = DateFormat('yyyy_MM_dd_HH_mm').format(now);
//     final sourceFile = File(sourcePath);
//     final destinationFile = File(
//         join(destination.path, '${formattedDateTime}_backup_database.db'));
//     await sourceFile.copy(destinationFile.path);
//
//     Share.shareFiles([destinationFile.path], text: 'Поделиться файлом');
//     await _initDatabase();
//     print(
//         'Резервная копия базы данных успешно сохранена в: ${destinationFile.path}');
//   } catch (e) {
//     Fluttertoast.showToast(
//         msg: 'Ошибка при создании резервной копии базы данных: $e',
//         backgroundColor: Colors.red);
//     print('Ошибка при создании резервной копии базы данных: $e');
//   }
// }
//
// Future<void> restore(String dumpFilePath) async {
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String databasePath = join(appDocDir.path,
//       join(await getDatabasesPath(), DatabaseHelper.databaseName));
//
//   final backupFile = File(dumpFilePath);
//   await backupFile.copy(databasePath);
//
//   final newDatabaseFile = File(databasePath);
//   if (await newDatabaseFile.exists()) {
//     Fluttertoast.showToast(
//         msg: 'База данных успешно восстановлена из бэкапа.');
//   } else {
//     Fluttertoast.showToast(
//         msg: 'Ошибка восстановления базы данных из бэкапа.',
//         backgroundColor: Colors.red);
//   }
// }
}
