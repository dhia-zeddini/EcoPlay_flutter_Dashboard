
import 'dart:convert';

ForgetPwdResponseModel forgetPwdResponseJson(String str)=>
    ForgetPwdResponseModel.fromJson(json.decode(str));
class ForgetPwdResponseModel {
  late bool status;
  late String token;

  ForgetPwdResponseModel({required this.status, required this.token});

  ForgetPwdResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    return data;
  }
}