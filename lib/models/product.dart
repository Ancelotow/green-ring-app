class Product {
  String id;
  String name;
  int price;

  Product({required this.id, required this.name, required this.price});

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price
  };

  Product.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        price = json['price'];
}
