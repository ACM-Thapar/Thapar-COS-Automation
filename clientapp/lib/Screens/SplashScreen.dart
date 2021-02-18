import 'dart:async';

import 'package:clientapp/Screens/HomePage.dart';
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
      final String json = await widget.serverRequests.getUser(token, userType);
      // widget.appUser.fromServer(json); //SETTING THE USER IN PROVIDER
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
      );
    } else if (user != null) {
      widget.appUser.fromFirebase(user);
      if (user.phoneNumber == null || user.phoneNumber == '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => OTP1(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Intro1(),
          ),
        );
      }
    } else {
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
