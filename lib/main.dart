import 'package:flutter/material.dart';
import 'package:money_writer_app/data/db/database_helper.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/provider/chart_provider.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/ui/home/transaction_add_update_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'common/styles.dart';
import 'ui/category/category_page.dart';
import 'ui/chart/chart_page.dart';
import 'ui/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
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
        ),
        ChangeNotifierProvider<TransactionsProvider>(
          create: (_) => TransactionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Money Writer',
        theme: buildTheme(context),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          CategoryPage.routeName: (context) => const CategoryPage(),
          ChartPage.routeName: (context) => const ChartPage(),
          TransactionAddUpdatePage.routeName: (context) {
            if (ModalRoute.of(context)!.settings.arguments != null) {
              return TransactionAddUpdatePage(
                  ModalRoute.of(context)!.settings.arguments as Transactions);
            } else {
              return const TransactionAddUpdatePage();
            }
          }
        },
      ),
    );
  }
}
