import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'PageResizing/Variables.dart';
import 'PageResizing/WidgetResizing.dart';

class ProfileBuilder extends StatefulWidget {
  @override
  _ProfileBuilderState createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
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
            margin: EdgeInsets.only(
              top: 27 / 6.4 * boxSizeV,
              left: 35 / 3.6 * boxSizeH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'ShopKeeper Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 41,
                    ),
                  ),
                ),
                Container(
                  height: 89 / 6.4 * boxSizeV,
                  width: 290 / 3.6 * boxSizeH,
                  margin: EdgeInsets.only(
                    top: 32 / 6.4 * boxSizeV,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 89 / 6.4 * boxSizeV,
                        width: 89 / 3.6 * boxSizeH,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          MdiIcons.cameraEnhanceOutline,
                          color: Color(0xffffcb00),
                          size: 30,
                        ),
                      ),
                      Container(
                        width: 145 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          right: 20 / 3.6 * boxSizeH,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                            hintText: 'Name',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.5 / 6.4 * boxSizeV,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                    hintText: 'Email',
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
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                    hintText: 'Hostel',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                    hintText: 'Joined On',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    'Change Password ?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25, left: 95 / 3.6 * boxSizeH),
                  child: Text(
                    'Fill Shop Details',
                    style: TextStyle(
                      fontSize: 15,
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
