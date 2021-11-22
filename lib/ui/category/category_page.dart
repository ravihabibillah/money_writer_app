import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  static const routeName = '/category_page';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
      ),
      body: Center(
        child: Text('Category Page'),
      ),
    );
  }
}
