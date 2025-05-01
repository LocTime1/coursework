import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class MyDatabase {
  static final MyDatabase _instance = MyDatabase._internal();
  factory MyDatabase() => _instance;
  MyDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'Tasks.db');

    return await openDatabase(
      path,
      version: 5, 
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            deadline TEXT,
            color INTEGER,
            isCompleted INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            createdAt TEXT,
            lastEditedAt TEXT,
            color INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute(
              'ALTER TABLE tasks ADD COLUMN isCompleted INTEGER DEFAULT 0');
        }
        if (oldVersion < 5) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS notes(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              text TEXT,
              createdAt TEXT,
              lastEditedAt TEXT,
              color INTEGER
            )
          ''');
        }
      },
    );
  }


  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<int> updateTaskCompletion(int id, int isCompleted) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isCompleted': isCompleted},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> insertOrUpdateNote({
    int? id,
    required String text,
    required int color,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    Map<String, dynamic> note = {
      'text': text,
      'color': color,
      'lastEditedAt': now,
    };

    if (id != null) {
      await db.update(
        'notes',
        note,
        where: 'id = ?',
        whereArgs: [id],
      );
      return id;
    } else {
      note['createdAt'] = now;
      return await db.insert('notes', note);
    }
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes', orderBy: 'lastEditedAt DESC');
  }
}
