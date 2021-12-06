class Transactions {
  late int? id;
  late String description;
  late int amount;
  late String transactionDate;
  late int? idCategories;
  late String type;
  late String nameCategories;

  Transactions({
    required this.id,
    required this.description,
    required this.amount,
    required this.transactionDate,
    required this.idCategories,
    required this.type,
  });

  // mengambil data
  Transactions.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    description = map['description'];
    amount = map['amount'];
    transactionDate = map['transaction_date'];
    idCategories = map['id_categories'];
    type = map['type'];
    nameCategories = map['name'];
  }

  // konversi data ke map
  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "amount": amount,
        "transaction_date": transactionDate,
        "id_categories": idCategories,
        "type": type,
      };
}

class TotalTransactions {
  late int total;
  late String type;

  // mengambil data
  TotalTransactions.fromMap(Map<String, dynamic> map) {
    type = map['type'];
    total = map['total'];
  }
}
