import 'package:flutter/material.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BuildBottomAppbar extends StatefulWidget {
  const BuildBottomAppbar({
    Key? key,
  }) : super(key: key);

  @override
  State<BuildBottomAppbar> createState() => _BuildBottomAppbarState();
}

class _BuildBottomAppbarState extends State<BuildBottomAppbar> {
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
                    getData(provider);
                  });
                },
              ),
              TextButton(
                child: Text(
                  DateFormat("MMMM yyyy", "id_ID").format(selectedDate!),
                  // 'Month: ${selectedDate?.month} - ${selectedDate?.year}',
                ),
                onPressed: () {
                  showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 10, 5),
                    lastDate: DateTime(DateTime.now().year + 1, 9),
                    initialDate: selectedDate ?? DateTime.now(),
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
        );
      },
    );
  }

  void getData(TransactionsProvider provider) {
    provider.setAllTransactionsbyMonth(selectedDate!.month, selectedDate!.year);

    provider.getTotalInMonth(selectedDate!.month, selectedDate!.year);
  }
}
