import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:provider/provider.dart';

class PieChartTransactions extends StatefulWidget {
  const PieChartTransactions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartTransactionsState();
}

class PieChartTransactionsState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Consumer<TransactionsProvider>(builder: (context, provider, child) {
              return Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 50,
                      // sections: showingSections(),
                      sections: showingTransactions(provider),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingTransactions(TransactionsProvider provider) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      if (provider.state == ResultState.Loading) {
        return PieChartSectionData(
          color: const Color(0xffff0000),
          value: 100,
          title: 'Loading',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      } else if (provider.state == ResultState.NoData) {
        return PieChartSectionData(
          color: const Color(0xffff0000),
          value: 100,
          title: 'Tidak ada Data',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
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
        var percentTotalPemasukanPerbulan = totalPemasukanPerbulan /
            (totalPengeluaranPerbulan + totalPemasukanPerbulan) *
            100;
        var percentTotalPengeluaranPerbulan = totalPengeluaranPerbulan /
            (totalPengeluaranPerbulan + totalPemasukanPerbulan) *
            100;
        print(
            '$percentTotalPemasukanPerbulan - $percentTotalPengeluaranPerbulan');
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: percentTotalPemasukanPerbulan,
              title: '$totalPemasukanPerbulan',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xffff0000),
              value: percentTotalPengeluaranPerbulan,
              title: '$totalPengeluaranPerbulan',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          default:
            throw Error();
        }
      } else if (provider.state == ResultState.Error) {
        return PieChartSectionData(
          color: const Color(0xffff0000),
          value: 100,
          title: 'Error',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      } else {
        return PieChartSectionData(
          color: const Color(0xff0293ee),
          value: 100,
          title: 'Null',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      }
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 50,
            title: '50%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 50,
            title: '50%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
