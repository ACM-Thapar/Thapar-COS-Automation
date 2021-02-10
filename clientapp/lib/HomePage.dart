import 'package:clientapp/Inventory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import 'PageResizing/Variables.dart';
import './PageResizing/WidgetResizing.dart';
import './Tracking.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email;
  String password;
  bool eText = true, pText = true;
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
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 100 * boxSizeV,
                  width: 100 * boxSizeH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 27 / 6.4 * boxSizeV,
                          left: 36 / 3.6 * boxSizeH,
                        ),
                        child: Text(
                          'Shops',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 5 / 6.4 * boxSizeV,
                          left: 36 / 3.6 * boxSizeH,
                        ),
                        child: Text(
                          'Let\'s find out what you need',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        height: 58 / 6.4 * boxSizeV,
                        width: 291 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          top: 10 / 6.4 * boxSizeV,
                          left: 35 / 3.6 * boxSizeH,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffCBCBCB)),
                          color: Color(0xffF8F8F8),
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 3.8 * boxSizeV,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Search a Category',
                            hintStyle: TextStyle(fontSize: 22),
                            focusColor: Colors.blue[800],
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        height: 86 / 6.4 * boxSizeV,
                        width: 320 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          top: 20 / 6.4 * boxSizeV,
                          left: 20 / 3.6 * boxSizeH,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 9 / 3.6 * boxSizeH,
                                  ),
                                  height: 86 / 6.4 * boxSizeV,
                                  width: 86 / 3.6 * boxSizeH,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                    color: Color(0xfff8f8f8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'All',
                                        style: TextStyle(
                                          fontSize: 45,
                                        ),
                                      ),
                                      Icon(
                                        Icons.trip_origin,
                                        color: Color(0xffFFCB00),
                                        size: 12,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 9 / 3.6 * boxSizeH,
                                  ),
                                  height: 86 / 6.4 * boxSizeV,
                                  width: 86 / 3.6 * boxSizeH,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                    color: Color(0xfff8f8f8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.utensils,
                                        color: Color(0xffFFCB00),
                                        size: 40,
                                      ),
                                      Text(
                                        'Eatries',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 9 / 3.6 * boxSizeH,
                                  ),
                                  height: 86 / 6.4 * boxSizeV,
                                  width: 86 / 3.6 * boxSizeH,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                    color: Color(0xfff8f8f8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.book,
                                        color: Color(0xffFFCB00),
                                        size: 40,
                                      ),
                                      Text(
                                        'Stationery',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 9 / 3.6 * boxSizeH,
                                  ),
                                  height: 86 / 6.4 * boxSizeV,
                                  width: 86 / 3.6 * boxSizeH,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                    color: Color(0xfff8f8f8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.utensils,
                                        color: Color(0xffFFCB00),
                                        size: 40,
                                      ),
                                      Text(
                                        'Laundry',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 20 / 6.4 * boxSizeV,
                          left: 33.5 / 3.6 * boxSizeH,
                        ),
                        height: 350 / 6.4 * boxSizeV,
                        width: 291 / 3.6 * boxSizeH,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Inventory(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                  ),
                                  margin: EdgeInsets.only(
                                    bottom: 8 / 6.4 * boxSizeV,
                                  ),
                                  height: 160 / 6.4 * boxSizeV,
                                  width: 291 / 3.6 * boxSizeH,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 14 / 6.4 * boxSizeV,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          margin: EdgeInsets.only(
                                            top: 14 / 6.4 * boxSizeV,
                                          ),
                                          height: 85 / 6.4 * boxSizeV,
                                          width: 260 / 3.6 * boxSizeH,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: 6 / 6.4 * boxSizeV,
                                              right: 10 / 3.6 * boxSizeH,
                                            ),
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              FontAwesomeIcons.solidHeart,
                                              color: Color(0xffFFCB00),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Juju\'s Shop',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Shop No. xyz',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Inventory(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                  ),
                                  margin: EdgeInsets.only(
                                    bottom: 8 / 6.4 * boxSizeV,
                                  ),
                                  height: 160 / 6.4 * boxSizeV,
                                  width: 291 / 3.6 * boxSizeH,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 14 / 6.4 * boxSizeV,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          margin: EdgeInsets.only(
                                            top: 14 / 6.4 * boxSizeV,
                                          ),
                                          height: 85 / 6.4 * boxSizeV,
                                          width: 260 / 3.6 * boxSizeH,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: 6 / 6.4 * boxSizeV,
                                              right: 10 / 3.6 * boxSizeH,
                                            ),
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              FontAwesomeIcons.solidHeart,
                                              color: Color(0xffFFCB00),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Juju\'s Shop',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Shop No. xyz',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Inventory(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                  ),
                                  margin: EdgeInsets.only(
                                    bottom: 8 / 6.4 * boxSizeV,
                                  ),
                                  height: 160 / 6.4 * boxSizeV,
                                  width: 291 / 3.6 * boxSizeH,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 14 / 6.4 * boxSizeV,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          margin: EdgeInsets.only(
                                            top: 14 / 6.4 * boxSizeV,
                                          ),
                                          height: 85 / 6.4 * boxSizeV,
                                          width: 260 / 3.6 * boxSizeH,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: 6 / 6.4 * boxSizeV,
                                              right: 10 / 3.6 * boxSizeH,
                                            ),
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              FontAwesomeIcons.solidHeart,
                                              color: Color(0xffFFCB00),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Juju\'s Shop',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Shop No. xyz',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('tap');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackingPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 559 / 6.4 * boxSizeV, left: 148 / 3.6 * boxSizeH),
                    height: 64 / 6.4 * boxSizeV,
                    width: 64 / 3.6 * boxSizeH,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
