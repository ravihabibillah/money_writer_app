import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/utils/save_pdf.dart';

import 'package:provider/provider.dart';

Future<void> showExportDialog(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return const ExportDialog();
      });
}

class ExportDialog extends StatefulWidget {
  const ExportDialog({Key? key}) : super(key: key);

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  final TextEditingController _dateControllerDari = TextEditingController();
  final TextEditingController _dateControllerSampai = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late String title;
  String dropdownvalue = 'Semua Jenis';
  var dropdownItem = ['Semua Jenis', 'Pengeluaran', 'Pemasukan'];

  @override
  void dispose() {
    _dateControllerDari.dispose();
    _dateControllerSampai.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Ekspor Laporan'),
            content: Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      autofocus: true,
                      onChanged: (String value) {
                        setState(() {
                          title = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Masukkan Judul",
                        labelText: "Judul",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tentukan Tanggal :',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    DateTimeField(
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      controller: _dateControllerDari,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(
                        hintText: "Dari",
                        icon: const Icon(Icons.event),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih tanggal terlebih dahulu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DateTimeField(
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      controller: _dateControllerSampai,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(
                        hintText: "Sampai",
                        icon: const Icon(Icons.event),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih tanggal terlebih dahulu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tentukan Jenis :',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField(
                      value: dropdownvalue,
                      items: dropdownItem.map((String items) {
                        return DropdownMenuItem(
                          child: Text(items),
                          value: items,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalue = newValue as String;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Masukkan Tanggal';
                        }
                        return null;
                      },
                    )
                  ],
                ),
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
                    final String type;
                    if (dropdownvalue == 'Pengeluaran') {
                      type = 'pengeluaran';
                    } else if (dropdownvalue == 'Pemasukan') {
                      type = 'pemasukan';
                    } else {
                      type = 'semua';
                    }

                    provider.getTransactionForExport(
                      context,
                      _dateControllerDari.text,
                      _dateControllerSampai.text,
                      type,
                      title,
                    );
                  }
                },
                child: const Text('EKSPOR'),
              ),
            ],
          ),
        );
      },
    );
  }
}
