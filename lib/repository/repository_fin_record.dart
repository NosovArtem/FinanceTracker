import 'package:finance_tracker/model/financial_record.dart';
import 'package:finance_tracker/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

class FinancialRecordRepository extends Repository<FinancialRecord> {
  Database database;
  static const String table = 'financial_record';
  static const String tableCategory = 'categories';

  FinancialRecordRepository(this.database);

  @override
  Future<int> add(FinancialRecord obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<FinancialRecord?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<FinancialRecord>> getAll() async {
    List<Map<String, Object?>> list = await database.rawQuery('''
    SELECT financial_record.*, financial_record.date as date,
     categories.id AS cat_id, 
     categories.name AS cat_name, 
     icons.id AS i_id,
     icons.icon AS i_icon
    FROM financial_record 
    INNER JOIN categories ON financial_record.category_id = categories.id
    INNER JOIN icons ON categories.icon_id = icons.id
    ''');
    return List.generate(list.length, (i) {
      return FinancialRecord.fromMap(list[i]);
    });
  }

  Future<List<FinancialRecord>> getAllByMonth(DateTime dateTime) async {
    final startDate = DateTime(dateTime.year, dateTime.month, 1);
    final endDate = DateTime(dateTime.year, dateTime.month + 1, 1)
        .subtract(Duration(days: 1));
    List<Map<String, Object?>> list = await database.rawQuery('''
    SELECT financial_record.*, financial_record.date as date,
     categories.id AS cat_id, 
     categories.name AS cat_name, 
     icons.id AS i_id,
     icons.icon AS i_icon
    FROM financial_record 
    INNER JOIN categories ON financial_record.category_id = categories.id
    INNER JOIN icons ON categories.icon_id = icons.id
    WHERE date >= ? AND date <= ?
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);
    return List.generate(list.length, (i) {
      return FinancialRecord.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(FinancialRecord obj) async {
    return await database
        .update(table, obj.toUpdateMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
