import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/User.dart';

class UserDatabaseHelper {
  static final UserDatabaseHelper instance = UserDatabaseHelper._internal();
  static Database? _database;

  UserDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT,
        createdAt TEXT NOT NULL,
        lastActive TEXT NOT NULL,
        isAdmin INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Đăng ký tài khoản
  Future<bool> insertUser(User user) async {
    final db = await database;
    try {
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return true;
    } catch (e) {
      print('Lỗi khi thêm user: $e');
      return false;
    }
  }

  // Đăng nhập
  Future<User?> getUserByUsernameAndPassword(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Kiểm tra tồn tại username
  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Lấy user theo ID
  Future<User?> getUserById(String id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Cập nhật thời gian hoạt động cuối
  Future<void> updateLastActive(String id, DateTime lastActive) async {
    final db = await database;
    await db.update(
      'users',
      {'lastActive': lastActive.toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Xoá toàn bộ user
  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }
}