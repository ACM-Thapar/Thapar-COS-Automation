import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../Services/User.dart';
import '../Screens/LoginPage.dart';
import '../PageResizing/Variables.dart';
import '../PageResizing/WidgetResizing.dart';

class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
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
              Container(
                width: 100 * boxSizeH,
                margin: EdgeInsets.only(top: 60 / 6.4 * boxSizeV),
                child: Column(
                  children: [
                    Text(
                      'Who am I ?',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 123 / 6.4 * boxSizeV,
                      width: 263 / 3.6 * boxSizeH,
                      margin: EdgeInsets.only(
                        top: 26 / 6.4 * boxSizeV,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xffCBCBCB)),
                        color: Colors.white,
                      ),
                      child: Text(
                        'User',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 123 / 6.4 * boxSizeV,
                      width: 263 / 3.6 * boxSizeH,
                      margin: EdgeInsets.only(
                        top: 33 / 6.4 * boxSizeV,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xffCBCBCB)),
                        color: Colors.white,
                      ),
                      child: Text(
                        'Shopkeeper',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 205 / 6.4 * boxSizeV,
                ),
                height: 435 / 6.4 * boxSizeV,
                width: 100 * boxSizeH,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/MaskGroup3.png'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 125 / 6.4 * boxSizeV,
                  left: 48 / 3.6 * boxSizeH,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Provider.of<AppUser>(context, listen: false)
                            .setProfile(user: true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 123 / 6.4 * boxSizeV,
                        width: 263 / 3.6 * boxSizeH,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xffCBCBCB)),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<AppUser>(context, listen: false)
                            .setProfile(user: false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 123 / 6.4 * boxSizeV,
                        width: 263 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          top: 33 / 6.4 * boxSizeV,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xffCBCBCB)),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
