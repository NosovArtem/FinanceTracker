import 'package:finance_tracker/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

import '../model/repayment.dart';

class RepaymentRepository extends Repository<Repayment> {
  Database database;

  static const String table = 'repayments';

  RepaymentRepository(this.database);

  @override
  Future<int> add(Repayment obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<Repayment?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Repayment>> getAll() async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return Repayment.fromMap(list[i]);
    });
  }

  Future<List<Repayment>> getAllByDebtLoanId(int debtLoanId) async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return Repayment.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(Repayment obj) async {
    return await database
        .update(table, obj.toUpdateMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
