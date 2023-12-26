
import 'dart:convert';

NewAdminResponseModel newAdminResponseJson(String str)=>
    NewAdminResponseModel.fromJson(json.decode(str));
class NewAdminResponseModel {
  late bool status;
  late String success;

  NewAdminResponseModel({required this.status, required this.success});

  NewAdminResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    return data;
  }
}