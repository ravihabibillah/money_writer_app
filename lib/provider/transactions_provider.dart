import 'package:flutter/material.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/utils/result_state.dart';

class TransactionsProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;

  TransactionsProvider() {
    _dbHelper = DatabaseHelper();
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
    _transactions = await _dbHelper.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transactions transaction) async {
    await _dbHelper.insertTransaction(transaction);
    _getAllTransactions();
  }
}
