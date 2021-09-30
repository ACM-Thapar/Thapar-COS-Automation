import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/Services/auth.dart';

import '../../ErrorBox.dart';
import '../../Screens/Builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Variables.dart';
import './Intro2.dart';
import '../../Modals/User.dart';

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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return OrientationBuilder(
      builder: (context, orientation) => WillPopScope(
        //EXIT APP ERROR
        // print('EXIT APP');
        onWillPop: () async {
          bool val = await errorBox(
            context,
            PlatformException(
              code: 'Logout & Exit',
              message: 'Are you sure you want to logout and exit?',
              details: 'double',
            ),
          );
          if (val) {
            await Provider.of<Auth>(context, listen: false).logOut();
            store.clear();
            // exit(0);
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              color: Color(0xFFEFEFEF),
              child: orientation == Orientation.landscape
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: height,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(height),
                              bottomRight: Radius.circular(height),
                            ),
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
                                style: josefinSansB31.copyWith(
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Intro2()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
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
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/Intro1.svg',
                              height: height - 40,
                            ),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: 20,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 25,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          width: 7,
                                          height: 7,
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
                                            builder: (context) =>
                                                ProfileBuilder(
                                              appUser: Provider.of<AppUser>(
                                                  context,
                                                  listen: false),
                                              edit: false,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Skip')),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width,
                          height: width / 2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(width),
                              bottomRight: Radius.circular(width),
                            ),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Intro2()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
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
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/Intro1.svg',
                              width: width - 40,
                            ),
                            Positioned(
                              bottom: 20,
                              right: 0,
                              left: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          width: 7,
                                          height: 7,
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
                                            builder: (context) =>
                                                ProfileBuilder(
                                              appUser: Provider.of<AppUser>(
                                                  context,
                                                  listen: false),
                                              edit: false,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Skip')),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
