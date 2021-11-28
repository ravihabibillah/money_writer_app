import 'package:flutter/material.dart';
import 'package:money_writer_app/data/model/category.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:provider/provider.dart';

enum JenisKategori { pemasukan, pengeluaran }

Future<void> showInformationDialog(
    BuildContext context, Category category) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CustomDialog(category: category);
    },
  );
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  JenisKategori? _jenis = JenisKategori.pengeluaran;

  final _formKey = GlobalKey<FormState>();
  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    checkCategory();

    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue:
                      widget.category.name == '' ? null : widget.category.name,
                  autofocus: true,
                  onChanged: (String value) {
                    setState(() {
                      widget.category.name = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama Kategori",
                    labelText: "Nama Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama Kategori tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  'Jenis Kategori : ',
                  style: TextStyle(fontSize: 16),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Radio<JenisKategori>(
                        value: JenisKategori.pengeluaran,
                        groupValue: _jenis,
                        onChanged: (JenisKategori? value) {
                          setState(() {
                            _jenis = value;
                          });
                        },
                      ),
                      const Text(
                        'Pengeluaran',
                        style: TextStyle(fontSize: 14),
                      ),
                      Radio<JenisKategori>(
                        value: JenisKategori.pemasukan,
                        groupValue: _jenis,
                        onChanged: (JenisKategori? value) {
                          setState(() {
                            _jenis = value;
                          });
                        },
                      ),
                      const Text(
                        'Pemasukan',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('KEMBALI'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isUpdate) {
                    provider.updateCategory(widget.category);
                  } else {
                    if (_jenis == JenisKategori.pengeluaran) {
                      widget.category.type = 'pengeluaran';
                    } else {
                      widget.category.type = 'pemasukan';
                    }
                    provider.addCategory(widget.category);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('SIMPAN'),
            ),
          ],
        );
      },
    );
  }

  void checkCategory() {
    // jika id null, maka posisi data baru,
    // jika tidak null berarti data update
    if (widget.category.id != null) {
      if (widget.category.type == 'pengeluaran') {
        _jenis = JenisKategori.pengeluaran;
      } else {
        _jenis = JenisKategori.pemasukan;
      }
      isUpdate = true;
    }
  }
}
