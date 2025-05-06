import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/Task.dart';

class TaskDatabaseHelper {
  static final TaskDatabaseHelper instance = TaskDatabaseHelper._init();
  static Database? _database;

  TaskDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      status TEXT,
      priority INTEGER,
      assignedTo TEXT,
      createdBy TEXT,
      createdAt TEXT,
      updatedAt TEXT,
      completed INTEGER,
      dueDate TEXT,          -- thêm dòng này
      category TEXT,         -- thêm dòng này
      attachments TEXT       -- thêm dòng này
    )
  ''');
  }

  Future<void> deleteOldTaskDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task.db');

    // Xoá file database cũ nếu tồn tại
    final exists = await databaseExists(path);
    if (exists) {
      await deleteDatabase(path);
      print('🗑️ Database task.db đã được xoá.');
    } else {
      print('ℹ️ Database task.db không tồn tại.');
    }
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<List<Task>> getTasksByUser(String userId) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'assignedTo = ?',
      whereArgs: [userId],
    );
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
