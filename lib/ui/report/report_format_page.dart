import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
                        _dateControllerDari.text, _dateControllerSampai.text);

                    // Konversi ke PDF
                    saveToPDF(
                        _dateControllerDari.text,
                        _dateControllerSampai.text,
                        type,
                        title,
                        provider.transactionsExport);
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

  Future<void> saveToPDF(String dateFrom, String dateTo, String type,
      String title, List<Transactions> transactionsExport) async {
    int index = 1;

    if (transactionsExport.isNotEmpty) {
      final filename = 'Ekspor Data $type $dateFrom-$dateTo.pdf';
      final absolutePath = '/storage/emulated/0/Download/$filename';

      var totalPemasukan = 0;
      var totalPengeluaran = 0;

      DateTime? parsedDateFrom = DateTime.tryParse(dateFrom);
      DateTime? parsedDateTo = DateTime.tryParse(dateTo);

      for (var item in transactionsExport) {
        if (item.type == 'pengeluaran') {
          totalPengeluaran += item.amount;
        } else {
          totalPemasukan += item.amount;
        }
      }

      try {
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Center(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(24),
                      child: pw.Text(
                        title,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                  pw.Divider(
                    borderStyle: pw.BorderStyle.solid,
                    thickness: 1,
                  ),
                  pw.Row(
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Tanggal'),
                          pw.Text('Pengeluaran'),
                          pw.Text('Pemasukan'),
                          pw.Text('Saldo'),
                        ],
                      ),
                      pw.SizedBox(width: 10),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              ': ${DateFormat("d MMM yyyy", "id_ID").format(parsedDateFrom!)} - ${DateFormat("d MMM yyyy", "id_ID").format(parsedDateTo!)}'),
                          pw.Text(
                              ': Rp ${NumberFormat("#,##0", 'id_ID').format(totalPengeluaran)}'),
                          pw.Text(
                              ': Rp ${NumberFormat("#,##0", 'id_ID').format(totalPemasukan)}'),
                          pw.Text(
                              ': Rp ${NumberFormat("#,##0", 'id_ID').format(totalPemasukan - totalPengeluaran)}'),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Table(
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border.symmetric(
                            horizontal: pw.BorderSide(width: 1),
                          ),
                        ),
                        children: [
                          pw.Text('No',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Tanggal',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Transaksi',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Pengeluaran',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Pemasukan',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Kategori',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      for (var item in transactionsExport)
                        if (item.type == type.toLowerCase() ||
                            type.toLowerCase() == 'semua')
                          pw.TableRow(
                            children: [
                              pw.Text('${index++}'),
                              pw.Text(DateFormat("d MMM yyyy", "id_ID").format(
                                  DateTime.tryParse(item.transactionDate)!)),
                              pw.Text(item.description),
                              pw.Text(item.type == 'pengeluaran'
                                  ? 'Rp ${NumberFormat("#,##0", 'id_ID').format(item.amount)}'
                                  : 'Rp 0'),
                              pw.Text(item.type == 'pemasukan'
                                  ? 'Rp ${NumberFormat("#,##0", 'id_ID').format(item.amount)}'
                                  : 'Rp 0'),
                              pw.Text(item.nameCategories),
                            ],
                          ),
                    ],
                  ),
                ],
              );
            },
          ),
        );

        final file = File(absolutePath);
        await file.writeAsBytes(await pdf.save());

        // Alert Dialog Berhasil
        _showAlertDialog(context, 'Berhasil Disimpan',
            'Berhasil menyimpan File $filename dalam Folder Downloads');
      } catch (e) {
        // Alert Dialog Error/Gagal
        _showAlertDialog(
            context, 'Gagal Disimpan', 'Gagal menyimpan File $filename');
      }
    } else {
      // // Alert Dialog Data Kosong
      _showAlertDialog(context, 'Data Tidak Ditemukan',
          'Proses Ekspor Gagal karena data tidak ada');
    }
  }

  void _showAlertDialog(
      BuildContext context, String title, String description) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            OutlinedButton(
              child: const Text("Oke"),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
