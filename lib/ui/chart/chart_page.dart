import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/ui/chart/pie_chart_transactions.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatelessWidget {
  static const routeName = '/chart_page';

  const ChartPage({Key? key}) : super(key: key);

  // DateTime? selectedDate;

  // @override
  // void initState() {
  //   super.initState();
  //   selectedDate = DateTime.now();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MonthPickerChart(),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<TransactionsProvider>(
                builder: (context, provider, child) {
                  if (provider.state == ResultState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (provider.state == ResultState.NoData) {
                    return Center(child: Text("Belum Ada Data"));
                  } else if (provider.state == ResultState.HasData) {
                    var totalPemasukanPerbulan = 0;
                    var totalPengeluaranPerbulan = 0;
                    var percentTotalPengeluaranPerbulan = 0;
                    var percentTotalPemasukanPerbulan = 0;

                    if (provider.totalInMonth.length > 0) {
                      for (var item in provider.totalInMonth) {
                        if (item.type == 'pengeluaran') {
                          totalPengeluaranPerbulan = item.total;
                        } else {
                          totalPemasukanPerbulan = item.total;
                        }
                      }
                      // persen
                      percentTotalPengeluaranPerbulan =
                          (totalPengeluaranPerbulan /
                                  (totalPengeluaranPerbulan +
                                      totalPemasukanPerbulan) *
                                  100)
                              .toInt();
                      percentTotalPemasukanPerbulan = (totalPemasukanPerbulan /
                              (totalPengeluaranPerbulan +
                                  totalPemasukanPerbulan) *
                              100)
                          .toInt();
                    }

                    return Column(
                      children: [
                        PieChartTransactions(
                          percentPemasukan: percentTotalPemasukanPerbulan,
                          percentPengeluaran: percentTotalPengeluaranPerbulan,
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                              Text('(${percentTotalPengeluaranPerbulan}%)'),
                          title: Text('Pengeluaran'),
                          trailing: Text(
                            'Rp. $totalPengeluaranPerbulan',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Text('(${percentTotalPemasukanPerbulan}%)'),
                          title: Text('Pemasukan'),
                          trailing: Text(
                            'Rp. $totalPemasukanPerbulan',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (provider.state == ResultState.Error) {
                    return Center(child: Text(provider.message));
                  } else {
                    return const Center();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthPickerChart extends StatefulWidget {
  const MonthPickerChart({Key? key}) : super(key: key);

  @override
  _MonthPickerChartState createState() => _MonthPickerChartState();
}

class _MonthPickerChartState extends State<MonthPickerChart> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(builder: (context, provider, child) {
      return Material(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(
                      selectedDate!.year,
                      selectedDate!.month - 1,
                    );
                  });
                  getData(provider);
                },
              ),
              TextButton(
                child: Text(
                  DateFormat("MMMM yyyy", "id_ID").format(selectedDate!),
                  // 'Month: ${selectedDate?.month} - ${selectedDate?.year}',
                ),
                onPressed: () {
                  showMonthPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 10, 5),
                    lastDate: DateTime(DateTime.now().year + 1, 9),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                      getData(provider);
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(
                      selectedDate!.year,
                      selectedDate!.month + 1,
                    );
                  });
                  getData(provider);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void getData(TransactionsProvider provider) {
    provider.getTotalInMonth(selectedDate!.month, selectedDate!.year);
  }
}
