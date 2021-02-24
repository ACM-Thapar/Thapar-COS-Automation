import 'package:clientapp/Screens/Builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Variables.dart';
import '../../WidgetResizing.dart';
import './Intro2.dart';
import '../../Services/User.dart';

class Intro1 extends StatefulWidget {
  @override
  _Intro1State createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> {
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
      //EXIT APP ERROR
      // print('EXIT APP');
      onWillPop: () => Future.delayed(
        Duration(),
        () => false,
      ),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Color(0xFFEFEFEF),
            height: 100 * boxSizeV,
            width: 100 * boxSizeH,
            child: Stack(
              children: [
                Positioned(
                  top: -boxSizeH * 50,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 8 * boxSizeV),
                    alignment: Alignment.bottomCenter,
                    width: boxSizeH * 100,
                    height: boxSizeH * 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFCB00),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 6,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Earn Points\n',
                          style: josefinSansB37.copyWith(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit',
                              style: josefinSansSB10.copyWith(
                                color: Color(0xc2606060),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 322 / 6.4 * boxSizeV,
                    width: 100 * boxSizeH,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/Group63.png'),
                      ),
                      // border: Border.all(),
                    ),
                  ),
                ),
                Positioned(
                  top: 33 * boxSizeV,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Intro2()));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40 * boxSizeH),
                      width: boxSizeH * 18,
                      height: boxSizeH * 18,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x29000000),
                              blurRadius: 8,
                              offset: Offset(0, 6))
                        ],
                        shape: BoxShape.circle,
                        color: Color(0xFFFFCB00),
                      ),
                      child: Center(
                        child: FaIcon(Icons.arrow_forward_ios_sharp),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4 * boxSizeV,
                  child: Container(
                    width: 100 * boxSizeH,
                    padding: EdgeInsets.symmetric(horizontal: 3 * boxSizeH),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 20 * boxSizeH / 3.6,
                          height: 8.5 * boxSizeV / 6.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: boxSizeV * 8.5 / 6.4,
                                height: boxSizeV * 8.5 / 6.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                width: boxSizeV * 5.5 / 6.4,
                                height: boxSizeV * 5.5 / 6.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff707070),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileBuilder(
                                      appUser: Provider.of<AppUser>(context,
                                          listen: false)),
                                ),
                              );
                            },
                            child: Text('Skip')),
                      ],
                    ),
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
