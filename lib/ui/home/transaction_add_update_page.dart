import 'package:flutter/material.dart';

class TransactionAddUpdatePage extends StatelessWidget {
  static const routeName = '/transaction_add_update_page';

  TransactionAddUpdatePage({Key? key}) : super(key: key);

  final _transactionFormKey = GlobalKey<FormState>();

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
              TextFormField(
                decoration: InputDecoration(
                  label: Text('tanggal'),
                  icon: Icon(Icons.money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // kategori
              FormField(
                builder: (FormFieldState<dynamic> field) {},
              ),
              SizedBox(height: 16.0),

              // Jumlah Uang
              TextFormField(
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text('Keterangan'),
                  icon: Icon(Icons.money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
