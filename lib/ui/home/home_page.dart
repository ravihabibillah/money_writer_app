import 'package:flutter/material.dart';
import 'package:money_writer_app/ui/category/category_page.dart';
import 'package:money_writer_app/ui/chart/chart_page.dart';

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
            icon: Icon(Icons.download),
            onPressed: () {
              // Route Laporan Transaksi (Report)
            },
          ),
          IconButton(
            icon: Icon(Icons.text_snippet),
            onPressed: () {
              Navigator.pushNamed(context, CategoryPage.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.pushNamed(context, ChartPage.routeName);
            },
          ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(100.0),
        //   child: Column(
        //     children: [
        //       Text('Coba'),
        //       Text('Coba'),
        //       Text('Coba'),
        //       Text('Coba'),
        //     ],
        //   ),
        // ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Minggu, 3 Nov 2021',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rp. 10.000',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'Rp. 15.000',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          ListView.builder(
                            itemCount: 2,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Text('Makanan'),
                                title: Text('Nasi'),
                                trailing: Text('Rp. 15.000'),
                                onTap: () {},
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.chevron_left), onPressed: () {}),
            TextButton(
              child: Text('Nov 2021'),
              onPressed: () async {
                final DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2020, 11, 17),
                  firstDate: DateTime(2017, 1),
                  lastDate: DateTime(2022, 7),
                  helpText: 'Select a date',
                );
              },
            ),
            IconButton(icon: Icon(Icons.chevron_right), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
