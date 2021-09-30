import 'package:flutter/material.dart';
import 'package:user/Screens/UserProfile.dart';

import '../Variables.dart';
import 'LoginPage.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.keyboard_arrow_left)),
                Container(
                  margin: EdgeInsets.only(
                    top: 27 / 6.4 * boxSizeV,
                  ),
                  child: Text(
                    'Settigns',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 41,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(),
                        ));
                  },
                  child: Container(
                      width: 290 / 3.6 * boxSizeH,
                      margin: EdgeInsets.only(
                        top: 32 / 6.4 * boxSizeV,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 56 / 6.4 * boxSizeV,
                            width: 56 / 3.6 * boxSizeH,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                            child: Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 27 / 3.6 * boxSizeH,
                            ),
                            child: Text(
                              'My Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                    width: 290 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 27 / 6.4 * boxSizeV,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56 / 6.4 * boxSizeV,
                          width: 56 / 3.6 * boxSizeH,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 27 / 3.6 * boxSizeH,
                          ),
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    width: 290 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 27 / 6.4 * boxSizeV,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56 / 6.4 * boxSizeV,
                          width: 56 / 3.6 * boxSizeH,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 27 / 3.6 * boxSizeH,
                          ),
                          child: Text(
                            'Privacy',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    width: 290 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 27 / 6.4 * boxSizeV,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56 / 6.4 * boxSizeV,
                          width: 56 / 3.6 * boxSizeH,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.help,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 27 / 3.6 * boxSizeH,
                          ),
                          child: Text(
                            'Help',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    )),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => WillPopScope(
                        onWillPop: () =>
                            Future.delayed(Duration(), () => false),
                        child: Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    );
                    await store.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                        (route) => false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 290 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 81.5 / 6.4 * boxSizeV,
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 41,
                        color: Color(0xffFFCB00),
                      ),
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
