import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/data/model/transactions.dart';
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
             description TEXT NOT NULL,
             amount INTEGER NOT NULL,
             transaction_date TEXT NOT NULL,
             id_categories INTEGER NOT NULL,
             type TEXT NOT NULL,
             FOREIGN KEY (id_categories) REFERENCES $_tblCategories (id) ON DELETE NO ACTION ON UPDATE NO ACTION
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

  /**
   * Fungsi CRUD table transactions
   */

  // fungsi Insert Kategori
  Future<void> insertTransaction(Transactions transaction) async {
    final db = await database;
    await db!.insert(_tblTransaction, transaction.toMap());
    print('Data saved');
  }

  // Fungsi get all transactions
  // Future<List<Transactions>> getTransactions() async {
  //   final Database? db = await database;
  //   List<Map<String, dynamic>> results = await db!.query(_tblTransaction);

  //   return results.map((res) => Transactions.fromMap(res)).toList();
  // }

  // Fungsi get all transaction join category
  Future<List<Transactions>> getTransactionsJoinCategory() async {
    final Database? db = await database;
    List<Map<String, dynamic>> results = await db!.rawQuery(
        "SELECT t.*, c.name FROM $_tblTransaction t INNER JOIN $_tblCategories c ON t.id_categories = c.id");

    return results.map((res) => Transactions.fromMap(res)).toList();
  }

  Future<List<Transactions>> getTransactionsJoinCategorybyMonthAndYear(
      int month, int year) async {
    final Database? db = await database;
    List<Map<String, dynamic>> results = await db!.rawQuery(
        "SELECT t.*, c.name FROM $_tblTransaction t INNER JOIN $_tblCategories c ON t.id_categories = c.id AND t.transaction_date LIKE '%$year-$month%' GROUP BY t.transaction_date ORDER BY t.transaction_date DESC");
    // print(results);
    return results.map((res) => Transactions.fromMap(res)).toList();
  }

  Future<List<Transactions>> getTransactionsJoinCategorybyDateMonthAndYear(
    // String day
    int month,
    int year,
  ) async {
    final Database? db = await database;
    List<Map<String, dynamic>> results = await db!.rawQuery(
        // "SELECT t.*, c.name FROM $_tblTransaction t LEFT JOIN $_tblCategories c ON t.id_categories = c.id WHERE t.transaction_date = '$day'"
        "SELECT t.*, c.name FROM $_tblTransaction t INNER JOIN $_tblCategories c ON t.id_categories = c.id AND t.transaction_date LIKE '%$year-$month%'");
    // print(results);
    return results.map((res) => Transactions.fromMap(res)).toList();
  }

  Future<List<TotalTransactions>> getTotalInMonth(int month, int year) async {
    final Database? db = await database;
    List<Map<String, dynamic>> results = await db!.rawQuery(
        "SELECT t.type, SUM(t.amount) as total FROM $_tblTransaction t INNER JOIN $_tblCategories c ON t.id_categories = c.id AND t.transaction_date LIKE '%$year-$month%' GROUP BY t.type");
    // print(results);

    return results.map((res) => TotalTransactions.fromMap(res)).toList();
  }

  // Future<List<TotalTransactionPerDay>> getTotalPengeluaranAndPemasukanbyDay(
  //     String date) async {
  //   final db = await database;

  //   List<Map<String, dynamic>> results = await db!.rawQuery(
  //       "SELECT SUM(amount) FROM $_tblTransaction where transaction_date = $date GROUP BY type");

  //   return results.map((res) => TotalTransactionPerDay.fromMap(res)).toList();
  // }

  // Fungsi get transactions by id
  // Future<Map> getTransactionById(int id) async {
  //   final db = await database;

  //   List<Map<String, dynamic>> results = await db!.query(
  //     _tblTransaction,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );

  //   if (results.isNotEmpty) {
  //     return results.first;
  //   } else {
  //     return {};
  //   }
  // }

  // Fungsi Update transactions
  Future<void> updateTransaction(Transactions transaction) async {
    final db = await database;

    await db!.update(
      _tblTransaction,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Fungsi menghapus transactions
  Future<void> removeTransaction(int? id) async {
    final db = await database;

    await db!.delete(
      _tblTransaction,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
