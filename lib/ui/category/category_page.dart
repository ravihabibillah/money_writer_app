import 'package:flutter/material.dart';
import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/ui/category/add_update_category_dialog.dart';
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
  bool typePengeluaran = true;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Pengeluaran'),
                  style: ElevatedButton.styleFrom(
                    primary: typePengeluaran ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      typePengeluaran = true;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  child: Text('Pemasukan'),
                  style: ElevatedButton.styleFrom(
                    primary: !typePengeluaran ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      typePengeluaran = false;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: typePengeluaran
                    ? _buildListPengeluaran()
                    : _buildListPemasukan(),
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
        if (provider.statePemasukan == ResultState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.statePemasukan == ResultState.HasData) {
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
      },
    );
  }

  Widget _buildListPengeluaran() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.statePengeluaran == ResultState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.statePengeluaran == ResultState.HasData) {
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
      },
    );
  }
}

class CardCategory extends StatelessWidget {
  final Category category;
  final CategoryProvider provider;

  const CardCategory({
    Key? key,
    required this.category,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child:
                    Text(category.name, style: const TextStyle(fontSize: 15)),
              ),
            ),
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(Icons.edit),
              ),
              onTap: () {
                showInformationDialog(context, category);
              },
            ),
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(Icons.delete_forever),
              ),
              onTap: () {
                showAlertDialog(BuildContext context) {
                  // set up the button
                  Widget okButton = OutlinedButton(
                    child: Text("Tetap Hapus"),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.red,
                    ),
                    onPressed: () {
                      provider.removeCategory(category.id);
                      Navigator.of(context).pop();
                    },
                  );

                  Widget cancelButton = ElevatedButton(
                    child: Text("Batal"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("HAPUS"),
                    content: Text("Anda yakin ingin menghapus Kategori ini ?"),
                    actions: [
                      cancelButton,
                      okButton,
                    ],
                  );
                  // show the dialog
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }

                return showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
