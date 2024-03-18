import 'dart:convert';

import 'package:mobile_ui/constant.dart';

import 'package:http/http.dart' as http;
import 'package:mobile_ui/models/api_response.dart';
// import 'package:mobile_ui/models/api_response.dart';
import 'package:mobile_ui/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Membuat fungsi yang mengembalikan API dalam bentuk objek
Future<ApiResponse> login (String email,String password)async{
  ApiResponse apiResponse = ApiResponse();

  try {
    final resp = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept':"application/json"},
      body:{"email":email,'password':password}
    );

    print(resp);

    // switch(resp.statusCode){
    //   case 200:
    //     apiResponse.data = User.fromJson(jsonDecode(resp.body));
    //     break;
    //   case 422:
    //     final errors = jsonDecode(resp.body)['errors'];
    //     apiResponse.error = errors[errors.keys.elementAt(0)][0];
    //     break;
    //   case 403:
    //     apiResponse.error = jsonDecode(resp.body)['message'];
    //   default:
    //     apiResponse.error = somethingWentWrong;
    // }

  } catch (e) {
    apiResponse.error = e;
  }
  return apiResponse;
}

// Register
Future<ApiResponse> register (String name,String email,String password)async{
  ApiResponse apiResponse = ApiResponse();

  try {
    final resp = await http.post(
      Uri.parse(registerURL),
      headers: {'Accept':"application/json"},
      body:{
        "name":name,
        "email":email,
        'password':password,
        'password_confirmation':password,
        }
    );

    switch(resp.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(resp.body));
        break;
      case 422:
        final errors = jsonDecode(resp.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(resp.body)['message'];
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }

  } catch (e) {
    apiResponse.error = serveError;
  }
  return apiResponse;
}


// User

Future<ApiResponse> getUserDetail() async{
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final resp = await http.get(
      Uri.parse(userURL),
      headers: {
        "Accept":"application/json",
        "Authorization":'Bearer $token'
      });

      switch(resp.statusCode){
        case 200:
          apiResponse.data = User.fromJson(jsonDecode(resp.body));
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
  } catch (e) {
      apiResponse.error = serveError;
  }

  return apiResponse;
}


// Get Token
Future<String> getToken()async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token')??'';
}

//Get User Id
Future<int> getUserId()async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId')??0;
}

// Logout
Future<bool> logout()async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
