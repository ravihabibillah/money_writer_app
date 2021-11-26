class Transactions {
  late int? id;
  late String description;
  late int? amount;
  late String transaction_date;
  late int? id_categories;
  late String type;

  Transactions({
    required this.id,
    required this.description,
    required this.amount,
    required this.transaction_date,
    required this.id_categories,
    required this.type,
  });

  // mengambil data
  Transactions.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    description = map['description'];
    amount = map['amount'];
    transaction_date = map['transaction_date'];
    id_categories = map['id_categories'];
    type = map['type'];
  }

  // konversi data ke map
  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "amount": amount,
        "transaction_date": transaction_date,
        "id_categories": id_categories,
        "type": type,
      };
}
