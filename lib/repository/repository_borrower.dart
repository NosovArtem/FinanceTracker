import 'package:finance_tracker/model/borrower.dart';
import 'package:finance_tracker/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

class BorrowerRepository extends Repository<Borrower> {
  Database database;

  static const String table = 'borrowers';

  BorrowerRepository(this.database);

  @override
  Future<int> add(Borrower obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<Borrower?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Borrower>> getAll() async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return Borrower.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(Borrower obj) async {
    return await database
        .update(table, obj.toUpdateMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
