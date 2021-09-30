import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/Modals/Order.dart';
import 'package:user/Screens/Intro/Intro1.dart';

import '../Screens/LoginPage.dart';
import '../Screens/HomePage.dart';
import '../Screens/OTP_Verification/OTP-2.dart';
import '../Modals/User.dart';
import '../Services/ServerRequests.dart';
import '../Modals/Shop.dart';
import '../Variables.dart';
import '../ErrorBox.dart';
import './OTP_Verification/OTP-1.dart';

class SplashScreen extends StatefulWidget {
  final ServerRequests serverRequests;
  final AppUser appUser;
  final Order order;
  SplashScreen({this.order, this.serverRequests, this.appUser});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer startTimeout() {
    return Timer(Duration(seconds: 2), changeScreen);
  }

  void changeScreen() async {
    final String token = store.getString('token');
    print('TOKEN : $token ');
    if (token != null) {
      //USER SIGNED IN SERVER
      String json;
      try {
        json = await widget.serverRequests.getUser();
      } on PlatformException catch (e) {
        print(e.code);
        //TODO:SERVER DOWN CLOSE APP
        await errorBox(context, e);
      }
      if (json != null) {
        widget.appUser.fromServer(json); //SETTING THE AppUSER IN PROVIDER
        //check profile complete or not
        final jsonObj = jsonDecode(json);
        if (jsonObj['data']['verified'] == false) {
          //Email & Pass SignUp
          //EMAIL LEFT ->Phone and hostel left
          bool success;
          try {
            success = await widget.serverRequests.regenerateOtp();
          } on PlatformException catch (e) {
            print(e.code);
            //TODO ASK WHAT AGAIN SIGN OR what
            //CRASH APP ERROR
            await errorBox(context, e);
            success = false;
          }
          if (success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => OTP2(),
              ),
            );
          }
        } else if (jsonObj['data']['verified'] == true &&
            jsonObj['data']['phone'] == null) {
          //Email verified
          //PHONE AND HOSTEL LEFT
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => OTP1(),
            ),
          );
        } else if (jsonObj['data']['verified'] == true &&
            jsonObj['data']['phone'] != null &&
            jsonObj['data']['hostel'] == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Intro1(),
            ),
          );
        } else {
          //FULL USER PROFILE COMPLETE
          //GET ALL SHOPS
          final List<dynamic> list = await widget.serverRequests.getShops();
          list.forEach((element) {
            shops.add(Shop.fromjson(element));
          });
          final String shopId = store.getString('shopID');
          if (shopId != null && shopId != '') {
            bool success = false;
            List<dynamic> json;
            try {
              json = await widget.serverRequests.getShop(shopId);
              success = true;
            } on PlatformException catch (e) {
              success = false;
              errorBox(context, e);
              //TODO ASK WHAT AGAIN SIGN OR what
              //CRASH APP ERROR
            }
            if (success) {
              shops.firstWhere((shop) => shop.id == shopId).setMenu(json);
              widget.order.fromMap(
                  jsonDecode(store.getString('order')).map<String, int>((key,
                          value) =>
                      MapEntry(key.toString(), int.parse(value.toString()))),
                  shopId);
            }
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
          );
        }
      }
    } else {
      //User has no account/Logged out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xffFFCB00),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  'COSMOS',
                  style: josefinSansR20.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                  bottom: 30,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'from\n',
                        style: josefinSansR14.copyWith(color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'ACM THAPAR',
                            style:
                                josefinSansSB18.copyWith(color: Colors.white),
                          ),
                        ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
