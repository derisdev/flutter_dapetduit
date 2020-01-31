import 'dart:io';
import 'package:dapetduit/model/notifModel.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperNotif {
  static Database _database;
  static final DBHelperNotif db = DBHelperNotif._();

  DBHelperNotif._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'notif_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Notif('
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'time TEXT,'
          'description TEXT'
          ')');
    });
  }

  // Insert employee on database
  createNotif(Notif notif) async {
    await deleteAllNotif();
    final db = await database;
    final res = await db.insert('Notif', notif.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllNotif() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Notif');

    return res;
  }

  Future<List<Notif>> getAllNotif() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Notif");

    List<Notif> list =
        res.isNotEmpty ? res.map((c) => Notif.fromJson(c)).toList() : null;

    return list;
  }

  Future<String> getLastNotif() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Notif ORDER BY title DESC LIMIT 1");
    String title = res.last['title'];
    return title;
  }
}