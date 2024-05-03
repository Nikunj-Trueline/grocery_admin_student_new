class CategoryModel {
  String? id;
  String name;
  String description;
  String imageUrl;
  int createdAt;
  bool isActive;

  CategoryModel(
      {this.id,
        required this.name,
        required this.description,
        required this.imageUrl,
        required this.isActive,
        required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "isActive": isActive,
    };
  }

  factory CategoryModel.fromJson(dynamic json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      createdAt: json["createdAt"],
      isActive: json["isActive"],
    );
  }
//
}