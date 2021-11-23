import 'package:flutter/material.dart';
import 'package:money_writer_app/ui/category/category_page.dart';
import 'package:money_writer_app/ui/chart/chart_page.dart';
import 'package:money_writer_app/ui/home/transaction_add_update_page.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Writer'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Route Laporan Transaksi (Report)
            },
          ),
          IconButton(
            icon: Icon(Icons.text_snippet),
            onPressed: () {
              Navigator.pushNamed(context, CategoryPage.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.pushNamed(context, ChartPage.routeName);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Pemasukan',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Rp. 15.000',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Pengeluaran',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Rp. 15.000',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Saldo',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 8.0),
                        Text('Rp. 15.000'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                // contoh check data pengeluaran atau pemasukan
                var isPengeluaran = true;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Minggu, 3 Nov 2021',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rp. 10.000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                'Rp. 15.000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        ListView.builder(
                          itemCount: 5,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            // contoh check data pengeluaran atau pemasukan
                            isPengeluaran = !isPengeluaran;
                            return ListTile(
                              leading: Text('Makanan'),
                              title: Text('Nasi'),
                              trailing: Text(
                                'Rp. 15.000',
                                style: TextStyle(
                                  // terapkan check data pengeluaran atau pemasukan
                                  color:
                                      isPengeluaran ? Colors.red : Colors.blue,
                                ),
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: buildBottomAppbar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, TransactionAddUpdatePage.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class buildBottomAppbar extends StatefulWidget {
  const buildBottomAppbar({
    Key? key,
  }) : super(key: key);

  @override
  State<buildBottomAppbar> createState() => _buildBottomAppbarState();
}

class _buildBottomAppbarState extends State<buildBottomAppbar> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
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
                locale: Locale("id"),
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
            icon: Icon(Icons.chevron_right),
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
    );
  }
}
