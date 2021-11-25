import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:money_writer_app/provider/category_provider.dart';
import 'package:money_writer_app/utils/result_state.dart';
import 'package:provider/provider.dart';

class TransactionAddUpdatePage extends StatefulWidget {
  static const routeName = '/transaction_add_update_page';

  TransactionAddUpdatePage({Key? key}) : super(key: key);

  @override
  State<TransactionAddUpdatePage> createState() =>
      _TransactionAddUpdatePageState();
}

class _TransactionAddUpdatePageState extends State<TransactionAddUpdatePage> {
  final _transactionFormKey = GlobalKey<FormState>();
  String? dropdownValue;
  bool typePengeluaran = true;

  // Text Controller
  TextEditingController _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  // TextEditingController _categoryController = TextEditingController();
  MoneyMaskedTextController _amountTextController = MoneyMaskedTextController(
      decimalSeparator: '', thousandSeparator: ',', precision: 0);
  TextEditingController _descriptionController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Form(
        key: _transactionFormKey,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Mengubah kategori
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
                  if (provider.statePengeluaran == ResultState.HasData) {
                    // data category
                    var getCategory = typePengeluaran
                        ? provider.categoriesPengeluaran
                        : provider.categoriesPemasukan;
                    var categoryMapToList =
                        getCategory.map((e) => e.name).toList();

                    var _firstDataWithCategoryMap =
                        categoryMapToList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    });

                    print('dropdownValue = ' + dropdownValue.toString());

                    return DropdownButtonFormField<String>(
                      items: _firstDataWithCategoryMap.toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
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
                        if (value == null || value.isEmpty) {
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
                    // String to DateTime
                    // DateTime? parsedDateTime =
                    //     DateTime.tryParse(_dateController.text);
                    // print(parsedDateTime);
                    print(_dateController.text);
                    print(dropdownValue!);

                    var amountReplaceThousandSeparator = _amountTextController
                        .text
                        .replaceAll(RegExp(r'[^0-9\.]'), '');
                    int? amountToInt =
                        int.tryParse(amountReplaceThousandSeparator);
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
  }
}
