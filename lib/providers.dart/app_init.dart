// import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppInit {
  AppInit() {
    // initDb();
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    // bool isdb = await File(path).exists();
    Database db = await openDatabase(path);
    await createDownloadTable(db);
    await createFavTable(db);
    await createHistortTable(db);
    await createReminderTable(db);
//    db.close();
  }

  createReminderTable(db) async {
    try {
      await db.execute('''CREATE TABLE "reminder" (
                                              "id"	INTEGER,
                                                "time"	TEXT,
                                                "day"	TEXT,
                                                "status" INTEGER
                              )''');

      return true;
    } catch (e) {
      // print('Error is this ');
      // print(e);
      return false;
    }
   
  }

  createHistortTable(db) async {
    try {
      await db.execute('''CREATE TABLE "history" (
                                                      "id"	INTEGER,
                                                      "title"	TEXT,
                                                      "filename"	TEXT,
                                                      "duration"	TEXT,
                                                      "cid"	INTEGER,
                                                      "description"	TEXT,
                                                      "url"	TEXT,
                                                      "cname"	TEXT,
                                                      "composer"	TEXT,
                                                      "image"	TEXT
                                                )''');

                                                 return true;
    } catch (e) {
      // print('Error is this ');
      // print(e);
       return true;
    }
  }

  createDownloadTable(db) async {
    try {
      await db.execute('''CREATE TABLE "download" (
                                              "id"	INTEGER,
                                                "title"	TEXT,
                                                "filename"	TEXT,
                                                "duration"	TEXT,
                                                "cid"	INTEGER,
                                                "description"	TEXT,
                                                "url"	TEXT,
                                                "cname"	TEXT,
                                                "composer"	TEXT,
                                                "image"	TEXT
                              )''');
                               return true;
    } catch (e) {
      // print('Error is this ');
      // print(e);
       return true;
    }
  }

  createFavTable(db) async {
    try {
      await db.execute('''CREATE TABLE "favourite" (
                                                      "id"	INTEGER,
                                                      "title"	TEXT,
                                                      "filename"	TEXT,
                                                      "duration"	TEXT,
                                                      "cid"	INTEGER,
                                                      "description"	TEXT,
                                                      "url"	TEXT,
                                                      "cname"	TEXT,
                                                      "composer"	TEXT,
                                                      "image"	TEXT
                                                )''');
                                                 return true;
    } catch (e) {
      // print('Error is this ');
      // print(e);
       return true;
    }
  }
}
