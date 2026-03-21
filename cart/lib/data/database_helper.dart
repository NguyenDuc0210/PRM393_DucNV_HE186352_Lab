import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cart_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS cart');
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      originalPrice REAL NOT NULL,
      discountedPrice REAL NOT NULL,
      imageUrl TEXT NOT NULL,
      quantity INTEGER NOT NULL
      )
    ''');

    double iphoneOriginal = 1199.0;
    double samsungOriginal = 1099.0;
    double discountAmount = 200.0;

    await db.insert('cart', {
      'name': 'iPhone 15',
      'originalPrice': iphoneOriginal,
      'discountedPrice': iphoneOriginal - discountAmount,
      'imageUrl': 'assets/img.png',
      'quantity': 1,
    });

    await db.insert('cart', {
      'name': 'Samsung S24',
      'originalPrice': samsungOriginal,
      'discountedPrice': samsungOriginal - discountAmount,
      'imageUrl': 'assets/img_1.png',
      'quantity': 2,
    });
  }

  Future<int> insert(CartItem item) async {
    final db = await instance.database;
    return await db.insert('cart', item.toMap());
  }

  Future<List<CartItem>> getAllItems() async {
    final db = await instance.database;
    final result = await db.query('cart');
    return result.map((json) => CartItem.fromMap(json)).toList();
  }

  Future<int> update(CartItem item) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
