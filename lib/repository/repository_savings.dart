import 'package:finance_tracker/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

import '../model/savings.dart';

class SavingsRepository extends Repository<Savings> {
  Database database;

  static const String table = 'savings';

  SavingsRepository(this.database);

  @override
  Future<int> add(Savings obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<Savings?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Savings>> getAll() async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return Savings.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(Savings obj) async {
    return await database
        .update(table, obj.toUpdateMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
