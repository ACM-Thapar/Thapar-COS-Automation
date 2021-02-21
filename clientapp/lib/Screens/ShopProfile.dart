import 'package:flutter/material.dart';

import './HomePage.dart';
import '../Variables.dart';

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
                      contentPadding: EdgeInsets.only(bottom: 4),
                      labelText: 'Name',
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
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Shop No.',
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
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Category',
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
                    contentPadding: EdgeInsets.only(bottom: 4),
                    labelText: 'Address',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 4),
                    labelText: 'Contact No.',
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
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Capacity',
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
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Timing',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
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
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50, left: 95 / 3.6 * boxSizeH),
                    child: Row(
                      children: [
                        Text(
                          'View Shops',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
