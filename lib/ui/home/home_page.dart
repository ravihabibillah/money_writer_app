import 'package:flutter/material.dart';
import 'package:money_writer_app/common/styles.dart';
import 'package:money_writer_app/ui/category/category_page.dart';
import 'package:money_writer_app/ui/chart/chart_page.dart';
import 'package:money_writer_app/ui/home/transaction_add_update_page.dart';
import 'package:money_writer_app/ui/report/report_format_page.dart';
import 'package:money_writer_app/widgets/homepage_bottom_bar.dart';
import 'package:money_writer_app/widgets/homepage_transaction_list.dart';

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
              showExportDialog(context);
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
      bottomNavigationBar: const BuildBottomAppbar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, TransactionAddUpdatePage.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
