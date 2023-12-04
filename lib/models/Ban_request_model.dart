class BanRequestModel {
  late String userId;

  BanRequestModel({required this.userId});


  BanRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    return data;
  }
}
