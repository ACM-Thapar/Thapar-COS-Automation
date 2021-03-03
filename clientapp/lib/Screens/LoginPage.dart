import 'dart:convert';

import 'package:clientapp/ErrorBox.dart';
import 'package:clientapp/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Services/User.dart';
import '../Services/ServerRequests.dart';
import '../Variables.dart';
import './Registeruserpage.dart';
import './HomePage.dart';
import 'Builder.dart';
import 'OTP_Verification/OTP-1.dart';
import 'OTP_Verification/OTP-2.dart';
import 'ShopProfile.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _emailFocus, _passFocus, _escapeNode;
  String _email, _password;
  TextEditingController _emailController, _passwordController;
  bool eText = true, pText = true, hidePass = true;

  @override
  void initState() {
    _emailFocus = FocusNode();
    _escapeNode = FocusNode();
    _passFocus = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //BAck to USERTYPE
        return Future.delayed(Duration(), () => true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 176 / 6.4 * boxSizeV,
                  width: 100 * boxSizeH,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/MaskGroup2.png"),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 100 * boxSizeV,
                  width: 100 * boxSizeH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 111 / 6.4 * boxSizeV,
                          left: 36 / 3.6 * boxSizeH,
                        ),
                        child: Text(
                          'Welcome!',
                          style: robotoB45.copyWith(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 291 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          top: 32 / 6.4 * boxSizeV,
                          left: 35 / 3.6 * boxSizeH,
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                              eText = !(_email == null || _email == '');
                            });
                          },
                          onSubmitted: (v) {
                            print(v);
                            FocusScope.of(context).requestFocus(_passFocus);
                          },
                          style: openSansR14.copyWith(color: Colors.black),
                          cursorColor: Color(0xffFFCB00),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            errorText: eText
                                ? _email != null
                                    ? store.getBool('userType')
                                        ? RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@thapar\.edu$")
                                                .hasMatch(_email)
                                            ? null
                                            : 'Please enter valid Thapar email'
                                        : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(_email)
                                            ? null
                                            : 'Please enter valid email'
                                    : null
                                : 'Enter the email',
                            fillColor: Color(0x80F8F8F8),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Color(0xffCBCBCB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Color(0xffFFCB00),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.red,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.red,
                              ),
                            ),
                            hintStyle:
                                openSansL14.copyWith(color: Color(0xAB707070)),
                          ),
                        ),
                      ),
                      Container(
                        width: 291 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          top: 20 / 6.4 * boxSizeV,
                          left: 35 / 3.6 * boxSizeH,
                        ),
                        child: TextField(
                          obscureText: hidePass,
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          focusNode: _passFocus,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                              pText = !(_password == null || _password == '');
                            });
                          },
                          onSubmitted: (v) {
                            print(v);
                            FocusScope.of(context).requestFocus(_escapeNode);
                          },
                          style: openSansR14.copyWith(color: Colors.black),
                          cursorColor: Color(0xffFFCB00),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidePass = !hidePass;
                                });
                              },
                              child: Icon(
                                hidePass
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined,
                                color: Colors.black,
                              ),
                            ),
                            hintText: 'Password',
                            errorText: pText
                                ? _password != null
                                    ? _password.length < 6
                                        ? 'Password must have atleast 6 characters'
                                        : null
                                    : null
                                : 'Enter the password',
                            fillColor: Color(0x80F8F8F8),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Color(0xffCBCBCB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Color(0xffFFCB00),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.red,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.red,
                              ),
                            ),
                            hintStyle: openSansL14.copyWith(
                              color: Color(0xAB707070),
                            ),
                          ),
                        ),
                      ),
                      //TODO IMPLEMENT FORGOT PASSWORD
                      Container(
                        margin: EdgeInsets.only(
                          top: 13 / 6.4 * boxSizeV,
                          left: 222 / 3.6 * boxSizeH,
                        ),
                        child: Text(
                          'Forget Password!',
                          style: josefinSansSB14.copyWith(
                              color: Color(0xffFFCB00)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_email != null &&
                              _password != null) //CONDITION FOR CHECK FIELDS
                          {
                            if ((store.getBool('userType')
                                    ? RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@thapar\.edu$")
                                        .hasMatch(_email)
                                    : RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(_email)) &&
                                _password.length > 5) {
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
                              Provider.of<AppUser>(context, listen: false)
                                  .fromForm(
                                email: _email,
                                password: _password,
                              ); //SET AppUSER in Provider
                              bool success1;
                              try {
                                success1 = await Provider.of<ServerRequests>(
                                        context,
                                        listen: false)
                                    .login(Provider.of<AppUser>(context,
                                        listen: false));
                              } on PlatformException catch (exp) {
                                Navigator.pop(context);
                                //SHOW ERROR
                                await errorBox(context, exp);
                                success1 = false;
                              }
                              if (success1) {
                                String json;
                                try {
                                  json = await Provider.of<ServerRequests>(
                                          context,
                                          listen: false)
                                      .getUser(store.getString('token'),
                                          store.getBool('userType'));
                                } on PlatformException catch (e) {
                                  print(e.code);
                                  //TODO:SERVER DOWN CLOSE APP
                                  await errorBox(context, e);
                                }
                                if (json != null) {
                                  Provider.of<AppUser>(context, listen: false)
                                      .fromServer(
                                          json); //SETTING THE AppUSER IN PROVIDER
                                  //check profile complete or not
                                  final jsonObj = jsonDecode(json);
                                  if (jsonObj['data']['verified'] == false) {
                                    //Email & Pass SignUp
                                    //EMAIL LEFT ->Phone and hostel left
                                    bool success;
                                    try {
                                      success =
                                          await Provider.of<ServerRequests>(
                                                  context,
                                                  listen: false)
                                              .regenerateOtp();
                                    } on PlatformException catch (e) {
                                      print(e.code);
                                      //TODO ASK WHAT AGAIN SIGN OR what
                                      //CRASH APP ERROR
                                      await errorBox(context, e);
                                      success = false;
                                    }
                                    if (success) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OTP2(),
                                        ),
                                      );
                                    }
                                  } else if (jsonObj['data']['verified'] ==
                                          true &&
                                      jsonObj['data']['phone'] == null) {
                                    //Email verified
                                    //PHONE AND HOSTEL LEFT
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            OTP1(),
                                      ),
                                    );
                                  } else if (jsonObj['data']['verified'] ==
                                          true &&
                                      jsonObj['data']['phone'] != null &&
                                      jsonObj['data']['hostel'] == null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProfileBuilder(
                                                appUser: Provider.of<AppUser>(
                                                    context,
                                                    listen: false)),
                                      ),
                                    );
                                  } else {
                                    //FULL USER PROFILE COMPLETE
                                    //SHOPKEEPER CHECK
                                    List<dynamic> shops =
                                        jsonObj['data']['shops'];
                                    if (store.getBool('userType') == false &&
                                        shops.isEmpty) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ShopProfile(),
                                        ),
                                      );
                                    } else
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HomePage(),
                                        ),
                                      );
                                  }
                                }
                              }
                            }
                          } else
                            setState(() {
                              eText = !(_email == null || _email == '');
                              pText = !(_password == null || _password == '');
                            });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 58 / 6.4 * boxSizeV,
                          width: 291 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 20 / 6.4 * boxSizeV,
                            left: 35 / 3.6 * boxSizeH,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xffCBCBCB)),
                            color: Colors.black,
                          ),
                          child: Text(
                            'Log In',
                            style: josefinSansR18.copyWith(color: Colors.white),
                          ),
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
                                'Not a member ?  ',
                                style: josefinSansSB14.copyWith(
                                    color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Registeruser(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Join now',
                                  style: josefinSansSB14.copyWith(
                                      color: Color(0xffFFCB00)),
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
                                  color: Color(0x80707070),
                                ),
                                width: 93 / 3.6 * boxSizeH,
                              ),
                              Text(
                                ' Or sign in with ',
                                style: josefinSansSB14.copyWith(
                                    color: Colors.black),
                              ),
                              SizedBox(
                                child: Divider(
                                  thickness: 1,
                                  color: Color(0x80707070),
                                ),
                                width: 93 / 3.6 * boxSizeH,
                              ),
                            ],
                          )),
                      Center(
                        child: GestureDetector(
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
                            UserCredential _userCredential;
                            try {
                              _userCredential = await Provider.of<Auth>(context,
                                      listen: false)
                                  .googleAuth();
                            } on PlatformException catch (pltError) {
                              Navigator.pop(
                                  context); //Remove Circular Indicator
                              //SHOW ERROR
                              await errorBox(context, pltError);
                            }
                            if (_userCredential != null) {
                              Provider.of<AppUser>(context, listen: false)
                                  .fromFirebase(_userCredential
                                      .user); //SET AppUSER in Provider
                              bool success1;
                              try {
                                success1 = await Provider.of<ServerRequests>(
                                        context,
                                        listen: false)
                                    .login(Provider.of<AppUser>(context,
                                        listen: false));
                              } on PlatformException catch (exp) {
                                Navigator.pop(context);
                                //SHOW ERROR
                                await errorBox(context, exp);
                                //DELETE FIRBASE USER CREATED
                                FirebaseAuth.instance.currentUser.delete();
                                success1 = false;
                              }
                              if (success1) {
                                String json;
                                try {
                                  json = await Provider.of<ServerRequests>(
                                          context,
                                          listen: false)
                                      .getUser(store.getString('token'),
                                          store.getBool('userType'));
                                } on PlatformException catch (e) {
                                  print(e.code);
                                  //TODO:SERVER DOWN CLOSE APP
                                  await errorBox(context, e);
                                }
                                if (json != null) {
                                  Provider.of<AppUser>(context, listen: false)
                                      .fromServer(
                                          json); //SETTING THE AppUSER IN PROVIDER
                                  //check profile complete or not
                                  final jsonObj = jsonDecode(json);
                                  if (jsonObj['data']['verified'] == false) {
                                    //Email & Pass SignUp
                                    //EMAIL LEFT ->Phone and hostel left
                                    bool success;
                                    try {
                                      success =
                                          await Provider.of<ServerRequests>(
                                                  context,
                                                  listen: false)
                                              .regenerateOtp();
                                    } on PlatformException catch (e) {
                                      print(e.code);
                                      //TODO ASK WHAT AGAIN SIGN OR what
                                      //CRASH APP ERROR
                                      await errorBox(context, e);
                                      success = false;
                                    }
                                    if (success) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OTP2(),
                                        ),
                                      );
                                    }
                                  } else if (jsonObj['data']['verified'] ==
                                          true &&
                                      jsonObj['data']['phone'] == null) {
                                    //Email verified
                                    //PHONE AND HOSTEL LEFT
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            OTP1(),
                                      ),
                                    );
                                  } else if (jsonObj['data']['verified'] ==
                                          true &&
                                      jsonObj['data']['phone'] != null &&
                                      jsonObj['data']['hostel'] == null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProfileBuilder(
                                                appUser: Provider.of<AppUser>(
                                                    context,
                                                    listen: false)),
                                      ),
                                    );
                                  } else {
                                    //FULL USER PROFILE COMPLETE
                                    //SHOPKEEPER CHECK
                                    List<dynamic> shops =
                                        jsonObj['data']['shops'];
                                    if (store.getBool('userType') == false &&
                                        shops.isEmpty) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ShopProfile(),
                                        ),
                                      );
                                    } else
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HomePage(),
                                        ),
                                      );
                                  }
                                }
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 38 / 6.4 * boxSizeV,
                            // width: 132 / 3.6 * boxSizeH,
                            padding: EdgeInsets.only(
                              left: 50 / 3.6 * boxSizeH,
                              right: 60 / 3.6 * boxSizeH,
                            ),
                            margin: EdgeInsets.only(
                              top: 20 / 6.4 * boxSizeV,
                              left: 80 / 3.6 * boxSizeH,
                              right: 80 / 3.6 * boxSizeH,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xffCBCBCB)),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Icon(FontAwesomeIcons.google),
                                SvgPicture.asset(
                                  'assets/google.svg',
                                  height: 18 * boxSizeV / 6.4,
                                  width: 18 * boxSizeH / 3.6,
                                ),
                                Text(
                                  'Google',
                                  style: josefinSansR10.copyWith(
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
