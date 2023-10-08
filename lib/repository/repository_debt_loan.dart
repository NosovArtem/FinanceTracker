import 'package:finance_tracker/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

import '../model/debt_loan.dart';

class DebtLoanRepository extends Repository<DebtLoan> {
  Database database;

  static const String table = 'debts_loans';

  DebtLoanRepository(this.database);

  @override
  Future<int> add(DebtLoan obj) async {
    return await database.insert(table, obj.toCreateMap());
  }

  @override
  Future<DebtLoan?> getById(int id) async {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<DebtLoan>> getAll() async {
    List<Map<String, Object?>> list = await database.query(table);
    return List.generate(list.length, (i) {
      return DebtLoan.fromMap(list[i]);
    });
  }

  @override
  Future<int> update(DebtLoan obj) async {
    return await database
        .update(table, obj.toUpdateMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  @override
  Future<int> delete(int id) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
