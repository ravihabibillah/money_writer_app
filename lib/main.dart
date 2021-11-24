import 'package:flutter/material.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_writer_app/ui/home/transaction_add_update_page.dart';

import 'common/styles.dart';
import 'ui/category/category_page.dart';
import 'ui/chart/chart_page.dart';
import 'ui/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(databaseHelper: DatabaseHelper()),
        )
      ],
      child: MaterialApp(
        title: 'Money Writer',
        theme: buildTheme(),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          CategoryPage.routeName: (context) => CategoryPage(),
          ChartPage.routeName: (context) => ChartPage(),
          TransactionAddUpdatePage.routeName: (context) =>
              TransactionAddUpdatePage(),
        },
      ),
    );
  }
}
