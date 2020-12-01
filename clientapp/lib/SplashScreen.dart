import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import './PageResizing/Variables.dart';
import './PageResizing/WidgetResizing.dart';
import './Intro/Intro1.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimeout() {
    return Timer(Duration(seconds: 3), changeScreen);
  }

  changeScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Intro1();
        },
      ),
    );
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
