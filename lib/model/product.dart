class Product {
  String? id;
  String name;
  String description;
  double price;
  int stock;
  String imageUrl;
  int createdAt;
  String categoryId;
  bool inTop = false;

  Product(
      {this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.stock,
      required this.imageUrl,
      required this.createdAt,
        required this.categoryId,
      this.inTop = false});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "inTop": inTop,
      "categoryId" : categoryId
    };
  }

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: double.parse(json["price"].toString()),
      stock: json["stock"],
      imageUrl: json["imageUrl"],
      createdAt: json["createdAt"],
      inTop: json["inTop"],
      categoryId: json["categoryId"]
    );
  }
//
}
