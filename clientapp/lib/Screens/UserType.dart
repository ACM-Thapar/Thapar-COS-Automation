import 'package:clientapp/Screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ErrorBox.dart';
import '../Variables.dart';
import '../WidgetResizing.dart';

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
    return WillPopScope(
      onWillPop: () async {
        //EXIT APP ERROR
        // print('EXIT APP');
        bool val = await errorBox(
          context,
          PlatformException(
            code: 'Exit',
            message: 'Are you sure you want to exit the app?',
            details: 'double',
          ),
        );
        print(val);
        if (val) {
          // exit(0);
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
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
                      Container(
                        alignment: Alignment.center,
                        height: 45 / 6.4 * boxSizeV,
                        // decoration: BoxDecoration(border: Border.all()),
                        child: Text(
                          'Who am I ?',
                          style: robotoB45.copyWith(
                              letterSpacing: 2, color: Colors.black),
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
                          style: robotoB37.copyWith(color: Colors.black),
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
                          style: robotoB37.copyWith(color: Colors.black),
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
                    top: 131 / 6.4 * boxSizeV,
                    left: 48 / 3.6 * boxSizeH,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await store.setBool('userType', true);
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
                            // border: Border.all(color: Color(0xffCBCBCB)),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await store.setBool('userType', false);
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
                            // border: Border.all(color: Color(0xffCBCBCB)),
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
      ),
    );
  }
}
