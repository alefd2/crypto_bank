import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // construtor com acesso privado para somente uma instancia tenha acesso
  DB._();
  // criar umas instancia de DB
  static final DB instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDataBase();
  }

  _initDataBase() async {
    return await openDatabase(join(await getDatabasesPath(), 'cripto.db'),
        version: 1, onCreate: _onCreate);
  }

  _onCreate(db, version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_history);
    await db.insert('account', {'balance': 0});
  }

  String get _account => '''
    CREATE TABLE account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      balance REAL
    );
  ''';

  String get _wallet => '''
    CREATE TABLE wallet (
      acronym TEXT,
      coin TEXT,
      quantity TEXT  
    );
  ''';

  String get _history => '''
    CREATE TABLE history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date_operation INT,
      type_operation TEXT,
      coin TEXT,
      acronym TEXT,
      value REAL,
      quantity TEXT
    );
  ''';
}
