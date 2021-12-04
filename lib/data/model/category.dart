class Category {
  int? id;
  String name;
  String type;

  Category({
    required this.id,
    required this.name,
    required this.type,
  });

  // mengambil data dari Json
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        type: json["type"],
      );

  // konversi data ke Json
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
      };
}
