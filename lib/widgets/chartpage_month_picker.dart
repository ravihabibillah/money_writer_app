import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/provider/chart_provider.dart';
// import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class ChartMonthPicker extends StatefulWidget {
  const ChartMonthPicker({Key? key}) : super(key: key);

  @override
  _ChartMonthPickerState createState() => _ChartMonthPickerState();
}

class _ChartMonthPickerState extends State<ChartMonthPicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    Provider.of<ChartProvider>(context, listen: false)
        .getTotalInMonthForChart(selectedDate!.month, selectedDate!.year);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartProvider>(builder: (context, provider, child) {
      return Material(
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
                  getData(provider);
                },
              ),
              TextButton(
                child: Text(
                  DateFormat("MMMM yyyy", "id_ID").format(selectedDate!),
                ),
                onPressed: () {
                  showMonthPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 10, 5),
                    lastDate: DateTime(DateTime.now().year + 1, 9),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                      getData(provider);
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
                  getData(provider);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void getData(ChartProvider provider) {
    provider.getTotalInMonthForChart(selectedDate!.month, selectedDate!.year);
  }
}
