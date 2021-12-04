import 'package:flutter/material.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/utils/result_state.dart';

class CategoryProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  CategoryProvider({required this.databaseHelper}) {
    _getCategoriesByPemasukan();
    _getCategoriesByPengeluaran();
  }

  late ResultState _state = ResultState.loading;
  ResultState get state => _state;

  late ResultState _statePemasukan = ResultState.loading;
  ResultState get statePemasukan => _statePemasukan;

  late ResultState _statePengeluaran = ResultState.loading;
  ResultState get statePengeluaran => _statePengeluaran;

  String _message = '';
  String get message => _message;

  List<Category> _categoriesPemasukan = [];
  List<Category> get categoriesPemasukan => _categoriesPemasukan;

  List<Category> _categoriesPengeluaran = [];
  List<Category> get categoriesPengeluaran => _categoriesPengeluaran;

  void _getCategoriesByPemasukan() async {
    _categoriesPemasukan = await databaseHelper.getCategoryByPemasukan();

    if (_categoriesPemasukan.isNotEmpty) {
      _statePemasukan = ResultState.hasData;
    } else {
      _statePemasukan = ResultState.noData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  void _getCategoriesByPengeluaran() async {
    _categoriesPengeluaran = await databaseHelper.getCategoryByPengeluaran();

    if (_categoriesPengeluaran.isNotEmpty) {
      _statePengeluaran = ResultState.hasData;
    } else {
      _statePengeluaran = ResultState.noData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  void addCategory(Category category) async {
    try {
      await databaseHelper.insertCategory(category);
      _getCategoriesByPemasukan();
      _getCategoriesByPengeluaran();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal Menambahkan Kategori';
      notifyListeners();
    }
  }

  void getCategoryById(int id) async {
    final categories = await databaseHelper.getCategoryById(id);

    if (categories.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  void removeCategory(int? id) async {
    try {
      await databaseHelper.removeCategory(id);
      _getCategoriesByPemasukan();
      _getCategoriesByPengeluaran();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal Menghapus Kategori';
      notifyListeners();
    }
  }

  void updateCategory(Category category) async {
    try {
      await databaseHelper.updateCategory(category);
      _getCategoriesByPemasukan();
      _getCategoriesByPengeluaran();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal Mengubah Kategori';
      notifyListeners();
    }
  }
}
