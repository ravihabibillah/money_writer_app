import 'package:flutter/material.dart';

class TotalDefault extends StatelessWidget {
  const TotalDefault({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Pemasukan',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Rp. 0',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Pengeluaran',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Rp. 0',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Saldo',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 8.0),
                    const Text('Rp.0'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 2),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description, size: 46, color: Colors.grey[400]),
              const SizedBox(height: 10),
              Text(
                "Belum Ada Data",
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        )
      ],
    );
  }
}
