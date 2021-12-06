import 'package:flutter/material.dart';
import 'package:money_writer_app/common/styles.dart';
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
        if (provider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.noData) {
          return const TotalDefault();
        } else if (provider.state == ResultState.hasData) {
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
              const Divider(thickness: 2),
              Expanded(
                child:
                    // LIST VIEW BUILDER MANUAL

                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemCardData.length,
                        itemBuilder: (BuildContext context, int index) {
                          var listItemTransaction = [];
                          var totalPemasukan = 0;
                          var totalPengeluaran = 0;
                          for (var item in provider.transactionsDay) {
                            if (item.transactionDate ==
                                itemCardData[index].transactionDate) {
                              listItemTransaction.add(item);

                              if (item.type == 'pengeluaran') {
                                totalPengeluaran += item.amount;
                              } else {
                                totalPemasukan += item.amount;
                              }
                            }
                          }
                          DateTime? parsedDate = DateTime.tryParse(
                              itemCardData[index].transactionDate);

                          return Card(
                            elevation: 1,
                            shadowColor: Pallete.tealToDark.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
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
                                  const Divider(thickness: 1),
                                  ListView.builder(
                                    itemCount: listItemTransaction.length,
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        leading: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(listItemTransaction[index]
                                                  .nameCategories
                                                  .toString()),
                                            ],
                                          ),
                                        ),
                                        title: Text(listItemTransaction[index]
                                            .description),
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
                                          Navigator.pushNamed(
                                            context,
                                            TransactionAddUpdatePage.routeName,
                                            arguments:
                                                listItemTransaction[index],
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
        } else if (provider.state == ResultState.error) {
          return Center(child: Text(provider.message));
        } else {
          return const Center();
        }
      },
    );
  }
}
