class NewAdminRequestModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? password;

  NewAdminRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,});


  NewAdminRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    return data;
  }
}
