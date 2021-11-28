import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/ui/category/category_page.dart';
import 'package:money_writer_app/ui/chart/chart_page.dart';
import 'package:money_writer_app/ui/home/transaction_add_update_page.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Consumer<TransactionsProvider>(
    //   builder: (context, provider, child) {
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
      bottomNavigationBar: const buildBottomAppbar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, TransactionAddUpdatePage.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
    //   },
    // );
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
    return Consumer<TransactionsProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.NoData) {
          return Center(child: Text("Belum Ada Data"));
        } else if (provider.state == ResultState.HasData) {
          var itemCardData = provider.transactionsMonth;
          // print("TOTAL: ${provider.totalInMonth}");

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
                            provider.totalInMonth.isEmpty
                                ? 'Rp. 0'
                                : 'Rp. ${provider.totalInMonth[0].total}',
                            style: const TextStyle(
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
                            provider.totalInMonth.isEmpty
                                ? 'Rp. 0'
                                : 'Rp. ${provider.totalInMonth[1].total}',
                            style: const TextStyle(
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
              const Divider(),
              Expanded(
                child:

                    // GROUPEDLISTVIEW

                    //     GroupedListView<dynamic, String>(
                    //   elements: provider.transactionsMonth,
                    //   groupBy: (element) => element.transaction_date,
                    //   // groupComparator: (value1, value2) => value2.compareTo(value1),
                    //   order: GroupedListOrder.DESC,
                    //   groupSeparatorBuilder: (String value) {
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             value,
                    //             style: Theme.of(context).textTheme.headline6,
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 16.0, vertical: 4.0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Rp. 0',
                    //                   style: const TextStyle(
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 16.0,
                    //                     color: Colors.blue,
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   'Rp. 0',
                    //                   style: const TextStyle(
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 16.0,
                    //                     color: Colors.red,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Divider(),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    //   itemBuilder: (c, element) {
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           ListTile(
                    //             leading: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Text(element.name_categories.toString()),
                    //               ],
                    //             ),
                    //             title: Text(element.description),

                    //             /**
                    //                            * properti subtitle hanya percobaan
                    //                            * untuk menampilkan data type dan transaction_date
                    //                            */
                    //             subtitle: Text(
                    //                 element.type + ' : ' + element.transaction_date),
                    //             trailing: Text(
                    //               element.amount.toString(),
                    //               style: TextStyle(
                    //                 // terapkan check data pengeluaran atau pemasukan
                    //                 color: element.type == 'pengeluaran'
                    //                     ? Colors.red
                    //                     : Colors.blue,
                    //               ),
                    //             ),
                    //             onTap: () {
                    //               // final selectedTransaction =
                    //               //     await provider.getTransactionById(
                    //               //         provider.transactions[index].id!);

                    //               Navigator.pushNamed(
                    //                 context,
                    //                 TransactionAddUpdatePage.routeName,
                    //                 arguments: element,
                    //                 // arguments: Transactions(
                    //                 //   id: null,
                    //                 //   description: provider
                    //                 //       .transactions[index].description,
                    //                 //   amount:
                    //                 //       provider.transactions[index].amount,
                    //                 //   transaction_date: provider
                    //                 //       .transactions[index]
                    //                 //       .transaction_date,
                    //                 //   id_categories: provider
                    //                 //       .transactions[index].id_categories,
                    //                 //   type: provider.transactions[index].type,
                    //                 // ),
                    //               );
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),

                    // LIST VIEW BUILDER MANUAL

                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemCardData.length,
                        itemBuilder: (BuildContext context, int index) {
                          // contoh check data pengeluaran atau pemasukan

                          var listItemTransaction = [];
                          var totalPemasukan = 0;
                          var totalPengeluaran = 0;
                          for (var item in provider.transactionsDay) {
                            if (item.transaction_date ==
                                itemCardData[index].transaction_date) {
                              listItemTransaction.add(item);

                              if (item.type == 'pengeluaran') {
                                totalPengeluaran += item.amount;
                              } else {
                                totalPemasukan += item.amount;
                              }
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp. $totalPemasukan',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Text(
                                          'Rp. $totalPengeluaran',
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // contoh check data pengeluaran atau pemasukan
                                      // isPengeluaran = !isPengeluaran;

                                      return ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(listItemTransaction[index]
                                                .name_categories
                                                .toString()),
                                          ],
                                        ),
                                        title: Text(listItemTransaction[index]
                                            .description),

                                        /**
                                   * properti subtitle hanya percobaan
                                   * untuk menampilkan data type dan transaction_date
                                   */
                                        subtitle: Text(
                                            listItemTransaction[index].type +
                                                ' : ' +
                                                listItemTransaction[index]
                                                    .transaction_date),
                                        trailing: Text(
                                          listItemTransaction[index]
                                              .amount
                                              .toString(),
                                          style: TextStyle(
                                            // terapkan check data pengeluaran atau pemasukan
                                            color: listItemTransaction[index]
                                                        .type ==
                                                    'pengeluaran'
                                                ? Colors.red
                                                : Colors.blue,
                                          ),
                                        ),
                                        onTap: () {
                                          // final selectedTransaction =
                                          //     await provider.getTransactionById(
                                          //         provider.transactions[index].id!);

                                          Navigator.pushNamed(
                                            context,
                                            TransactionAddUpdatePage.routeName,
                                            arguments:
                                                listItemTransaction[index],
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
                        }),
              )
            ],
          );
        } else if (provider.state == ResultState.Error) {
          return Center(child: Text(provider.message));
        } else {
          return Center();
        }
      },
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
    return Consumer<TransactionsProvider>(
      builder: (context, provider, child) {
        provider.setAllTransactionsbyMonth(
            selectedDate!.month, selectedDate!.year);
        // provider.setAllTransactionsbyDay(
        //     selectedDate!.month, selectedDate!.year);
        // provider.getTotalInMonth(selectedDate!.month, selectedDate!.year);

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
                    provider.getTotalInMonth(
                        selectedDate!.month, selectedDate!.year);
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
                      provider.getTotalInMonth(
                          selectedDate!.month, selectedDate!.year);
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
                  provider.getTotalInMonth(
                      selectedDate!.month, selectedDate!.year);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
