import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:provider/provider.dart';

// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// late Category category;
late String type = '';
late String name = '';

Future<void> showInformationDialog(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      final _textEditingController = TextEditingController();
      return Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          return AlertDialog(
            title: const Text('Tambah Kategori'),
            // key: _formKey,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textEditingController,
                  onChanged: (String value) {
                    name = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Masukkan Nama Kategori",
                    // hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                const buildRadioButton()
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  // }
                },
                child: const Text('KEMBALI'),
              ),
              TextButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  if (name != '' && type != '') {
                    Navigator.of(context).pop();
                    Category category =
                        Category(id: null, name: name, type: type);
                    provider.addCategory(category);
                    if (provider.state != ResultState.Error) {
                      name = '';
                      type = '';
                    }
                  }
                  // }
                },
                child: const Text('SIMPAN'),
              ),
            ],
          );
        },
      );
    },
  );
}

enum JenisKategori { pemasukan, pengeluaran }

class buildRadioButton extends StatefulWidget {
  const buildRadioButton({
    Key? key,
  }) : super(key: key);

  @override
  State<buildRadioButton> createState() => _buildRadioButtonState();
}

class _buildRadioButtonState extends State<buildRadioButton> {
  JenisKategori? _jenis;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<JenisKategori>(
          value: JenisKategori.pemasukan,
          groupValue: _jenis,
          onChanged: (JenisKategori? value) {
            setState(() {
              _jenis = value;
              print(_jenis);
              type = 'pemasukan';
              print(type);
            });
          },
        ),
        Text('Pemasukan'),
        // Spacer(),
        Radio<JenisKategori>(
          value: JenisKategori.pengeluaran,
          groupValue: _jenis,
          onChanged: (JenisKategori? value) {
            setState(() {
              _jenis = value;
              print(_jenis);
              type = 'pengeluaran';
              print(type);
            });
          },
        ),
        Text('Pengeluaran')
      ],
    );
  }
}
