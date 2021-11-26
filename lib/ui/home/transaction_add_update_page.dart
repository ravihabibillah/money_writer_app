import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/data/model/transactions.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/provider/transactions_provider.dart';
import 'package:money_writer_app/ui/home/home_page.dart';
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
  // TextEditingController _categoryController = TextEditingController();
  MoneyMaskedTextController _amountTextController = MoneyMaskedTextController(
      decimalSeparator: '', thousandSeparator: ',', precision: 0);
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.transaction != null) {
      // print("Data dari homePage : " + widget.transaction!.description); // mencoba mendapat data dari homepage
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

    return Consumer<TransactionsProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isUpdate ? 'Ubah Transaksi' : 'Tambah Transaksi'),
          actions: [
            if (_isUpdate)
              IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  showAlertDialog(BuildContext context) {
                    // set up the button
                    Widget okButton = OutlinedButton(
                      child: Text("Tetap Hapus"),
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.red,
                      ),
                      onPressed: () {
                        provider.removeTransaction(widget.transaction!.id);
                        Navigator.of(context).pushNamed(HomePage.routeName);
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
                      content: Text("Anda yakin ingin menghapus data ini ?"),
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
        body: Form(
          key: _transactionFormKey,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Mengubah kategori
                _buildTabTypeTransaction(),
                SizedBox(height: 16.0),

                // Tanggal
                DateTimeField(
                  controller: _dateController,
                  initialValue: DateTime.tryParse(_dateController.text),
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: InputDecoration(
                    label: Text('tanggal'),
                    icon: Icon(Icons.event),
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
                SizedBox(height: 16.0),

                // kategori
                Consumer<CategoryProvider>(
                  builder: (context, provider, child) {
                    if (provider.statePengeluaran == ResultState.HasData ||
                        provider.statePemasukan == ResultState.HasData) {
                      // data category
                      var getCategory = typePengeluaran
                          ? provider.categoriesPengeluaran
                          : provider.categoriesPemasukan;
                      // var categoryMapToList =
                      //     getCategory.map((e) => e.name).toList();

                      // var _firstDataWithCategoryMap =
                      //     categoryMapToList.map((String value) {
                      //   return DropdownMenuItem(
                      //     value: value,
                      //     child: Text(value),
                      //   );
                      // });

                      var categoryMap = getCategory.map((e) => {e.id: e.name});

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

                      // print(categoryMapToList.toList());
                      //
                      // print(categoryMapToList.toList().map((entry) {
                      //   return entry.keys;
                      // }).toList());
                      //
                      // print(categoryMapToList.toList().map((entry) {
                      //   return entry.keys
                      //       .toString()
                      //       .replaceAll(RegExp(r'[^0-9\.]'), '');
                      // }).toList());

                      String? defaultValueDropdown() {
                        if (widget.transaction?.id_categories.toString() !=
                            null) {
                          if (widget.transaction?.type == typeTransaction) {
                            return widget.transaction?.id_categories.toString();
                          } else {
                            dropdownValue =
                                categoryMapToDropdownMenuItem.first.value;
                            return categoryMapToDropdownMenuItem.first.value;
                          }
                        } else {
                          dropdownValue =
                              categoryMapToDropdownMenuItem.first.value;
                          return categoryMapToDropdownMenuItem.first.value;
                        }

                        // return widget.transaction?.id_categories.toString() ?? categoryMapToDropdownMenuItem.first.value;
                      }

                      return DropdownButtonFormField(
                        items: categoryMapToDropdownMenuItem.toList(),
                        // value: _isUpdate
                        //     ? widget.transaction?.id_categories.toString()
                        //     : categoryMapToDropdownMenuItem.first.value,
                        value: defaultValueDropdown(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue as String?;
                          });
                        },
                        decoration: InputDecoration(
                          label: Text('Kategori'),
                          icon: Icon(Icons.category),
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
                SizedBox(height: 16.0),

                // Jumlah Uang
                TextFormField(
                  controller: _amountTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'Rp. ',
                    label: Text('Jumlah'),
                    icon: Icon(Icons.money),
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
                SizedBox(height: 16.0),

                // Keterangan
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    label: Text('Keterangan'),
                    icon: Icon(Icons.description),
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
                SizedBox(height: 16.0),

                ElevatedButton(
                  child: Text('Simpan'),
                  onPressed: () {
                    if (_transactionFormKey.currentState!.validate()) {
                      var idTransaction =
                          _isUpdate ? widget.transaction!.id : null;
                      var amountReplaceThousandSeparator = _amountTextController
                          .text
                          .replaceAll(RegExp(r'[^0-9\.]'), '');
                      int? amountToInt =
                          int.tryParse(amountReplaceThousandSeparator);
                      // int? idCategoriesToInt = int.parse(dropdownValue!);

                      Transactions dataTranscation = Transactions(
                          id: idTransaction,
                          description: _descriptionController.text,
                          amount: amountToInt!,
                          transaction_date: _dateController.text,
                          id_categories: int.parse(dropdownValue!),
                          type: typeTransaction);

                      print(dataTranscation.toMap());
                      if (!_isUpdate) {
                        provider.addTransaction(dataTranscation);
                      } else {
                        provider.updateTransaction(dataTranscation);
                      }

                      Navigator.pop(context);

                      // String to DateTime
                      // DateTime? parsedDateTime =
                      //     DateTime.tryParse(_dateController.text);
                      // print(parsedDateTime);
                      print(_dateController.text);
                      print(int.parse(dropdownValue!));
                      print(int.parse(dropdownValue!).runtimeType);

                      // assert(myInt is double);
                      print(amountToInt);
                      print(amountToInt.runtimeType);
                      print(_descriptionController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabTypeTransaction() {
    return Row(
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
    );
  }
}
