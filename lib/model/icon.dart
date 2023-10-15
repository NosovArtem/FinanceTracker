import 'dart:typed_data';

import 'package:finance_tracker/model/obj.dart';

class IconObj extends Obj {
  final int id;
  Uint8List icon;

  IconObj({
    required this.id,
    required this.icon,
  });

  @override
  Map<String, dynamic> toCreateMap() {
    return {
      'icon': icon,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'icon': icon,
    };
  }

  factory IconObj.fromMap(Map<String, dynamic> map) {
    return IconObj(
      id: map['id'],
      icon: map['icon'],
    );
  }
}
