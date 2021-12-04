import 'package:flutter/material.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/utils/result_state.dart';

class TransactionsProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;
  DateTime date = DateTime.now();

  TransactionsProvider() {
    _dbHelper = DatabaseHelper();
    _setData(date.month, date.year);
  }

  late ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Transactions> _transactionsMonth = [];
  List<Transactions> get transactionsMonth => _transactionsMonth;

  List<Transactions> _transactionsDay = [];
  List<Transactions> get transactionsDay => _transactionsDay;

  List<TotalTransactions> _totalInMonth = [];
  List<TotalTransactions> get totalInMonth => _totalInMonth;

  List<Transactions> _transactionsExport = [];
  List<Transactions> get transactionsExport => _transactionsExport;

  void _setData(int month, int year) {
    setAllTransactionsbyMonth(month, year);
    getTotalInMonth(month, year);
  }

  Future<void> setAllTransactionsbyMonth(int month, int year) async {
    _transactionsMonth =
        await _dbHelper.getTransactionsJoinCategorybyMonthAndYear(month, year);

    if (_transactionsMonth.isNotEmpty) {
      _state = ResultState.hasData;
      setAllTransactionsbyDay(month, year);
    } else {
      _state = ResultState.noData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  Future<void> setAllTransactionsbyDay(int month, int year) async {
    _transactionsDay = await _dbHelper
        .getTransactionsJoinCategorybyDateMonthAndYear(month, year);

    if (_transactionsDay.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  Future<void> addTransaction(Transactions transaction) async {
    try {
      await _dbHelper.insertTransaction(transaction);

      DateTime? parsedDateTime = DateTime.tryParse(transaction.transactionDate);

      _setData(parsedDateTime!.month, parsedDateTime.year);
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal Menambahkan Transaksi';
      notifyListeners();
    }
  }

  Future<void> getTotalInMonth(int month, int year) async {
    _totalInMonth = await _dbHelper.getTotalInMonth(month, year);

    if (_totalInMonth.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  Future<void> getTransactionForExport(String fromDate, String toDate) async {
    _transactionsExport =
        await _dbHelper.getTransactionsForExport(fromDate, toDate);

    if (_transactionsExport.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  void updateTransaction(Transactions transaction) async {
    try {
      await _dbHelper.updateTransaction(transaction);

      DateTime? parsedDateTime = DateTime.tryParse(transaction.transactionDate);

      _setData(parsedDateTime!.month, parsedDateTime.year);
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal Mengubah Transaksi';
      notifyListeners();
    }
  }

  void removeTransaction(int? id, String dateString) async {
    try {
      await _dbHelper.removeTransaction(id);

      DateTime? parsedDateTime = DateTime.tryParse(dateString);

      _setData(parsedDateTime!.month, parsedDateTime.year);
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal Menghapus Transaksi';
      notifyListeners();
    }
  }
}
