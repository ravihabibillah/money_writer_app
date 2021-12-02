import 'package:flutter/material.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/ui/home/transaction_add_update_page.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:money_writer_app/widgets/default_total.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.NoData) {
          return const TotalDefault();
        } else if (provider.state == ResultState.HasData) {
          var itemCardData = provider.transactionsMonth;
          var totalPemasukanPerbulan = 0;
          var totalPengeluaranPerbulan = 0;
          if (provider.totalInMonth.isNotEmpty) {
            for (var item in provider.totalInMonth) {
              if (item.type == 'pengeluaran') {
                totalPengeluaranPerbulan = item.total;
              } else {
                totalPemasukanPerbulan = item.total;
              }
            }
          }
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
                            'Rp ${NumberFormat("#,##0", 'id_ID').format(totalPemasukanPerbulan)}',
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
                            'Rp ${NumberFormat("#,##0", 'id_ID').format(totalPengeluaranPerbulan)}',
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
                          Text(
                              'Rp. ${NumberFormat("#,##0", 'id_ID').format(totalPemasukanPerbulan - totalPengeluaranPerbulan)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child:
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
                          DateTime? parsedDate = DateTime.tryParse(
                              itemCardData[index].transaction_date);

                          // parseDate(itemCardData[index].transaction_date);

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      DateFormat("EEEE, d MMM yyyy", "id_ID")
                                          .format(parsedDate!),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp. ${NumberFormat("#,##0", 'id_ID').format(totalPemasukan)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Text(
                                          'Rp. ${NumberFormat("#,##0", 'id_ID').format(totalPengeluaran)}',
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

                                        trailing: Text(
                                          'Rp. ${NumberFormat("#,##0", 'id_ID').format(listItemTransaction[index].amount)}',
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
          return const Center();
        }
      },
    );
  }

  // void parseDate(String transaction_date) {
  //   DateTime? parsedDate = DateTime.tryParse(transaction_date);
  //   var month
  //   if()
  // }
}
