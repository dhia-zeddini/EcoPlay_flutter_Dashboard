class Comment {
  final String user;
  final String title;
  final String description;
  final String image;
  final int rating;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.user,
    required this.title,
    required this.description,
    required this.image,
    required this.rating,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      rating: json['rating'],
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
