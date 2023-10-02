import 'package:finance_tracker/repository/repository.dart';
import 'package:finance_tracker/model/user.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository extends Repository<User> {
  Database database;

  static const String table = 'user';

  UserRepository(this.database);


  @override
  Future<int> add(User obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<User?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAll() async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return User.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(User obj) async {
    return await database.update(table, obj.toUpdateMap(),
        where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
