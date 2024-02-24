import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_database.db');

    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, detail TEXT, importance TEXT, startDate TEXT, assignedPerson TEXT)',
      );
    });
  }

  Future<void> addTask(String name, String detail, String importance, DateTime startDate, String assignedPerson) async {
    await _database!.insert('tasks', {
      'name': name ?? '',
      'detail': detail ?? '',
      'importance': importance ?? '',
      'startDate': startDate.toIso8601String() ?? '',
      'assignedPerson': assignedPerson ?? '',
    });
  }



  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await _database;
    if( db == null) {
      return [];
    }
    return db.query('tasks');
  }


  Future<void> updateTask(int id, String name, String detail, String importance, DateTime startDate, String assignedPerson)  async {

    final db = _database;
    if( db == null) {
      throw Exception('Database not initialized.');
    }
    await db.update(
      'tasks',
      {
        'name': name ?? '',
        'detail': detail ?? '',
         'importance': importance ?? '',
        'startDate': startDate.toIso8601String() ?? '',
        'assignedPerson': assignedPerson ?? '',
      },
      where: 'id = ?',
      whereArgs: [id] ,
    );
  }

  Future<void> deleteTask(int id) async {
    await _database!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}