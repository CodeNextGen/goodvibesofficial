import 'package:flutter/foundation.dart';
import 'package:goodvibes/models/notification_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReminderDbProvider with ChangeNotifier {
  Database db;
  List<NotificationModel> notifications = [];

  ReminderDbProvider() {
    initDB();
  }
  void initDB() async {
    String path;
    var databasesPath;
    databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'data.db');
    db = await openDatabase(path, version: 1);
  }

  deleteReminder(int id) async {
    await db.rawDelete('delete from  reminder where id=$id');
    getReminder();
  }

  deleteAllTable() async {
    await db.rawDelete('delete from reminder');
    getReminder();
  }

  deleteMultipleRecors(List<int> ids) {
    ids.forEach((int id) async {
      await db.rawDelete('delete from reminder where id=$id');
    });

    getReminder();
  }

  addReminder({int id, String time, String day, int status}) async {
    print('Set reminder db $time');
    await db.rawInsert(
        '''insert into  reminder (id ,time,day,status) values ("$id" , "$time", "$day", "$status")''');
    getReminder();
  }

  updateStatus({int id, bool status}) async {
    int stat;
    if (status == true)
      stat = 1;
    else
      stat = 0;
    await db.rawUpdate('UPDATE reminder SET status= $stat WHERE id=$id');
    getReminder();
  }

  getReminder() async {
    var fb = await db.rawQuery('select * from reminder');
    var a = fb.map<NotificationModel>((data) => NotificationModel.fromDb(data));
    notifications.clear();
    notifications.addAll(a);
    notifyListeners();
  }
}
