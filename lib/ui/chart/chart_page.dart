import 'package:flutter/material.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  static const routeName = '/chart_page';

  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
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
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Month: ${selectedDate?.month} - ${selectedDate?.year}',
                    ),
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 10, 5),
                        lastDate: DateTime(DateTime.now().year + 1, 9),
                        initialDate: selectedDate ?? DateTime.now(),
                        locale: const Locale("id"),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
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
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<TransactionsProvider>(
                builder: (context, provider, child) {
                  if (provider.state == ResultState.Loading) {
                  } else if (provider.state == ResultState.NoData) {
                  } else if (provider.state == ResultState.HasData) {
                    var totalPemasukanPerbulan = 0;
                    var totalPengeluaranPerbulan = 0;
                    if (provider.totalInMonth.length > 0) {
                      for (var item in provider.totalInMonth) {
                        if (item.type == 'pengeluaran') {
                          totalPengeluaranPerbulan = item.total;
                        } else {
                          totalPemasukanPerbulan = item.total;
                        }
                      }
                    }
                    // persen
                    var percentTotalPengeluaranPerbulan =
                        totalPengeluaranPerbulan /
                            (totalPengeluaranPerbulan +
                                totalPemasukanPerbulan) *
                            100;
                    var percentTotalPemasukanPerbulan = totalPemasukanPerbulan /
                        (totalPengeluaranPerbulan + totalPemasukanPerbulan) *
                        100;
                    return Column(
                      children: [
                        PieChartTransactions(provider: provider),
                        const Divider(),
                        ListTile(
                          leading: Text('($percentTotalPengeluaranPerbulan%)'),
                          title: Text('Pengeluaran'),
                          trailing: Text('Rp. $totalPengeluaranPerbulan'),
                        ),
                        ListTile(
                          leading: Text('($percentTotalPemasukanPerbulan%)'),
                          title: Text('Pemasukan'),
                          trailing: Text('Rp. $totalPemasukanPerbulan'),
                        ),
                      ],
                    );
                  } else if (provider.state == ResultState.Error) {
                  } else {}
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
