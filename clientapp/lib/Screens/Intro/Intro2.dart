import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Variables.dart';
import '../Builder.dart';
import 'package:provider/provider.dart';
import '../../Services/User.dart';

class Intro2 extends StatefulWidget {
  @override
  _Intro2State createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.delayed(
        Duration(),
        () => true,
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
                  bottom: -boxSizeH * 50,
                  child: Container(
                    padding: EdgeInsets.only(top: 8 * boxSizeV),
                    alignment: Alignment.topCenter,
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
                          text: 'Redeem Points\n',
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
                  top: 20,
                  child: Container(
                    height: 322 / 6.4 * boxSizeV,
                    width: 100 * boxSizeH,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/Group64.png"),
                      ),
                      // border: Border.all(),
                    ),
                  ),
                ),
                Positioned(
                  top: 58 * boxSizeV,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileBuilder(
                              appUser:
                                  Provider.of<AppUser>(context, listen: false)),
                        ),
                      );
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: boxSizeV * 5.5 / 6.4,
                                height: boxSizeV * 5.5 / 6.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff707070),
                                ),
                              ),
                              Container(
                                width: boxSizeV * 8.5 / 6.4,
                                height: boxSizeV * 8.5 / 6.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
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
