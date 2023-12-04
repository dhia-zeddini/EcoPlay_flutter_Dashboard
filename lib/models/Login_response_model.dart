
import 'dart:convert';

LoginResponseModel loginResponseJson(String str)=>
    LoginResponseModel.fromJson(json.decode(str));
class LoginResponseModel {
  late bool status;
  late String token;
  late String error;

  LoginResponseModel({required this.status, required this.token,required this.error});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    return data;
  }
}