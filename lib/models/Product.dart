class Product {
  final String name;
  final String description;
  final String image;
  final String price;
  final String type;

  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['nameP'],
      description: json['descriptionP'],
      image: json['image'],
      price: json['priceP'],
      type: json['typeP'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameP': name,
      'descriptionP': description,
      'image': image,
      'priceP': price,
      'typeP': type,
    };
  }
}
