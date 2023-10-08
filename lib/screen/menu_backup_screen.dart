import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helper/db_helper.dart';

class BackupScreen extends StatefulWidget {
  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final dbHelper = DatabaseHelper.instance;

  Future<void> _backup() async {
    await dbHelper.backup();
  }

  _restore() async {
    final dumpFilePath = await chooseFile();
    if (dumpFilePath != null) {
      await dbHelper.restore(dumpFilePath);
    }
  }

  Future<String?> chooseFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.first.path;
        return filePath;
      } else {
        Fluttertoast.showToast(
            msg: 'Выбор файла отменен', backgroundColor: Colors.yellow);
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Ошибка выбора файла:: $e', backgroundColor: Colors.red);
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _restore,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.restore),
                            Text(
                              'Restore',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _backup,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.backup),
                            Text(
                              'Backup',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
