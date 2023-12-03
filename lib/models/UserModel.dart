
List<UserModel> usersFromJson(dynamic str) =>
    List<UserModel>.from((str).map((x) => UserModel.fromJson(x)));

class UserModel {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String password;
  String avatar;
  int points;
  int score;
  int level;
  int goldMedal;
  int silverMedal;
  int bronzeMedal;
  // List<String> owned; // Uncomment this line if needed
  bool etatDelete;
  String createdAt;
  String updatedAt;
  int v;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.avatar,
    required this.points,
    required this.score,
    required this.level,
    required this.goldMedal,
    required this.silverMedal,
    required this.bronzeMedal,
    // required this.owned, // Uncomment this line if needed
    required this.etatDelete,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      avatar: json['avatar'],
      points: json['points'],
      score: json['score'],
      level: json['level'],
      goldMedal: json['goldMedal'],
      silverMedal: json['silverMedal'],
      bronzeMedal: json['bronzeMedal'],
      // owned: List<String>.from(json['owned']), // Uncomment this line if needed
      etatDelete: json['etatDelete'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'avatar': avatar,
      'points': points,
      'score': score,
      'level': level,
      'goldMedal': goldMedal,
      'silverMedal': silverMedal,
      'bronzeMedal': bronzeMedal,
      // 'owned': owned, // Uncomment this line if needed
      'etatDelete': etatDelete,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
