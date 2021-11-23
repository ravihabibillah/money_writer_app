import 'package:flutter/material.dart';

class TransactionAddUpdatePage extends StatelessWidget {
  static const routeName = '/transaction_add_update_page';

  const TransactionAddUpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Center(
        child: Text('Transaksi Page'),
      ),
    );
  }
}
