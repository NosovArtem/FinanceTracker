import 'package:finance_tracker/model/expense_category.dart';

Future<Map<int, String>> convertToIdToName(
    List<ExpenseCategory> list) async {
  Map<int, String> map = {};
  for (var value in list) {
    map[value.id] = value.name;
  }
  return map;
}

Future<Map<String, int>> convertToNameToId(
    List<ExpenseCategory> list) async {
  Map<String, int> map = {};
  for (var value in list) {
    map[value.name] = value.id;
  }
  return map;
}
