import 'package:flutter/cupertino.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/utils/result_state.dart';

class ChartProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;
  DateTime date = DateTime.now();

  ChartProvider() {
    _dbHelper = DatabaseHelper();

    getTotalInMonthForChart(date.month, date.year);
  }

  late ResultState _state = ResultState.Loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<TotalTransactions> _totalInMonth = [];
  List<TotalTransactions> get totalInMonth => _totalInMonth;

  Future<void> getTotalInMonthForChart(int month, int year) async {
    _totalInMonth = await _dbHelper.getTotalInMonth(month, year);
    print(_totalInMonth);
    if (_totalInMonth.isNotEmpty) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Tidak Ada Data';
    }
    notifyListeners();
  }
}
