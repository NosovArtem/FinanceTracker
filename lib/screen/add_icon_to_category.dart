import 'dart:typed_data';

import 'package:finance_tracker/model/icon.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../repository/repository.dart';
import '../repository/repository_icon.dart';

class IconSelectionScreen extends StatefulWidget {
  Database database;

  IconSelectionScreen(this.database);

  @override
  _IconSelectionScreenState createState() => _IconSelectionScreenState();
}

class _IconSelectionScreenState extends State<IconSelectionScreen> {
  late Repository<IconObj> repository = IconObjRepository(widget.database);
  List<IconObj> allFontAwesomeIcons = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    allFontAwesomeIcons = await repository.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getButton(),
        ),
        body: getGridViews());
  }

  Widget getGridViews() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Количество столбцов в сетке
        ),
        itemCount: allFontAwesomeIcons.length, // Количество элементов
        itemBuilder: (context, index) {
          IconObj iconObj = allFontAwesomeIcons[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Center(
                child: IconButton(
              icon: Image.memory(
                iconObj.icon,
                width: 30,
                height: 30,
              ),
              onPressed: () async {
                Navigator.pop(context, {"icon": iconObj});
              },
            )),
          );
        });
  }

  Widget getButton() {
    return ElevatedButton(
      onPressed: () async {
        final imagePicker = ImagePicker();
        final XFile? pickedFile =
            await imagePicker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          Uint8List iconBytes = await pickedFile.readAsBytes();
          int i = await repository.add(IconObj(id: -1, icon: iconBytes));
          _load();
        }
      },
      child: Text('Новая иконка'),
    );
  }
}
