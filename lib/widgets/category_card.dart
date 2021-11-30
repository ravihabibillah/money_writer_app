import 'package:flutter/material.dart';
import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/ui/category/add_update_category_dialog.dart';

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
                provider.removeCategory(category.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
