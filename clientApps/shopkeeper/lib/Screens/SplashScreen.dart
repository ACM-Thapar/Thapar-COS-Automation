import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Screens/LoginPage.dart';
import '../Screens/HomePage.dart';
import '../Screens/OTP_Verification/OTP-2.dart';
import '../Services/User.dart';
import '../Services/ServerRequests.dart';
import '../Services/Shop.dart';
import '../Variables.dart';
import '../WidgetResizing.dart';
import '../ErrorBox.dart';
import './OTP_Verification/OTP-1.dart';
import 'ShopProfile.dart';

class SplashScreen extends StatefulWidget {
  final ServerRequests serverRequests;
  final AppUser appUser;
  SplashScreen({this.serverRequests, this.appUser});
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
        json = await widget.serverRequests.getUser(token);
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
        } else {
          //FULL USER PROFILE COMPLETE
          //SHOPKEEPER CHECK
          List<dynamic> shopkeeperShops = jsonObj['data']['shops'];
          if (store.getBool('userType') == false && shopkeeperShops.isEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ShopProfile(),
              ),
            );
          } else {
            //GET ALL SHOPS
            // final List<dynamic> list =
            //     await widget.serverRequests.getShops(store.getString('token'));
            // list.forEach((element) {
            //   Shop.fromjson(element);
            //   shops.add(Shop.fromjson(element));
            // });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
            );
          }
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
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Color(0xffFFCB00),
          height: 100 * boxSizeV,
          width: 100 * boxSizeH,
          child: Stack(
            children: [
              Center(
                child: Text(
                  'COSMOS',
                  style: josefinSansR20.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                  bottom: 30,
                  child: Container(
                    width: 100 * boxSizeH,
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'from\n',
                            style: josefinSansR14.copyWith(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'ACM THAPAR',
                                style: josefinSansSB18.copyWith(
                                    color: Colors.white),
                              ),
                            ]),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
