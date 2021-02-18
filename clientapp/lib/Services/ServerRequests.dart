import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Variables.dart';
import './User.dart';

class ServerRequests {
  final String _url = 'https://protected-oasis-19586.herokuapp.com/api';

  Future<bool> registerGoogle(AppUser appUser) async {
    print('REQUEST SENT');
    http.Response res = await http.post(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/firebase-signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': appUser.name,
        'phone': appUser.phone,
        'email': appUser.email,
        'password': appUser.password,
        if (store.getBool('userType')) 'hostel': appUser.hostel,
      }),
    );
    if (res.statusCode == 200) {
      await store.setString('token', jsonDecode(res.body)['token']);
      return true;
    }
    print('end');
    return false;
  }

  getUser(String token, bool user) async {
    print('GET SENT');
    http.Response res = await http.get(
      '$_url/${user ? 'user' : 'auth'}/me',
      headers: {
        'authorization': 'Bearer ${store.getString('token')}',
      },
    );
    if (res.statusCode == 200) {
      print(res.body);
    } else {
      print(res.body);
      print('error');
    }
  }
}
