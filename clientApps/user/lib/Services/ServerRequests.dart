import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:user/Modals/Review.dart';

import '../Variables.dart';
import '../Modals/User.dart';

class ServerRequests {
  final String _url = 'cos-thapar.herokuapp.com';

// TODO: CHECK TITLES
  Future<bool> registerGoogle(AppUser appUser) async {
    print('GsignUp SENT');
    http.Response res = await http.post(
      Uri.https(_url, '/api/user/firebase-signup'),
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
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Server Down',
              message: 'The server is down. Restart the app after some time.',
              details: 'single');
      }
    }
  }

  Future<bool> registerForm(AppUser appUser) async {
    print('Form SignUp SENT');
    http.Response res = await http.post(
      Uri.https(_url, '/api/user/signup'),
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
      print("DONE");
      await store.setString('token', jsonDecode(res.body)['token']);
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE',
              message: res.body,
              // 'There is already a user with this email. Please use different email.',
              details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Server Down',
              message: 'The server is down. Restart the app after some time.',
              details: 'single');
      }
    }
  }

  Future<bool> login(AppUser appUser) async {
    print('Login SENT');
    http.Response res;
    try {
      res = await http.post(
        Uri.https(_url, '/api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': appUser.email,
          'password': appUser.password,
        }),
      );
    } on Exception catch (e) {
      print("error");
      print(e);
    }
    if (res.statusCode == 200) {
      print("DONE");
      await store.setString('token', jsonDecode(res.body)['token']);
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: "res.body", details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Server Down',
              message: 'The server is down. Restart the app after some time.',
              details: 'single');
          break;
      }
    }
  }

  Future<bool> checkOTP(String otp) async {
    print('Otp Check SENT');
    http.Response res = await http.post(
      Uri.https(_url, '/api/user/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${store.getString('token')}',
      },
      body: jsonEncode(<String, String>{
        'otp': otp,
      }),
    );
    if (res.statusCode == 200) {
      print("DONE");
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'OTP Expired',
              message: 'Click the resend OTP button for new OTP',
              details: 'double');
          break;
        case 401:
          throw PlatformException(
              // code: 'Invalid OTP',
              // message: 'Please check the entered OTP',
              code: 'TITLE',
              message: res.body,
              details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<bool> regenerateOtp() async {
    print('Otp Resend SENT');
    http.Response res = await http.put(
      Uri.https(_url, '/api/user/regenerate-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${store.getString('token')}',
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<String> getUser() async {
    print('GET User SENT');
    http.Response res = await http.get(
      Uri.https(_url, '/api/user/me'),
      headers: {
        'authorization': 'Bearer ${store.getString('token')}',
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return res.body;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        case 401:
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<bool> updateProfile(AppUser appUser) async {
    print('Update Profile SENT');
    http.Response res = await http.put(
      Uri.https(_url, '/api/user/complete-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${store.getString('token')}',
      },
      body: jsonEncode(<String, String>{
        'phone': appUser.phone,
        'hostel': appUser.hostel,
        'name': appUser.name,
      }),
    );
    if (res.statusCode == 200) {
      print("DONE");
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              // code: 'OTP Expired',
              // message: 'Click the resend OTP button for new OTP',
              code: 'TITLE',
              message: res.body,
              details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<List<dynamic>> getShops() async {
    print('GET SHOPS SENT');
    http.Response res = await http.get(
      Uri.https(_url, '/api/shop/getAllShopsTimeline'),
      headers: <String, String>{
        'authorization': 'Bearer ${store.getString('token')}'
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return jsonDecode(res.body)['data'];
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<List<dynamic>> getShop(String id) async {
    print('GET SHOP SENT ID: $id');
    http.Response res = await http.get(
      Uri.https(_url, '/api/shop/get-shop-user/$id'),
      headers: <String, String>{
        'authorization': 'Bearer ${store.getString('token')}'
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return jsonDecode(res.body)['data']['inventory'];
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<List<dynamic>> getShopReviews(String id) async {
    print('GET SHOP REVIEWS SENT ID: $id');
    http.Response res = await http.get(
      Uri.https(_url, '/api/review/getreviews/$id'),
      headers: <String, String>{
        'authorization': 'Bearer ${store.getString('token')}'
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return jsonDecode(res.body)['data'];
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<bool> postReview(Review review, String id) async {
    print('Post REVIEW SENT Shop ID: $id');
    print(jsonEncode({
      "title": "Food was ok",
      "text": review.review,
      "rating": review.rating
    }));
    http.Response res = await http.post(
        Uri.https(_url, '/api/review/addreview/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Bearer ${store.getString('token')}'
        },
        body: jsonEncode({
          "title": "Food was ok",
          "text": review.review,
          "rating": review.rating.round()
        }));
    if (res.statusCode == 200) {
      print("DONE");
      return true;
    } else {
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<bool> updateReview(Review review) async {
    print('Update REVIEW SENT: ${review.id} ${review.review}');
    http.Response res = await http.put(
        Uri.https(_url, '/api/review/updatereview/${review.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Bearer ${store.getString('token')}'
        },
        body: jsonEncode({
          "title": "Food was ok",
          "text": review.review,
          "rating": review.rating
        }));
    if (res.statusCode == 200) {
      print("DONE");
      return true;
    } else {
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<bool> favouriteShop(String id) async {
    print('Fovourite SHOP SENT ID: $id');
    http.Response res = await http.post(
      Uri.https(_url, '/api/user/favorite/$id'),
      headers: <String, String>{
        'authorization': 'Bearer ${store.getString('token')}'
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<bool> deleteFavouriteShop(String id) async {
    print('Fovourite SHOP SENT ID: $id');
    http.Response res = await http.delete(
      Uri.https(_url, '/api/user/favorite/$id'),
      headers: <String, String>{
        'authorization': 'Bearer ${store.getString('token')}'
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }

  Future<List<dynamic>> getAllOrders() async {
    print('Get All Orders sent');
    http.Response res = await http.get(
      Uri.https(_url, '/api/order/view-all-orders'),
      headers: <String, String>{
        'authorization': 'Bearer ${store.getString('token')}'
      },
    );
    if (res.statusCode == 200) {
      print("DONE");
      return jsonDecode(res.body)['data'];
    } else {
      print(res.statusCode);
      print(res.body);
      switch (res.statusCode) {
        case 400:
          throw PlatformException(
              code: 'TITLE', message: res.body, details: 'single');
          break;
        default:
          throw PlatformException(
              code: 'Something went wrong',
              message: 'Please try again after some time',
              details: 'single');
      }
    }
  }
}
