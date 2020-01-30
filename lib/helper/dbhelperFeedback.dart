import 'dart:io';
import 'package:dapetduit/model/feedbackModel.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperFeedback {
  static Database _database;
  static final DBHelperFeedback db = DBHelperFeedback._();

  DBHelperFeedback._();

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
    final path = join(documentsDirectory.path, 'feedback_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Feedback('
          'id INTEGER PRIMARY KEY,'
          'question TEXT,'
          'answer TEXT'
          ')');
    });
  }

  // Insert employee on database
  createFeedback(FeedbackModel feedback) async {
    await deleteAllFeedback();
    final db = await database;
    final res = await db.insert('Feedback', feedback.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllFeedback() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Feedback');

    return res;
  }

  Future<List<FeedbackModel>> getAllFeedback() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Feedback");

    List<FeedbackModel> list =
        res.isNotEmpty ? res.map((c) => FeedbackModel.fromJson(c)).toList() : null;

    return list;
  }
}