import 'package:flutter/material.dart';

import 'PageResizing/Variables.dart';
import 'PageResizing/WidgetResizing.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
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
        resizeToAvoidBottomInset: false,
        body: Container(
          child: SingleChildScrollView(
            child: Container(
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
                      'Create A New \nAccount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ),
                  Container(
                    height: 58 / 6.4 * boxSizeV,
                    width: 291 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 32 / 6.4 * boxSizeV,
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Full Name',
                        hintStyle: TextStyle(fontSize: 22),
                        focusColor: Colors.blue[800],
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    height: 58 / 6.4 * boxSizeV,
                    width: 291 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 20 / 6.4 * boxSizeV,
                      left: 35 / 3.6 * boxSizeH,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffCBCBCB)),
                      color: Color(0xffF8F8F8),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 3.8 * boxSizeV,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: 22),
                        focusColor: Colors.blue[800],
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    height: 58 / 6.4 * boxSizeV,
                    width: 291 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 20 / 6.4 * boxSizeV,
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
                        suffixIcon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 22),
                        focusColor: Colors.blue[800],
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 58 / 6.4 * boxSizeV,
                    width: 291 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 27 / 6.4 * boxSizeV,
                      left: 35 / 3.6 * boxSizeH,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xffCBCBCB)),
                      color: Colors.black,
                    ),
                    child: Text(
                      'Register Now',
                      style: TextStyle(color: Colors.white, fontSize: 21),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: 20 / 6.4 * boxSizeV,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ?  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xffFFCB00),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(
                        top: 32 / 6.4 * boxSizeV,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            width: 93 / 3.6 * boxSizeH,
                          ),
                          Text(
                            ' Or sign up with ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            child: Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            width: 93 / 3.6 * boxSizeH,
                          ),
                        ],
                      )),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 38 / 6.4 * boxSizeV,
                          width: 132 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 20 / 6.4 * boxSizeV,
                            left: 35 / 3.6 * boxSizeH,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff3B5998),
                          ),
                          child: Text(
                            'Facebook',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 38 / 6.4 * boxSizeV,
                          width: 132 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 20 / 6.4 * boxSizeV,
                            left: 35 / 3.6 * boxSizeH,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xffCBCBCB)),
                            color: Colors.white,
                          ),
                          child: Text(
                            'Google',
                            style: TextStyle(color: Colors.black, fontSize: 15),
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
      ),
    );
  }
}
