import 'package:flutter/material.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/utils/result_state.dart';

class TransactionsProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;
  DateTime date = DateTime.now();

  TransactionsProvider() {
    _dbHelper = DatabaseHelper();
    // _getAllTransactions();

    _setData(date.month, date.year);
  }

  late ResultState _state = ResultState.Loading;
  ResultState get state => _state;

  // late ResultState _stateTransaction = ResultState.Loading;
  // ResultState get stateTransaction => _stateTransaction;

  String _message = '';
  String get message => _message;

  // List<Transactions> _transactions = [];
  // List<Transactions> get transactions => _transactions;

  List<Transactions> _transactionsMonth = [];
  List<Transactions> get transactionsMonth => _transactionsMonth;

  List<Transactions> _transactionsDay = [];
  List<Transactions> get transactionsDay => _transactionsDay;

  List<TotalTransactions> _totalInMonth = [];
  List<TotalTransactions> get totalInMonth => _totalInMonth;

  // void _getAllTransactions() async {
  //   _transactions = await _dbHelper.getTransactionsJoinCategory();
  //   if (_transactions.isNotEmpty) {
  //     _stateTransaction = ResultState.HasData;
  //   } else {
  //     _stateTransaction = ResultState.NoData;
  //     _message = 'Tidak Ada Data';
  //   }
  //   notifyListeners();
  // }

  void _setData(int month, int year) {
    setAllTransactionsbyMonth(month, year);
    getTotalInMonth(month, year);
  }

  Future<void> setAllTransactionsbyMonth(int month, int year) async {
    _transactionsMonth =
        await _dbHelper.getTransactionsJoinCategorybyMonthAndYear(month, year);

    // print(_transactionsMonth);
    if (_transactionsMonth.isNotEmpty) {
      _state = ResultState.HasData;
      setAllTransactionsbyDay(month, year);
    } else {
      _state = ResultState.NoData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  Future<void> setAllTransactionsbyDay(
      /*String day*/ int month, int year) async {
    _transactionsDay = await _dbHelper
        .getTransactionsJoinCategorybyDateMonthAndYear(month, year);

    // print(_transactionsDay);
    if (_transactionsDay.isNotEmpty) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  Future<void> addTransaction(Transactions transaction) async {
    try {
      await _dbHelper.insertTransaction(transaction);
      // _getAllTransactions();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Gagal Menambahkan Transaksi';
      notifyListeners();
    }
  }

  Future<void> getTotalInMonth(int month, int year) async {
    _totalInMonth = await _dbHelper.getTotalInMonth(month, year);
    if (_totalInMonth.isNotEmpty) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  // int totalPemasukan(String date) {
  //   return _transactions.fold(0, (previousValue, element) {
  //     if (element.type == 'pemasukan' && element.transaction_date == date) {
  //       return previousValue + element.amount;
  //     } else {
  //       return 0;
  //     }
  //   });
  // }

  // Future<Transactions> getTransactionById(int id) async {
  //   final transactions = await _dbHelper.getTransactionById(id);
  //
  //   if (transactions.isNotEmpty) {
  //     _state = ResultState.HasData;
  //   } else {
  //     _state = ResultState.NoData;
  //     _message = 'Tidak Ada Data';
  //   }
  //   notifyListeners();
  // }

  void updateTransaction(Transactions transaction) async {
    try {
      await _dbHelper.updateTransaction(transaction);
      DateTime? parsedDateTime =
          DateTime.tryParse(transaction.transaction_date);

      _setData(parsedDateTime!.month, parsedDateTime.year);
      // _getAllTransactions();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Gagal Mengubah Transaksi';
      // print(_state);
      // print(_message);
      notifyListeners();
    }
  }

  void removeTransaction(int? id, String dateString) async {
    try {
      await _dbHelper.removeTransaction(id);
      DateTime? parsedDateTime = DateTime.tryParse(dateString);

      _setData(parsedDateTime!.month, parsedDateTime.year);
      // _getAllTransactions();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Gagal Menghapus Transaksi';
      notifyListeners();
    }
  }
}
