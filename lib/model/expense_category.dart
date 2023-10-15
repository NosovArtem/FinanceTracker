import 'icon.dart';
import 'obj.dart';

class ExpenseCategory extends Obj {
  final int id;
  final String name;
  IconObj iconObj;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.iconObj,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'name': name,
      'icon_id': iconObj.id,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'name': name,
      'icon_id': iconObj.id,
    };
  }

  factory ExpenseCategory.fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(
        id: map['id'],
        name: map['name'],
        iconObj: IconObj(id: map['i_id'], icon: map['i_icon']));
  }
}
