import 'package:dapetduit/model/historyModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;  

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'history.db';
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time TEXT,
        src TEXT,
        coin TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.rawQuery('''SELECT * FROM history ORDER BY id DESC''');
    return mapList;
  }

  Future<int> insert(HistoryModel object) async {
    Database db = await this.database;
    int count = await db.insert('history', object.toMap());
    return count;
  }

  Future<int> update(HistoryModel object) async {
    Database db = await this.database;
    int count = await db.update('history', object.toMap(), 
                                where: 'id=?',
                                whereArgs: [object.id]);
    return count;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('history', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }
  
  Future<List<HistoryModel>> getHistoryList() async {
    var historyMapList = await select();
    int count = historyMapList.length;
    List<HistoryModel> historyList = List<HistoryModel>();
    for (int i=0; i<count; i++) {
      historyList.add(HistoryModel.fromMap(historyMapList[i]));
    }
    return historyList;
  }

}