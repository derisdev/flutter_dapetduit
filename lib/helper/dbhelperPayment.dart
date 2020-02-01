import 'dart:io';
import 'package:dapetduit/model/paymentModel.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperPayment {
  static Database _database;
  static final DBHelperPayment db = DBHelperPayment._();

  DBHelperPayment._();

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
    final path = join(documentsDirectory.path, 'payment_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Payment('
          'id INTEGER PRIMARY KEY,'
          'via TEXT,'
          'amount TEXT,'
          'status TEXT,'
          'time TEXT'
          ')');
    });
  }

  // Insert employee on database
  createPayment(Payment payment) async {
    await deleteAllPayment();
    final db = await database;
    final res = await db.insert('Payment', payment.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllPayment() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Payment');

    return res;
  }

  Future<List<Payment>> getAllPayment() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Payment ORDER BY id DESC");

    List<Payment> list =
        res.isNotEmpty ? res.map((c) => Payment.fromJson(c)).toList() : null;

    return list;
  }
}