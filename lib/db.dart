import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

sealed class DbHelper {
  static Database? _db;

  static Future get db async {
    return _db ??= await init();
  }

  static Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "Notes.db");
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  static Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE NOTES(
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      TITLE TEXT NOT NULL,
      DESCRIPTION TEXT NOT NULL );
      ''');
  }

  static Future<int?> addData(String title, String description) async {
    await db;
    return await _db
        ?.insert("NOTES", {"TITLE": title, "DESCRIPTION": description});
  }

  static Future<List<(int, String, String)>> fetchAll() async {
    await db;
    List<(int, String, String)> results = [];
    List<Map<String, Object?>>? json = await _db?.query('NOTES');
    json ??= [];
    for (final item in json) {
      final {'ID': a, 'TITLE': b, 'DESCRIPTION': c} = item;
      results.add((a as int, b as String, c as String));
    }
    return results;
  }

  static Future<int?> delete(int id) async {
    await db;
    return await _db?.delete(
      "NOTES",
      where: 'ID = $id',
    );
  }
}
