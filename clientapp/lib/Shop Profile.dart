import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'PageResizing/Variables.dart';
import 'PageResizing/WidgetResizing.dart';

class ShopProfile extends StatefulWidget {
  @override
  _ShopProfileState createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
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
        body: SingleChildScrollView(
          child: Container(
            width: 290 / 3.6 * boxSizeH,
            margin: EdgeInsets.only(
              top: 27 / 6.4 * boxSizeV,
              left: 35 / 3.6 * boxSizeH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Shop Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 41,
                    ),
                  ),
                ),
                Container(
                  width: 290 / 3.6 * boxSizeH,
                  margin: EdgeInsets.only(
                    top: 32 / 6.4 * boxSizeV,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                      hintText: 'Name',
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 290 / 3.6 * boxSizeH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90.5 / 3.6 * boxSizeH,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                            hintText: 'Shop No.',
                          ),
                        ),
                      ),
                      Container(
                        width: 158.5 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                            hintText: 'Category',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                    hintText: 'Address',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                    hintText: 'Contact No.',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 290 / 3.6 * boxSizeH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90.5 / 3.6 * boxSizeH,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                            hintText: 'Capacity',
                          ),
                        ),
                      ),
                      Container(
                        width: 158.5 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                            hintText: 'Timing',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50, left: 95 / 3.6 * boxSizeH),
                  child: Row(
                    children: [
                      Text(
                        'Inventory',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                      )
                    ],
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
