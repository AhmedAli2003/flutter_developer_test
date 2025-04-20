import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return LocalDatabase(null);
});

class LocalDatabase {
  Database? _db;

  LocalDatabase(this._db);

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'orders.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE orders (
      id INTEGER PRIMARY KEY,
      status TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER,
      productName TEXT,
      note TEXT,
      quantity INTEGER,
      imagePath TEXT,
      FOREIGN KEY (orderId) REFERENCES orders(id)
    )
  ''');
  }
}
