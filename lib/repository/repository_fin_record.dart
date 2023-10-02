import 'package:finance_tracker/repository/repository.dart';
import 'package:finance_tracker/model/financial_record.dart';
import 'package:sqflite/sqflite.dart';

class FinancialRecordRepository extends Repository<FinancialRecord> {
  Database database;
  static const String table = 'financial_record';

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
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return FinancialRecord.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(FinancialRecord obj) async {
    return await database.update(table, obj.toUpdateMap(),
        where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
