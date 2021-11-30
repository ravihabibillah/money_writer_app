import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartTransactions extends StatefulWidget {
  final int percentPemasukan;
  final int percentPengeluaran;

  PieChartTransactions(
      {required this.percentPemasukan,
      required this.percentPengeluaran,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartTransactionsState();
}

class PieChartTransactionsState extends State<PieChartTransactions> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Expanded(
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
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 50,
                // sections: showingSections(),
                sections: showingSections(
                    widget.percentPengeluaran, widget.percentPemasukan),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(int pengeluaran, int pemasukan) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xffff0000),
            value: pengeluaran.toDouble(),
            title: '$pengeluaran%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: pemasukan.toDouble(),
            title: '$pemasukan%',
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
