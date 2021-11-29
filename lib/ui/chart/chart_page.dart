import 'package:flutter/material.dart';
import 'package:money_writer_app/ui/chart/PieChartTransactions.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
              child: Column(
                children: [
                  PieChartTransactions(),
                  const Divider(),
                  ListTile(
                    leading: Text('(85%)'),
                    title: Text('Pengeluaran'),
                    trailing: Text('Rp. 850.000'),
                  ),
                  ListTile(
                    leading: Text('(15%)'),
                    title: Text('Pemasukan'),
                    trailing: Text('Rp. 150.000'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
