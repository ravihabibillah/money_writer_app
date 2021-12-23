import 'package:flutter/material.dart';
import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/ui/category/add_update_category_dialog.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:money_writer_app/widgets/category_card.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  static const routeName = '/category_page';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showInformationDialog(
                  context, Category(id: null, name: '', type: ''));
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Creates border
                    color:
                        _tabController.index == 0 ? Colors.red : Colors.blue),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    text: "Pengeluaran",
                  ),
                  Tab(
                    text: "Pemasukan",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildListCategory(true), // list pengeluaran
                  _buildListCategory(false), // list pemasukan
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCategory(bool isPengeluaran) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (isPengeluaran) {
          if (provider.statePengeluaran == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.statePengeluaran == ResultState.hasData) {
            return ListView.builder(
              itemCount: provider.categoriesPengeluaran.length,
              itemBuilder: (context, index) {
                return CardCategory(
                  category: provider.categoriesPengeluaran[index],
                  provider: provider,
                );
              },
            );
          } else {
            return Center(
              child: Text(provider.message),
            );
          }
        } else {
          if (provider.statePemasukan == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.statePemasukan == ResultState.hasData) {
            return ListView.builder(
              itemCount: provider.categoriesPemasukan.length,
              itemBuilder: (context, index) {
                return CardCategory(
                  category: provider.categoriesPemasukan[index],
                  provider: provider,
                );
              },
            );
          } else {
            return Center(
              child: Text(provider.message),
            );
          }
        }
      },
    );
  }
}
