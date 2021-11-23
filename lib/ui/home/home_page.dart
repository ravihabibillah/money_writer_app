import 'package:flutter/material.dart';
import 'package:money_writer_app/ui/category/category_page.dart';
import 'package:money_writer_app/ui/chart/chart_page.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
      bottomNavigationBar: buildBottomAppbar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class buildBottomAppbar extends StatefulWidget {
  const buildBottomAppbar({
    Key? key,
  }) : super(key: key);

  @override
  State<buildBottomAppbar> createState() => _buildBottomAppbarState();
}

class _buildBottomAppbarState extends State<buildBottomAppbar> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate!.year,
                  selectedDate!.month - 1,
                );
              });
            },
          ),
          TextButton(
            child: Text(
              'Month: ${selectedDate?.month} - ${selectedDate?.year}',
            ),
            onPressed: () {
              showMonthPicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 10, 5),
                lastDate: DateTime(DateTime.now().year + 1, 9),
                initialDate: selectedDate ?? DateTime.now(),
                locale: Locale("id"),
              ).then((date) {
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate!.year,
                  selectedDate!.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
