import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

//String url_server = "http://localhost:61955";
String url_server = "http://10.5.50.39:45455";
String url_ = "";

//
class api_controller {
  Future<http.Response> createUser(String UserVal, String PassVal,
      String EmailVal, bool AdminRegister) async {
    int registerStatusCode = 0;
    AdminRegister
        ? url_ = url_server + '/api/Authenticate/register-admin'
        : url_ = url_server + '/api/Authenticate/Register';
    final response = await http.post(
      Uri.parse(url_),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': UserVal,
        'Email': EmailVal,
        'Password': PassVal,
      }),
    );
    registerStatusCode = response.statusCode;
    print("response.statusCode=>" + registerStatusCode.toString());
    if (registerStatusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print("Error");
    }
    return response;
  }

  ////////
  Future<http.Response> User_login(
      String UserVal, String PassVal, bool AdminLogin) async {
    int registerStatusCode = 0;
    final response = await http.post(
      Uri.parse(url_server + '/api/Authenticate/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': UserVal,
        'Password': PassVal,
      }),
    );
    registerStatusCode = response.statusCode;
    print("response.statusCode=>" + registerStatusCode.toString());
    if (registerStatusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print("Error");
    }
    return response;
  }

  ///////
  Future<http.Response> User_permission_check(String tokenAuth) async {
    int registerStatusCode = 0;
    final response = await http.get(
      Uri.parse(url_server + '/Player'),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + tokenAuth
      },
    );
    registerStatusCode = response.statusCode;
    print("response.statusCode=>" + registerStatusCode.toString());
    if (registerStatusCode == 200) {
      print(response.body);
    } else {
      print("Error");
    }
    return response;
  }

  Future<http.Response> Admin_permission_check(String tokenAuth) async {
    int registerStatusCode = 0;
    final response = await http.get(
      Uri.parse(url_server + '/Admin'),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + tokenAuth
      },
    );
    registerStatusCode = response.statusCode;
    print("response.statusCode=>" + registerStatusCode.toString());
    if (registerStatusCode == 200) {
      print(response.body);
    } else {
      print("Error");
    }
    return response;
  }
}


/*
class Album {
  final int userId;
  final int userPassword;
  final String Email;

  Album({
    required this.userId,
    required this.userPassword,
    required this.Email,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      userPassword: json['id'],
      Email: json['title'],
    );
  }
}
*/
