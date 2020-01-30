import 'dart:io';
import 'package:dapetduit/model/OfferwallModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperOfferwall {
  static Database _database;
  static final DBHelperOfferwall db = DBHelperOfferwall._();

  DBHelperOfferwall._();

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
    final path = join(documentsDirectory.path, 'offerwall_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Offerwall('
          'id INTEGER PRIMARY KEY,'
          'icon TEXT,'
          'title TEXT,'
          'image TEXT,'
          'description TEXT,'
          'coin TEXT'
          ')');
    });
  }

  // Insert employee on database
  createOfferwall(OfferwallModel offerwall) async {
    await deleteAllOfferwall();
    final db = await database;
    final res = await db.insert('Offerwall', offerwall.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllOfferwall() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Offerwall');

    return res;
  }

  Future<List<OfferwallModel>> getAllOfferwall() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Offerwall");

    List<OfferwallModel> list =
        res.isNotEmpty ? res.map((c) => OfferwallModel.fromJson(c)).toList() : null;

    return list;
  }
}