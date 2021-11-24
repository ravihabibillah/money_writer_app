import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

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

  // Text Controller
  TextEditingController _dateController = TextEditingController();
  // TextEditingController _categoryController = TextEditingController();
  MoneyMaskedTextController _amountTextController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  TextEditingController _descriptionController = TextEditingController();

  DateTime? selectedDate;

  @override
  initState() {
    super.initState();
    selectedDate = DateTime.now();
    dropdownValue = 'Pilih';
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
              // Tanggal
              DateTimeField(
                controller: _dateController,
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
              DropdownButtonFormField<String>(
                value: dropdownValue,
                items: <String>[
                  'Pilih',
                  'tes1',
                  'tes2',
                  'tes3',
                ].map((String value) {
                  return DropdownMenuItem(
                    enabled: value == 'Pilih' ? false : true,
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                    print(_dateController.text);
                    print(dropdownValue!);
                    print(_amountTextController.text);
                    print(_descriptionController.text);
                    // AlertDialog(
                    //   content: Column(
                    //     children: [
                    //       Text(_dateController.text),
                    //       Text(dropdownValue!),
                    //       Text(_amountTextController.text),
                    //       Text(_descriptionController.text),
                    //     ],
                    //   ),
                    // );
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

// class AppDropdownInput<T> extends StatelessWidget {
//   final String hintText;
//   final List<T> options;
//   final T value;
//   final String Function(T) getLabel;
//   final Function(T) onChanged;
//
//   AppDropdownInput({
//     this.hintText = 'Please select an Option',
//     this.options = const [],
//     required this.getLabel,
//     required this.value,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return FormField<T>(
//       builder: (FormFieldState<T> state) {
//         return InputDecorator(
//           decoration: InputDecoration(
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//             labelText: hintText,
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
//           ),
//           isEmpty: value == null || value == '',
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<T>(
//               value: value,
//               isDense: true,
//               onChanged: onChanged,
//               items: options.map((T value) {
//                 return DropdownMenuItem<T>(
//                   value: value,
//                   child: Text(getLabel(value)),
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
