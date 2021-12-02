import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:money_writer_app/widgets/chartpage_month_picker.dart';
import 'package:money_writer_app/widgets/chartpage_piechart_transactions.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatelessWidget {
  static const routeName = '/chart_page';

  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ChartMonthPicker(),
          Expanded(
            child: Consumer<TransactionsProvider>(
              builder: (context, provider, child) {
                if (provider.state == ResultState.Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.state == ResultState.NoData) {
                  return const Center(child: Text("Belum Ada Data"));
                } else if (provider.state == ResultState.HasData) {
                  var totalPemasukanPerbulan = 0;
                  var totalPengeluaranPerbulan = 0;
                  var percentTotalPengeluaranPerbulan = 0;
                  var percentTotalPemasukanPerbulan = 0;

                  if (provider.totalInMonth.isNotEmpty) {
                    for (var item in provider.totalInMonth) {
                      if (item.type == 'pengeluaran') {
                        totalPengeluaranPerbulan = item.total;
                      } else {
                        totalPemasukanPerbulan = item.total;
                      }
                    }

                    // Perhitungan Total Pengeluaran & Pemasukan Perbulan
                    // menjadi Persen
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

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        PieChartTransactions(
                          percentPemasukan: percentTotalPemasukanPerbulan,
                          percentPengeluaran: percentTotalPengeluaranPerbulan,
                        ),
                        const Divider(),
                        ListTile(
                          leading: Text('($percentTotalPengeluaranPerbulan%)'),
                          title: const Text('Pengeluaran'),
                          trailing: Text(
                            'Rp. ${NumberFormat("#,##0", 'id_ID').format(totalPengeluaranPerbulan)}',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Text('($percentTotalPemasukanPerbulan%)'),
                          title: const Text('Pemasukan'),
                          trailing: Text(
                            'Rp. ${NumberFormat("#,##0", 'id_ID').format(totalPemasukanPerbulan)}',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (provider.state == ResultState.Error) {
                  return Center(child: Text(provider.message));
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
