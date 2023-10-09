import 'package:flutter/material.dart';

void showConfirmationDialog(BuildContext context, VoidCallback callback) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Подтверждение'),
        content: Text('Вы уверены, что хотите продолжить?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отменить'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              callback();
            },
            child: Text('Принять'),
          ),
        ],
      );
    },
  );
}
