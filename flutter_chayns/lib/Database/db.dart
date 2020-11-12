import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_chayns/Objects/chaynssite.dart';

abstract class DB {
  static Database _db;
  static int _version = 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "TestDatabase";
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE location_tabelle (id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, siteId STRING, pathToPic STRING)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db.query(table);
  }

  static Future<int> insert(String table, Site site) async {
    return await _db.insert(table, site.toMap());
  }

  static deleteTable(String table) async {
    return await _db.execute("DELETE From $table");
  }

  static Future<Site> getSite(int id) async {
    List<Map> maps = await _db.query(Site.table, where: '$id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Site.fromMap(maps.first);
    }
    return null;
  }
}
