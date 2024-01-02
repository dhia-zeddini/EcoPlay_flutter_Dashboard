import 'dart:convert';


import 'package:dcache/dcache.dart';
import 'package:http/http.dart'as http;
import 'package:smart_admin_dashboard/models/Ban_request_model.dart';
import 'package:smart_admin_dashboard/models/NewAdmin_response_model.dart';

import '../config.dart';
import '../models/Login_request_model.dart';
import '../models/Login_response_model.dart';
import '../models/NewAdmin_request_model.dart';
import '../models/UserModel.dart';
import 'dart:html' as html;

class UserService{
  static var client=http.Client();
  static final cache = new SimpleCache<String, String>(storage: new InMemoryStorage<String, String>( 1));
  Cache c = new SimpleCache<String, int>(storage: new InMemoryStorage<String, int>(20));

  static Future<LoginResponseModel> login(LoginRequestModel model)async{
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',
    };
    var url=Uri.http(Config.apiURL,Config.loginAPI);
    var response=await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    /*print(url);*/
    if(response.statusCode==200){
      //await SharedService.saveToken(loginResponseJson(response.body).token);

      cache.set("token", loginResponseJson(response.body).token);
      String token = loginResponseJson(response.body).token;
      html.window.localStorage['token'] = token;
      return loginResponseJson(response.body);
    }else{
      return loginResponseJson(response.body);
    }
  }
  static Future<NewAdminResponseModel> newAdmin(NewAdminRequestModel model)async{
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',
    };
    var url=Uri.http(Config.apiURL,Config.newAdminAPI);
    var response=await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    /*print(url);*/
    if(response.statusCode==200){
      return newAdminResponseJson(response.body);
    }else{
      return newAdminResponseJson(response.body);
    }
  }
  static Future<List<UserModel>?> getAllUsers()async{

    print( cache.get("token"));
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',

    };
    var url=Uri.http(Config.apiURL,Config.userAPI);

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
  static Future<List<UserModel>?> getAllAdmins()async{

    print( cache.get("token"));
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',

    };
    var url=Uri.http(Config.apiURL,Config.adminAPI);

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

  static Future<List<dynamic>> banUser(BanRequestModel banRequestModel)async{
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',

    };
    var url=Uri.http(Config.apiURL,Config.banAPI);

    var response=await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(banRequestModel.toJson()),
    );
    print(response.statusCode);
    print(response.body[1]);
    if(response.statusCode==200){
      return [true,response.body];
    }else{
      return [false,response.body];
    }
  }

  static Future<List<dynamic>> unBanUser(BanRequestModel banRequestModel)async{
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',

    };
    var url=Uri.http(Config.apiURL,Config.unBanAPI);

    var response=await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(banRequestModel.toJson()),
    );
    print(response.statusCode);
    print(response.body[1]);
    if(response.statusCode==200){
      return [true,response.body];
    }else{
      return [false,response.body];
    }
  }
//forgetPwd
  static Future<bool> forgetPwd(String email)async{
    Map<String,String> requestHeaders={
      'Content-Type':'application/json',
    };
    var url=Uri.http(Config.apiURL,Config.forgetPwdAPI);
    Map<String, String> requestBody = {
      "data": email,
    };
    var response=await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(requestBody),
    );
    print("url");
    print(url);
    if(response.statusCode==200){
     // await SharedService.setLogindetails(loginResponseJson(response.body));

      return true;
    }else{
      return false;
    }
  }
}