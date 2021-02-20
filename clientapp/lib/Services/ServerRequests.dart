import 'dart:convert';
import 'package:flutter/services.dart';
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
    } else
      throw PlatformException(
          code: 'Error From SERVER'); //TODO : IMPLEMENT ERRORS FROM SERVER
  }

  Future<bool> registerForm(AppUser appUser) async {
    print('REQUEST SENT');
    http.Response res = await http.post(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': appUser.name,
        'email': appUser.email,
        'password': appUser.password,
      }),
    );
    if (res.statusCode == 200) {
      //WILL BE ALMOST EVERY TIME 200
      /*
      {
          "success": true,
          "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMmVkMzkyODM2NDk3MDAxNTIyMmYwNSIsImlhdCI6MTYxMzY4MTU1NH0.KHonRBD0wwrmM2y0GYoNY6Q1q2bCVrQuJnHGt8JVNd4",
          "profileCompletion": false
      }
       */
      // EMAIL SENT AUTO
      await store.setString('token', jsonDecode(res.body)['token']);
      return true;
    } else
      throw PlatformException(
          code: 'Error from server'); //TODO : IMPLEMENT ERRORS FROM SERVER
  }

  Future<String> getUser(String token, bool user) async {
    print('GET SENT');
    http.Response res = await http.get(
      '$_url/${user ? 'user' : 'auth'}/me',
      headers: {
        'authorization': 'Bearer ${store.getString('token')}',
      },
    );
    if (res.statusCode == 200) {
      print(res.body);
      //gives
      /*Before otp ->EMAILVERIFY NOT DONE
      {
          "success": true,
          "data": {
              "otp": {
                  "validity": "2021-02-18T20:44:12.078Z",
                  "code": "p3wkt1"
              },
              "verified": false,
              "isGoogleUser": false,
              "isPhoneVerified": false,
              "_id": "602ed62d8364970015222f06",
              "name": "Pranav",
              "email": "pvidyarthi_be19@thapar.edu",
              "password": "$2a$10$/CkxIkeFIRPJ/eLdI9mu3eSrVbk6.Mdp5bt0xwcvpBCInrmJEw9Me",
              "__v": 0
          }
      }
      */

      /*AFTER OTP VERIFIED ->EMAILVERIFY DONE & Phone left
      {
          "success": true,
          "data": {
              "otp": {
                  "validity": "2021-02-18T21:21:27.506Z",
                  "code": "squoiq"
              },
              "verified": true,
              "isGoogleUser": false,
              "isPhoneVerified": false,
              "_id": "602ed62d8364970015222f06",
              "name": "Pranav",
              "email": "pvidyarthi_be19@thapar.edu",
              "password": "$2a$10$/CkxIkeFIRPJ/eLdI9mu3eSrVbk6.Mdp5bt0xwcvpBCInrmJEw9Me",
              "__v": 0
          }
      }
      */

      /*Both email and phone with hostel done
      {
          "success": true,
          "data": {
              "otp": {
                  "validity": "2021-02-18T21:21:27.506Z",
                  "code": "squoiq"
              },
              "verified": true,
              "isGoogleUser": false,
              "isPhoneVerified": false,
              "_id": "602ed62d8364970015222f06",
              "name": "Pranav",
              "email": "pvidyarthi_be19@thapar.edu",
              "password": "$2a$10$/CkxIkeFIRPJ/eLdI9mu3eSrVbk6.Mdp5bt0xwcvpBCInrmJEw9Me",
              "__v": 0,
              "hostel": "Hostel H",
              "phone": 8368617290
          }
      }
      */
      return res.body;
    } else
      /*
      {
          "success": false,
          "message": "Not authorized to access this route"
      }
      */
      throw PlatformException(
          code: 'Error From SERVER'); //TODO : IMPLEMENT ERRORS FROM SERVER
  }

  Future<bool> checkOTP(String otp) async {
    print('REQUEST SENT');
    http.Response res = await http.post(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/verify-otp',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${store.getString('token')}',
      },
      body: jsonEncode(<String, String>{
        'otp': otp,
      }),
    );
    if (res.statusCode == 200) {
      //returns a string message verified
      return true;
    } else {
      /*
    {
        "errors": [
            {
                "msg": "OTP has expired" /"invalid OTP"
            }
        ]
    }
    */
      throw PlatformException(
          code: 'Error From SERVER'); //TODO : IMPLEMENT ERRORS FROM SERVER
    }
  }

  Future<bool> regenerateOtp() async {
    print('REQUEST SENT');
    http.Response res = await http.put(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/regenerate-otp',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${store.getString('token')}',
      },
    );
    if (res.statusCode == 200) {
      /*
    {
        "success": true,
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMmVkMzkyODM2NDk3MDAxNTIyMmYwNSIsImlhdCI6MTYxMzY4MTk5OX0.qyxak9PuKlqC3bFZKNTQQ58sFNriemcYOEGVhkkbr8g",
        "profileCompletion": false
    }
    */
      return true;
    } else {
      /*
    {
    "success": false,
    "message": "Not authorized to access this route"
    }
    */
    }
    throw PlatformException(
        code: 'Error From SERVER'); //TODO : IMPLEMENT ERRORS FROM SERVER
  }

  Future<bool> updateProfile(AppUser appUser) async {
    print('REQUEST SENT');
    http.Response res = await http.put(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/complete-profile',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${store.getString('token')}',
      },
      body: jsonEncode(<String, String>{
        'phone': appUser.phone,
        if (store.getBool('userType')) 'hostel': appUser.hostel,
      }),
    );
    if (res.statusCode == 200) {
      /*
      {
          "success": true,
          "data": {
              "otp": {
                  "validity": "2021-02-18T21:21:27.506Z",
                  "code": "squoiq"
              },
              "verified": true,
              "isGoogleUser": false,
              "isPhoneVerified": false,
              "_id": "602ed62d8364970015222f06",
              "name": "Pranav",
              "email": "pvidyarthi_be19@thapar.edu",
              "password": "$2a$10$/CkxIkeFIRPJ/eLdI9mu3eSrVbk6.Mdp5bt0xwcvpBCInrmJEw9Me",
              "__v": 0,
              "hostel": "Hostel H",
              "phone": 8368617290
          },
          "profileCompletion": true
      }
      */
      return true;
    } else {
      /*
    {
        "success": false,
        "message": "Not authorized to access this route"
    }
    */
    }
    throw PlatformException(
        code: 'Error From SERVER'); //TODO : IMPLEMENT ERRORS FROM SERVER
  }
}
