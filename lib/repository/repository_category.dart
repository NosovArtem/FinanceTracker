import 'package:finance_tracker/repository/repository.dart';
import 'package:finance_tracker/model/expense_category.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseCategoryRepository extends Repository<ExpenseCategory> {
  Database database;
  static const String table = 'categories';

  ExpenseCategoryRepository(this.database);

  @override
  Future<int> add(ExpenseCategory obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<ExpenseCategory?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<ExpenseCategory>> getAll() async {
    List<Map<String, Object?>> list = await database.rawQuery('''
    SELECT categories.*,
     icons.id AS i_id, 
     icons.icon AS i_icon
    FROM categories 
    INNER JOIN icons ON categories.icon_id = icons.id
    ''');
    return List.generate(list.length, (i) {
      return ExpenseCategory.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(ExpenseCategory obj) async {
    return await database.update(table, obj.toUpdateMap(),
        where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
