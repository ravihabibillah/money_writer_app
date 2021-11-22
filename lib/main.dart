import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: 'Money Writer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        CategoryPage.routeName: (context) => CategoryPage(),
        ChartPage.routeName: (context) => ChartPage(),
      },
    );
  }
}
