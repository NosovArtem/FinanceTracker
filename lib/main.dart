import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'fin_track_screen.dart';

void main() => runApp(MaterialApp(
  routes: {
  },
  home: Home(),
));

class Home extends StatelessWidget {
  Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'UserName',
              style: TextStyle(fontSize: 20.0),
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
                'UserName',
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
                Navigator.pushNamed(context, '/export');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.sentiment_satisfied),
              title: Text('Send Feedback'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/feedback');
              },
            ),
            ListTile(
              leading: Icon(Icons.share_outlined),
              title: Text('Tell a Friend'),
              onTap: () {
                Share.share('Hey, Check this out:',
                    subject: 'ссылка на приложение в зависимости от платформы');
              },
            ),
            Divider(),
            Center(
              child: Text(
                'Health tracker',
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
        child: FinTrackScreen(context),
      ),
    );
  }
}
