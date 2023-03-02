class Product {
  int id;
  String name;
  int price;

  Product({required this.id, required this.name, required this.price});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price
  };

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'];
}
