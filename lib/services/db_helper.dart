import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            names TEXT,
            telephone TEXT,
            district TEXT,
            sector TEXT,
            cell TEXT,
            village TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByEmail(String email) async {
    final dbClient = await db;
    final maps = await dbClient.query('users', where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> authenticateUser(String email, String password) async {
    final dbClient = await db;
    final maps = await dbClient.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
} 