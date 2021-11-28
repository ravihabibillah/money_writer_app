import 'package:flutter/material.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/ui/category/category_page.dart';
import 'package:money_writer_app/ui/chart/chart_page.dart';
import 'package:money_writer_app/ui/home/transaction_add_update_page.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

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
            icon: const Icon(Icons.download),
            onPressed: () {
              // Route Laporan Transaksi (Report)
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_snippet),
            onPressed: () {
              Navigator.pushNamed(context, CategoryPage.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.pushNamed(context, ChartPage.routeName);
            },
          ),
        ],
      ),
      body: const TransactionListPerDay(),
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

class TransactionListPerDay extends StatefulWidget {
  const TransactionListPerDay({Key? key}) : super(key: key);

  @override
  _TransactionListPerDayState createState() => _TransactionListPerDayState();
}

class _TransactionListPerDayState extends State<TransactionListPerDay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          child: Container(
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
                    const SizedBox(height: 8.0),
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
                    const SizedBox(height: 8.0),
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
                    const SizedBox(height: 8.0),
                    Text('Rp. 15.000'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Expanded(child:
            Consumer<TransactionsProvider>(builder: (context, provider, child) {
          // provider.setAllTransactionsbyDay(
          //     provider.transactionsMonth[index].transaction_date);
          var itemCardData = provider.transactionsMonth;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: itemCardData.length,
            itemBuilder: (BuildContext context, int index) {
              // contoh check data pengeluaran atau pemasukan
              var isPengeluaran = true;
              // provider.setAllTransactionsbyDay(
              //     provider.transactionsMonth[index].transaction_date);
              var listItemTransaction = [];
              for (var item in provider.transactionsDay) {
                if (item.transaction_date ==
                    itemCardData[index].transaction_date) {
                  listItemTransaction.add(item);
                }
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        itemCardData[index].transaction_date,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp. 0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              'Rp. 0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ListView.builder(
                        itemCount: listItemTransaction.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          // contoh check data pengeluaran atau pemasukan
                          isPengeluaran = !isPengeluaran;

                          return ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(listItemTransaction[index]
                                    .name_categories
                                    .toString()),
                              ],
                            ),
                            title: Text(listItemTransaction[index].description),

                            /**
                                   * properti subtitle hanya percobaan
                                   * untuk menampilkan data type dan transaction_date
                                   */
                            subtitle: Text(listItemTransaction[index].type +
                                ' : ' +
                                listItemTransaction[index].transaction_date),
                            trailing: Text(
                              listItemTransaction[index].amount.toString(),
                              style: TextStyle(
                                // terapkan check data pengeluaran atau pemasukan
                                color: isPengeluaran ? Colors.red : Colors.blue,
                              ),
                            ),
                            onTap: () {
                              // final selectedTransaction =
                              //     await provider.getTransactionById(
                              //         provider.transactions[index].id!);

                              Navigator.pushNamed(
                                context,
                                TransactionAddUpdatePage.routeName,
                                arguments: listItemTransaction[index],
                                // arguments: Transactions(
                                //   id: null,
                                //   description: provider
                                //       .transactions[index].description,
                                //   amount:
                                //       provider.transactions[index].amount,
                                //   transaction_date: provider
                                //       .transactions[index]
                                //       .transaction_date,
                                //   id_categories: provider
                                //       .transactions[index].id_categories,
                                //   type: provider.transactions[index].type,
                                // ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }))
      ],
    );
  }

  // Future<void> setTotal(TransactionsProvider provider) async {
  //   setState(() {
  //     provider.transactions.forEach(
  //       (transaction) {
  //         if (transaction.type == 'pengeluaran') {
  //           totalPengeluaranPerDate += transaction.amount;
  //         } else {
  //           totalPemasukanPerDate += transaction.amount;
  //         }
  //       },
  //     );
  //   });

  //   totalPengeluaranPerDate = 0;
  //   totalPemasukanPerDate = 0;
  // }
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
    return Consumer<TransactionsProvider>(
      builder: (context, provider, child) {
        provider.setAllTransactionsbyMonth(
            selectedDate!.month, selectedDate!.year);
        provider.setAllTransactionsbyDay(
            selectedDate!.month, selectedDate!.year);

        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
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
        );
      },
    );
  }
}
