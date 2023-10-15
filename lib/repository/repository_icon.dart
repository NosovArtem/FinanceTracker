import 'package:finance_tracker/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

import '../model/icon.dart';

class IconObjRepository extends Repository<IconObj> {
  Database database;

  static const String table = 'icons';

  IconObjRepository(this.database);

  @override
  Future<int> add(IconObj obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<IconObj?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<IconObj>> getAll() async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return IconObj.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(IconObj obj) async {
    return await database
        .update(table, obj.toUpdateMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
