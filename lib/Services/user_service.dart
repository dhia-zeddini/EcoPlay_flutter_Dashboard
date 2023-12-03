import 'dart:convert';


import 'package:http/http.dart'as http;

import '../config.dart';
import '../models/UserModel.dart';


class UserService{
  static var client=http.Client();


  static Future<List<UserModel>?> getAllUsers()async{
    print("service");
    //var userToken=await SharedService.loginDetails();
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',

    };
    var url=Uri.http(Config.apiURL,Config.userAPI);
    //var url = Uri.parse('http://192.168.1.117:9001/user');
    print("service22");

    var response=await client.get(
      url,
      headers: requestHeaders,

    );
    print(response.statusCode);
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
     // print(data);
      return usersFromJson(data);
    }else{
      return null;
    }
  }

}