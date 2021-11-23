import 'package:flutter/material.dart';
import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/ui/category/add_category_dialog.dart';
import 'package:money_writer_app/utils/result_state.dart';
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
            icon: Icon(Icons.add),
            onPressed: () async {
              await showInformationDialog(context);
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
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                ),
                tabs: [
                  Tab(child: Text('Pemasukan')),
                  Tab(child: Text('Pengeluaran')),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListPemasukan(),
                    _buildListPengeluaran(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListPemasukan() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.statePemasukan == ResultState.HasData) {
          return ListView.builder(
            itemCount: provider.categoriesPemasukan.length,
            itemBuilder: (context, index) {
              return CardCategory(
                  category: provider.categoriesPemasukan[index]);
            },
          );
        } else {
          return Center(
            child: Text(provider.message),
          );
        }
      },
    );
  }

  Widget _buildListPengeluaran() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.statePengeluaran == ResultState.HasData) {
          return ListView.builder(
            itemCount: provider.categoriesPengeluaran.length,
            itemBuilder: (context, index) {
              return CardCategory(
                  category: provider.categoriesPengeluaran[index]);
            },
          );
        } else {
          return Center(
            child: Text(provider.message),
          );
        }
      },
    );
  }
}

class CardCategory extends StatelessWidget {
  Category category;

  CardCategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(child: Text(category.name)),
            Icon(Icons.edit),
            Icon(Icons.delete_forever),
          ],
        ),
      ),
    );
  }
}
