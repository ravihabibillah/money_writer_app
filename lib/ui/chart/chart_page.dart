import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  static const routeName = '/chart_page';

  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik'),
      ),
      body: Center(
        child: Text('Chart Page'),
      ),
    );
  }
}
