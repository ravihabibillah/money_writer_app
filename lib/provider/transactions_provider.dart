import 'package:flutter/material.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/utils/result_state.dart';

class TransactionsProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;

  TransactionsProvider() {
    _dbHelper = DatabaseHelper();
    _getAllTransactions();
  }

  late ResultState _state;
  ResultState get state => _state;

  late ResultState _stateTransaction;
  ResultState get stateTransaction => _stateTransaction;

  String _message = '';
  String get message => _message;

  List<Transactions> _transactions = [];
  List<Transactions> get transactions => _transactions;

  void _getAllTransactions() async {
    _transactions = await _dbHelper.getTransactionsJoinCategory();
    if (_transactions.isNotEmpty) {
      _stateTransaction = ResultState.HasData;
    } else {
      _stateTransaction = ResultState.NoData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }

  Future<void> addTransaction(Transactions transaction) async {
    try {
      await _dbHelper.insertTransaction(transaction);
      _getAllTransactions();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Gagal Menambahkan Transaksi';
      notifyListeners();
    }
  }

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
      _getAllTransactions();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Gagal Mengubah Transaksi';
      print(_state);
      print(_message);
      notifyListeners();
    }
  }

  void removeTransaction(int? id) async {
    try {
      await _dbHelper.removeTransaction(id);
      _getAllTransactions();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Gagal Menghapus Transaksi';
      notifyListeners();
    }
  }
}
