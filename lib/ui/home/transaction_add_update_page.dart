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
  final amountTextController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
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
    amountTextController.dispose();
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
              DateTimeField(
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
              ),
              // Tanggal
              // TextFormField(
              //   decoration: InputDecoration(
              //     label: Text('tanggal'),
              //     icon: Icon(Icons.event),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(5.0),
              //     ),
              //   ),
              // ),
              SizedBox(height: 16.0),

              // kategori
              DropdownButtonFormField<String>(
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
                value: dropdownValue,
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
              ),
              SizedBox(height: 16.0),

              // Jumlah Uang
              TextFormField(
                controller: amountTextController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: 'Rp. ',
                  label: Text('Jumlah'),
                  icon: Icon(Icons.money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Keterangan
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Keterangan'),
                  icon: Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              ElevatedButton(
                child: Text('Simpan'),
                onPressed: () {
                  if (_transactionFormKey.currentState != null) {}
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
