import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Agronomist {
  final int? id;
  final String names;
  final String telephone;
  final String district;
  final String sector;
  final String organizationEmail;
  final String licensePath;
  final String password;

  Agronomist({
    this.id,
    required this.names,
    required this.telephone,
    required this.district,
    required this.sector,
    required this.organizationEmail,
    required this.licensePath,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'names': names,
      'telephone': telephone,
      'district': district,
      'sector': sector,
      'organizationEmail': organizationEmail,
      'licensePath': licensePath,
      'password': password,
    };
  }

  factory Agronomist.fromMap(Map<String, dynamic> map) {
    return Agronomist(
      id: map['id'],
      names: map['names'],
      telephone: map['telephone'],
      district: map['district'],
      sector: map['sector'],
      organizationEmail: map['organizationEmail'],
      licensePath: map['licensePath'],
      password: map['password'],
    );
  }
}

class AgroRegistitor {
  static final AgroRegistitor _instance = AgroRegistitor._internal();
  factory AgroRegistitor() => _instance;
  AgroRegistitor._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agronomists.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE agronomists(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            names TEXT,
            telephone TEXT,
            district TEXT,
            sector TEXT,
            organizationEmail TEXT UNIQUE,
            licensePath TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertAgronomist(Agronomist agronomist) async {
    final dbClient = await db;
    return await dbClient.insert('agronomists', agronomist.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Agronomist?> getAgronomistByEmail(String email) async {
    final dbClient = await db;
    final maps = await dbClient.query('agronomists', where: 'organizationEmail = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return Agronomist.fromMap(maps.first);
    }
    return null;
  }
}
