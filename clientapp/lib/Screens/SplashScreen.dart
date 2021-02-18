import 'dart:async';
import 'dart:convert';

import 'package:clientapp/Screens/HomePage.dart';
import 'package:clientapp/Screens/OTP_Verification/OTP-2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/UserType.dart';
import '../Services/User.dart';
import './Intro/Intro1.dart';
import './OTP_Verification/OTP-1.dart';
import '../Services/ServerRequests.dart';
import '../Variables.dart';
import '../WidgetResizing.dart';

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
    final User user = FirebaseAuth.instance.currentUser;
    final String token = store.getString('token');
    final bool userType = store.getBool('userType');
    print('TOKEN : $token  :FUSER: $user ::TYPE $userType');
    if (token != null) {
      //USER SIGNED IN FIREBASE AND SERVER -> Email & Pass SignUp
      String json;
      try {
        json = await widget.serverRequests.getUser(token, userType);
      } on PlatformException catch (e) {
        //TODO ASK WHAT TO DO MAYBE SIGIN AGAIN
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
            //TODO ASK WHAT AGAIN SIGN OR what
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
            jsonObj['data']['phone'] == null &&
            jsonObj['data']['hostel'] == null) {
          //Email & Pass SignUp
          //Email verified
          //PHONE AND HOSTEL LEFT
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => OTP1(),
            ),
          );
        } else {
          //MAUBE EMAIL OR Gsign
          //FULL PROFILE COMPLETE
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
          );
        }
      }
    } else if (user != null) {
      //Gsign
      widget.appUser.fromFirebase(user); //SETTING THE AppUSER IN PROVIDER
      if (user.phoneNumber == null || user.phoneNumber == '') {
        //Gsign but phone not verify ->No server account
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => OTP1(),
          ),
        );
      } else {
        //Gsign & phone done
        //Hostel Left -> no server account
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Intro1(),
          ),
        );
      }
    } else {
      //User has no account
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => UserType(),
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
                  style: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 26),
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
                            style: GoogleFonts.josefinSans(
                                color: Colors.white, fontSize: 19),
                            children: [
                              TextSpan(
                                text: 'ACM THAPAR',
                                style: GoogleFonts.josefinSans(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 23),
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
