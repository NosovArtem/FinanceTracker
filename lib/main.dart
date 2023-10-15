import 'package:finance_tracker/helper/db_helper.dart';
import 'package:finance_tracker/screen/menu_backup_screen.dart';
import 'package:finance_tracker/screen/menu_category_screen.dart';
import 'package:finance_tracker/screen/menu_debts_and_loans_screen.dart';
import 'package:finance_tracker/screen/menu_export_to_exel.dart';
import 'package:finance_tracker/screen/menu_saving_screen.dart';
import 'package:finance_tracker/screen/menu_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

import 'helper/helper.dart';
import 'screen/fin_track_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseHelper.instance.database;

  runApp(MaterialApp(
    routes: {
      '/category': (context) => ExpenseCategoryScreen(database),
      '/backup': (context) => BackupScreen(),
      '/user': (context) => UserPage(),
      // '/feedback': (context) => FeedbackPage(),
      '/exel': (context) => ImportExportExelScreen(database),
      '/debtloan': (context) => DebtLoanListScreen(database),
      '/savings': (context) => SavingsListScreen(database),
    },
    home: Home(database),
  ));
}

class Home extends StatelessWidget {
  Database database;

  Home(this.database);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Fin tracker',
              style: TextStyle(fontSize: 30.0),
            ),
            // Dropdown(context),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text(
                '',
                style: TextStyle(fontSize: 22),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text('Backup/Restore'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/backup');
              },
            ),
            ListTile(
              leading: Icon(Icons.import_export),
              title: Text('Export to EXEL'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/exel');
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Category page'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/category');
              },
            ),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text('Debts & Loans'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/debtloan');
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Savings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/savings');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.send),
              title: Text('Contact to developer'),
              onTap: () {
                sendEmail("Тема письма", "Тело письма");
              },
            ),
            ListTile(
              leading: Icon(Icons.share_outlined),
              title: Text('Tell a Friend'),
              onTap: () {
                Share.share('Hey, Check this out:',
                    subject: 'ссылка_на_приложение_в_зависимости_от_платформы');
              },
            ),
            Divider(),
            Center(
              child: Text(
                'Financial tracker',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showAboutDialog(context: context);
              },
              child: Text('Version 1.0'),
            ),
          ],
        ),
      ),
      body: Center(
        child: FinTrackScreen(context, database),
      ),
    );
  }
}
