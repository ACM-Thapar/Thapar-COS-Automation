import 'package:flutter/material.dart';

import 'PageResizing/Variables.dart';
import 'PageResizing/WidgetResizing.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  bool eText = true, pText = true;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: 100 * boxSizeV,
          width: 100 * boxSizeH,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('images/Mask Group 22.png'),
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.only(
                left: 13 / 3.6 * boxSizeH,
                top: 19 / 6.4 * boxSizeV,
                right: 13 / 3.6 * boxSizeH,
              ),
              child: Stack(
                children: <Widget>[],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
