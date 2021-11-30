import 'package:money_writer_app/data/model/category.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  // Tabel Kategori
  static const String _tblCategories = 'categories';

  // Tabel Transaksi
  static const String _tblTransaction = 'transactions';

  static const String _pemasukan = 'pemasukan';
  static const String _pengeluaran = 'pengeluaran';

  String insertQuery(String name, String type) {
    return 'INSERT INTO $_tblCategories(name, type) VALUES("$name", "$type")';
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/money_writer.db',
      onCreate: (db, version) async {
        // membuat tabel kategori
        await db.execute('''CREATE TABLE $_tblCategories (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             name TEXT NOT NULL,
             type TEXT NOT NULL
           )''');

        // membuat tabel transaksi
        await db.execute('''CREATE TABLE $_tblTransaction (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             description TEXT,
             amount INTEGER NOT NULL,
             transaction_date DATE,
             id_categories INTEGER,
             type TEXT NOT NULL,
             FOREIGN KEY (id_categories) REFERENCES $_tblCategories (id) ON DELETE CASCADE ON UPDATE NO ACTION
           )''');

        // Insert data awal untuk kategori pengeluaran dan masukan
        await db.execute(insertQuery('Makanan', 'pengeluaran'));
        await db.execute(insertQuery('Minuman', 'pengeluaran'));
        await db.execute(insertQuery('Kesehatan', 'pengeluaran'));
        await db.execute(insertQuery('Olahraga', 'pengeluaran'));
        await db.execute(insertQuery('Belanja', 'pengeluaran'));
        await db.execute(insertQuery('Gaji', 'pemasukan'));
        await db.execute(insertQuery('Penjualan', 'pemasukan'));
        await db.execute(insertQuery('Deposito', 'pemasukan'));
        await db.execute(insertQuery('Investasi', 'pemasukan'));
        await db.execute(insertQuery('Penyewaan', 'pemasukan'));
      },
      version: 1,
    );
    // print('$path/money_writer.db');
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  // fungsi Insert Kategori
  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db!.insert(_tblCategories, category.toJson());
  }

  // fungsi get semua Kategori
  Future<List<Category>> getCategories() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblCategories);

    return results.map((res) => Category.fromJson(res)).toList();
  }

  // fungsi get semua Kategori bertipe pemasukan
  Future<List<Category>> getCategoryByPemasukan() async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblCategories,
      where: 'type = ?',
      whereArgs: [_pemasukan],
    );

    return results.map((res) => Category.fromJson(res)).toList();
  }

  // fungsi get semua Kategori bertipe pengeluaran
  Future<List<Category>> getCategoryByPengeluaran() async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblCategories,
      where: 'type = ?',
      whereArgs: [_pengeluaran],
    );

    return results.map((res) => Category.fromJson(res)).toList();
  }

  // fungsi get Kategori by id
  Future<Map> getCategoryById(int id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblCategories,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  // fungsi menghapus Kategori
  Future<void> removeCategory(int? id) async {
    final db = await database;

    await db!.delete(
      _tblCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // fungsi mengubah/update Kategori
  Future<void> updateCategory(Category category) async {
    final db = await database;

    await db!.update(
      _tblCategories,
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}
