import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../Variables.dart';
import './User.dart';

class ServerRequests {
  final String _url = 'https://protected-oasis-19586.herokuapp.com/api';

  Future<bool> registerGoogle(AppUser appUser) async {
    print('GsignUp SENT');
    http.Response res = await http.post(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/firebase-signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': appUser.name,
        'email': appUser.email,
        'password': appUser.password,
        'photo': appUser.pic
      }),
    );
    if (res.statusCode == 200) {
      print('DONE');
      await store.setString('token', jsonDecode(res.body)['token']);
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      throw PlatformException(
          code: 'Email already in use',
          message: 'There is already a user with this email',
          details: 'single'); //TODO : CHECK ERRORS FROM SERVER
    }
  }

  Future<bool> registerForm(AppUser appUser) async {
    print('Form SignUp SENT');
    print(
      jsonEncode(<String, String>{
        'name': appUser.name,
        'email': appUser.email,
        'password': appUser.password,
      }),
    );
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
    } else {
      print(res.statusCode);
      print(jsonDecode(res.body));
      throw PlatformException(
          code: 'Email already in use',
          message: 'There is already a user with this email',
          details: 'single'); //TODO : CHECK ERRORS FROM SERVER
    }
  }

  Future<String> getUser(String token, bool user) async {
    print('GET User SENT');
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
    } else {
      print(res.statusCode);
      print(res.body);
      /*
      {
          "success": false,
          "message": "Not authorized to access this route"
      }
      */
      throw PlatformException(
          code: 'Error From SERVER'); //TODO : IMPLEMENT ERRORS FROM SERVER
    }
  }

  Future<bool> checkOTP(String otp) async {
    print('Otp Check SENT');
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
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'OTP Expired',
              message: 'Click the resend OTP button for new OTP',
              details: 'single');
          break;
        case 401:
          throw PlatformException(
              code: 'Invalid OTP',
              message: 'Please check the entered OTP',
              details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
      //TODO :CHECK ERRORS FROM SERVER
    }
  }

  Future<bool> regenerateOtp() async {
    print('Otp Resend SENT');
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
      print(res.statusCode);
      print(res.body);
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
    print('Update Profile SENT');
    print(jsonEncode(<String, String>{
      'phone': appUser.phone,
      if (store.getBool('userType')) 'hostel': appUser.hostel,
      'name': appUser.name,
    }));
    http.Response res = await http.put(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/complete-profile',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${store.getString('token')}',
      },
      body: jsonEncode(<String, String>{
        'phone': appUser.phone,
        if (store.getBool('userType')) 'hostel': appUser.hostel,
        'name': appUser.name,
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
      print(res.statusCode);
      print(res.body);
      throw PlatformException(
          code: 'Error From SERVER',
          message:
              'Please try again and if this happens again try restarting the app.',
          details: 'single'); //CHECK ERRORS FROM SERVER
    }
  }

  Future<bool> login(AppUser appUser) async {
    print('Login SENT');
    http.Response res = await http.post(
      '$_url/${store.getBool('userType') ? 'user' : 'auth'}/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': appUser.email,
        'password': appUser.password,
      }),
    );
    if (res.statusCode == 200) {
      /*
    {
        "success": true,
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMzAyOTJlNzliOTFhMDAxNTlmMjRlMyIsImlhdCI6MTYxMzc2OTAxNH0.fKX7M3rJp4oYKDxV3WelPGEpGq8dzizp4EYXMNL6WWE",
        "profileCompletion": false
    }
    */
      await store.setString('token', jsonDecode(res.body)['token']);
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 400)
        throw PlatformException(
            code: 'Invalid Credentials',
            message:
                'Wrong email or password.Sign in again with correct email and password',
            details: 'single');
      else
        throw PlatformException(
            code: 'Error From SERVER',
            message: 'Something went wrong. Please try again later.',
            details: 'single'); //CHECK ERRORS FROM SERVER
    }
  }

  Future<List<dynamic>> getShops(String token) async {
    print('GET SHOPS SENT');
    http.Response res = await http.get(
      '$_url/shop/getAllShops',
      headers: <String, String>{'authorization': 'Bearer $token}'},
    );
    if (res.statusCode == 200) {
      /*
    {
        "success": true,
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMzAyOTJlNzliOTFhMDAxNTlmMjRlMyIsImlhdCI6MTYxMzc2OTAxNH0.fKX7M3rJp4oYKDxV3WelPGEpGq8dzizp4EYXMNL6WWE",
        "profileCompletion": false
    }
    */
      print(res.body);
      return jsonDecode(res.body)['data'];
    } else {
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 400)
        throw PlatformException(
            code: 'Invalid Credentials',
            message:
                'Wrong email or password.Sign in again with correct email and password',
            details: 'single');
      else
        throw PlatformException(
            code: 'Error From SERVER',
            message: 'Something went wrong. Please try again later.',
            details: 'single'); //TODO SET ERRORS FROM SERVER
    }
  }
}
