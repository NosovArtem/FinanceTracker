import 'package:finance_tracker/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

import '../model/lender.dart';

class LenderRepository extends Repository<Lender> {
  Database database;

  static const String table = 'lenders';

  LenderRepository(this.database);

  @override
  Future<int> add(Lender obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<Lender?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Lender>> getAll() async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return Lender.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(Lender obj) async {
    return await database
        .update(table, obj.toUpdateMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
