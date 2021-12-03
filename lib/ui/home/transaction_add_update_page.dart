import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:provider/provider.dart';

class TransactionAddUpdatePage extends StatefulWidget {
  static const routeName = '/transaction_add_update_page';
  final Transactions? transaction;

  const TransactionAddUpdatePage([this.transaction, Key? key])
      : super(key: key);

  @override
  State<TransactionAddUpdatePage> createState() =>
      _TransactionAddUpdatePageState();
}

class _TransactionAddUpdatePageState extends State<TransactionAddUpdatePage> {
  final _transactionFormKey = GlobalKey<FormState>();
  bool _isUpdate = false;
  bool typePengeluaran = true;
  String? dropdownValue;

  // Text Controller
  TextEditingController _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  MoneyMaskedTextController _amountTextController = MoneyMaskedTextController(
      decimalSeparator: '', thousandSeparator: ',', precision: 0);
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.transaction != null) {
      var selectedTransaction = widget.transaction;
      typePengeluaran =
          selectedTransaction!.type == 'pengeluaran' ? true : false;
      _dateController.text = selectedTransaction.transaction_date;
      dropdownValue = selectedTransaction.id_categories.toString();
      _amountTextController.text = selectedTransaction.amount.toString();
      _descriptionController.text = selectedTransaction.description;
      _isUpdate = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _dateController.dispose();
    _amountTextController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String typeTransaction = typePengeluaran ? 'pengeluaran' : 'pemasukan';

    return Consumer<TransactionsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_isUpdate ? 'Ubah Transaksi' : 'Tambah Transaksi'),
            actions: [
              if (_isUpdate)
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {
                    return transactionAddUpdateDialog(provider, context);
                  },
                ),
            ],
          ),
          body: Form(
            key: _transactionFormKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Mengubah kategori
                    _buildTabTypeTransaction(),
                    const SizedBox(height: 16.0),

                    // Tanggal
                    DateTimeField(
                      controller: _dateController,
                      initialValue: DateTime.tryParse(_dateController.text),
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(
                        label: const Text('tanggal'),
                        icon: const Icon(Icons.event),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // kategori
                    Consumer<CategoryProvider>(
                      builder: (context, provider, child) {
                        if (provider.statePengeluaran == ResultState.HasData ||
                            provider.statePemasukan == ResultState.HasData) {
                          // data category
                          var getCategory = typePengeluaran
                              ? provider.categoriesPengeluaran
                              : provider.categoriesPemasukan;

                          var categoryMap =
                              getCategory.map((e) => {e.id: e.name});

                          var categoryMapToDropdownMenuItem =
                              categoryMap.map((entry) {
                            return DropdownMenuItem(
                              value: entry.keys
                                  .toString()
                                  .replaceAll(RegExp(r'[^0-9]'), ''),
                              child: Text(entry.values
                                  .toString()
                                  .replaceAll(RegExp(r'[^0-9\a-z\A-Z\ ]'), '')),
                            );
                          });

                          String? defaultValueDropdown() {
                            if (widget.transaction?.id_categories.toString() !=
                                null) {
                              if (widget.transaction?.type == typeTransaction) {
                                return widget.transaction?.id_categories
                                    .toString();
                              } else {
                                return null;
                              }
                            } else {
                              dropdownValue =
                                  categoryMapToDropdownMenuItem.first.value;
                              return categoryMapToDropdownMenuItem.first.value;
                            }
                          }

                          return DropdownButtonFormField(
                            items: categoryMapToDropdownMenuItem.toList(),
                            value: defaultValueDropdown(),
                            onChanged: (newValue) {
                              dropdownValue = newValue as String?;
                              print('onChanged : ' + dropdownValue!);
                            },
                            decoration: InputDecoration(
                              label: const Text('Kategori'),
                              icon: const Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          );
                        } else {
                          return Center(
                            child: Text(provider.message),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Jumlah Uang
                    TextFormField(
                      controller: _amountTextController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: 'Rp. ',
                        label: const Text('Jumlah'),
                        icon: const Icon(Icons.money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Keterangan
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        label: const Text('Keterangan'),
                        icon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    ElevatedButton(
                      child: const Text('Simpan'),
                      onPressed: () {
                        if (_transactionFormKey.currentState!.validate()) {
                          var idTransaction =
                              _isUpdate ? widget.transaction!.id : null;
                          var amountReplaceThousandSeparator =
                              _amountTextController.text
                                  .replaceAll(RegExp(r'[^0-9\.]'), '');
                          int? amountToInt =
                              int.tryParse(amountReplaceThousandSeparator);

                          Transactions dataTransaction = Transactions(
                              id: idTransaction,
                              description: _descriptionController.text,
                              amount: amountToInt!,
                              transaction_date: _dateController.text,
                              id_categories: int.parse(dropdownValue!),
                              type: typeTransaction);

                          if (!_isUpdate) {
                            provider.addTransaction(dataTransaction);
                          } else {
                            provider.updateTransaction(dataTransaction);
                          }

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabTypeTransaction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('Pengeluaran'),
          style: ElevatedButton.styleFrom(
            primary: typePengeluaran ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              typePengeluaran = true;
            });
          },
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          child: const Text('Pemasukan'),
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
    );
  }

  void transactionAddUpdateDialog(
      TransactionsProvider provider, BuildContext context) {
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = OutlinedButton(
        child: const Text("Tetap Hapus"),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.red,
        ),
        onPressed: () {
          provider.removeTransaction(
            widget.transaction!.id,
            widget.transaction!.transaction_date,
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );

      Widget cancelButton = ElevatedButton(
        child: const Text("Batal"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("HAPUS"),
        content: const Text("Anda yakin ingin menghapus data ini ?"),
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
  }
}
