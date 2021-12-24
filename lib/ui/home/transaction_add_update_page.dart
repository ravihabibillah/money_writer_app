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

class _TransactionAddUpdatePageState extends State<TransactionAddUpdatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _transactionFormKey = GlobalKey<FormState>();

  bool _isUpdate = false;
  bool typePengeluaran = true;
  String? dropdownValue;

  // Text Controller
  final TextEditingController _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  final MoneyMaskedTextController _amountTextController =
      MoneyMaskedTextController(
          decimalSeparator: '', thousandSeparator: '.', precision: 0);
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.transaction != null) {
      var selectedTransaction = widget.transaction;
      typePengeluaran =
          selectedTransaction!.type == 'pengeluaran' ? true : false;
      _dateController.text = selectedTransaction.transactionDate;
      dropdownValue = selectedTransaction.idCategories.toString();
      _amountTextController.text = selectedTransaction.amount.toString();
      _descriptionController.text = selectedTransaction.description;
      _isUpdate = true;

      _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: typePengeluaran ? 0 : 1,
      );
    } else {
      _tabController = TabController(length: 2, vsync: this);
    }
    _tabController.addListener(() {
      setState(() {
        _tabController.index;
        _tabController.index == 0
            ? typePengeluaran = true
            : typePengeluaran = false;
      });
    });
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
                    return _transactionAddUpdateDialog(provider, context);
                  },
                ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Mengubah kategori
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(10), // Creates border
                          color: _tabController.index == 0
                              ? Colors.red
                              : Colors.blue),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      tabs: const [
                        Tab(
                          text: "Pengeluaran",
                        ),
                        Tab(
                          text: "Pemasukan",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Form(
                    key: _transactionFormKey,
                    child: _buildColumnTransaction(
                        typeTransaction, provider, context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColumnTransaction(String typeTransaction,
      TransactionsProvider provider, BuildContext context) {
    return Column(
      children: [
        // _buildTabTypeTransaction(),
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
              return 'Tanggal tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),

        // kategori
        Consumer<CategoryProvider>(
          builder: (context, provider, child) {
            if (provider.statePengeluaran == ResultState.hasData ||
                provider.statePemasukan == ResultState.hasData) {
              // data category
              var getCategory = typePengeluaran
                  ? provider.categoriesPengeluaran
                  : provider.categoriesPemasukan;

              var categoryMap = getCategory.map((e) => {e.id: e.name});

              var categoryMapToDropdownMenuItem = categoryMap.map((entry) {
                return DropdownMenuItem(
                  value:
                      entry.keys.toString().replaceAll(RegExp(r'[^0-9]'), ''),
                  child: Text(entry.values
                      .toString()
                      .replaceAll(RegExp(r'[^0-9\a-z\A-Z\ ]'), '')),
                );
              });

              String? defaultValueDropdown() {
                if (widget.transaction?.idCategories.toString() != null) {
                  if (widget.transaction?.type == typeTransaction) {
                    return widget.transaction?.idCategories.toString();
                  } else {
                    return null;
                  }
                } else {
                  dropdownValue = categoryMapToDropdownMenuItem.first.value;
                  return categoryMapToDropdownMenuItem.first.value;
                }
              }

              return DropdownButtonFormField(
                items: categoryMapToDropdownMenuItem.toList(),
                value: defaultValueDropdown(),
                onChanged: (newValue) {
                  dropdownValue = newValue as String?;
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
                    return 'Kategori tidak boleh kosong';
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
              return 'Masukkan jumlah Transaksi';
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
              return 'Keterangan Tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),

        ElevatedButton(
          child: const Text('Simpan'),
          onPressed: () {
            if (_transactionFormKey.currentState!.validate()) {
              var idTransaction = _isUpdate ? widget.transaction!.id : null;
              var amountReplaceThousandSeparator =
                  _amountTextController.text.replaceAll(RegExp(r'[^0-9]'), '');
              int? amountToInt = int.tryParse(amountReplaceThousandSeparator);

              Transactions dataTransaction = Transactions(
                  id: idTransaction,
                  description: _descriptionController.text,
                  amount: amountToInt!,
                  transactionDate: _dateController.text,
                  idCategories: int.parse(dropdownValue!),
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
    );
  }

  void _transactionAddUpdateDialog(
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
            widget.transaction!.transactionDate,
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
