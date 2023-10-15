import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/popup_helper.dart';
import '../../repository/repository.dart';
import '../model/user.dart';
import '../repository/reposiitory_user.dart';
import 'add_users.dart';

class UsersScreen extends StatefulWidget {
  String borrowerOrLender;
  Database database;

  UsersScreen(this.database, this.borrowerOrLender);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Repository<User> repository = UserRepository(widget.database);
  List<User> borrowersAndLenders = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    List<User> list = await repository.getAll();
    setState(() {
      borrowersAndLenders = list;
    });
  }

  Future<void> add(User record) async {
    repository.add(record);
    _load();
  }

  Future<void> update(User record) async {
    repository.update(record);
    _load();
  }

  void delete(User record) {
    repository.delete(record.id);
    _load();
  }

  void _createRecord(BuildContext context, StatefulWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((map) {
      if (map != null) {
        add(map["new"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.borrowerOrLender),
      ),
      body: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: borrowersAndLenders.length,
        itemBuilder: (context, index) {
          final record = borrowersAndLenders[index];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(155, 183, 123, 70),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.man),
                              SizedBox(width: 8.0),
                              Text(
                                record.firstName,
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                record.lastName,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          onTap: () async {
                            Navigator.pop(
                                context, {"user": record});
                          },
                        ),
                      ],
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              showConfirmationDialog(context, () {
                                delete(record);
                              });
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ))
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).pop();
          _createRecord(context, AddUserScreen(widget.database));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
