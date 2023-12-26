class Product {
  final String id; // Add the id field
  final String name;
  final String description;
  final String image;
  final String price;
  final String type;

  Product({
    required this.id, // Include the id in the constructor
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'], // Assuming '_id' is the key in your JSON. Adjust if it's different.
      name: json['nameP'],
      description: json['descriptionP'],
      image: json['image'],
      price: json['priceP'],
      type: json['typeP'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include the id field here
      'nameP': name,
      'descriptionP': description,
      'image': image,
      'priceP': price,
      'typeP': type,
    };
  }
}
