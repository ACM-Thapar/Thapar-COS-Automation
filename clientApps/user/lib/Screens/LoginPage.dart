import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Modals/User.dart';
import '../Services/ServerRequests.dart';
import '../Modals/Shop.dart';
import '../Services/auth.dart';
import '../ErrorBox.dart';
import '../Variables.dart';
import './Registeruserpage.dart';
import './HomePage.dart';
import './Builder.dart';
import './OTP_Verification/OTP-1.dart';
import './OTP_Verification/OTP-2.dart';

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
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _emailFocus = FocusNode();
    _escapeNode = FocusNode();
    _passFocus = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _escapeNode.dispose();
    _passFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    return OrientationBuilder(
      builder: (context, orientation) {
        print("Orientation: $orientation");
        return WillPopScope(
          onWillPop: () async {
            //EXIT APP ERROR
            // print('EXIT APP');
            bool val = await errorBox(
              context,
              PlatformException(
                code: 'Exit',
                message: 'Are you sure you want to exit the app?',
                details: 'double',
              ),
            );
            print(val);
            if (val) {
              // exit(0);
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
            return false;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        "assets/LoginSvg.svg",
                        width: pageWidth,
                        // height: 192,
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      // width: 100 * boxSizeH,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 14,
                              top: 134,
                              left:
                                  orientation == Orientation.portrait ? 40 : 70,
                            ),
                            child: Text(
                              'Welcome!',
                              style: robotoB45.copyWith(color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal:
                                  orientation == Orientation.portrait ? 42 : 72,
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
                                        ? RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@thapar\.edu$")
                                                .hasMatch(_email)
                                            ? null
                                            : 'Please enter valid Thapar email'
                                        : null
                                    : 'Enter the email',
                                fillColor: Color(0x80F8F8F8),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 0.5,
                                    color: Color(0xffCBCBCB),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xffFFCB00),
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red,
                                  ),
                                ),
                                hintStyle: openSansL14.copyWith(
                                    color: Color(0xAB707070)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal:
                                  orientation == Orientation.portrait ? 42 : 72,
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
                                  pText =
                                      !(_password == null || _password == '');
                                });
                              },
                              onSubmitted: (v) {
                                print(v);
                                FocusScope.of(context)
                                    .requestFocus(_escapeNode);
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
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 0.5,
                                    color: Color(0xffCBCBCB),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xffFFCB00),
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal:
                                  orientation == Orientation.portrait ? 45 : 75,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print("NOT IMPLEMENTED");
                              },
                              child: Container(
                                alignment: orientation == Orientation.portrait
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  'Forget Password!',
                                  style: josefinSansSB14.copyWith(
                                      color: Color(0xffFFCB00)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal:
                                  orientation == Orientation.portrait ? 40 : 70,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                if (_email != null &&
                                    _password !=
                                        null) //CONDITION FOR CHECK FIELDS
                                {
                                  if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@thapar\.edu$")
                                          .hasMatch(_email) &&
                                      _password.length > 5) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => WillPopScope(
                                        onWillPop: () => Future.delayed(
                                            Duration(), () => false),
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
                                    print("PASSWORD: $_password");
                                    bool success1;
                                    try {
                                      success1 =
                                          await Provider.of<ServerRequests>(
                                                  context,
                                                  listen: false)
                                              .login(Provider.of<AppUser>(
                                                  context,
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
                                        json =
                                            await Provider.of<ServerRequests>(
                                                    context,
                                                    listen: false)
                                                .getUser();
                                      } on PlatformException catch (e) {
                                        print(e.code);
                                        //TODO:SERVER DOWN CLOSE APP
                                        await errorBox(context, e);
                                      }
                                      if (json != null) {
                                        Provider.of<AppUser>(context,
                                                listen: false)
                                            .fromServer(
                                                json); //SETTING THE AppUSER IN PROVIDER
                                        //check profile complete or not
                                        final jsonObj = jsonDecode(json);
                                        if (jsonObj['data']['verified'] ==
                                            false) {
                                          //Email & Pass SignUp
                                          //EMAIL LEFT ->Phone and hostel left
                                          bool success;
                                          try {
                                            success = await Provider.of<
                                                        ServerRequests>(context,
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
                                                builder:
                                                    (BuildContext context) =>
                                                        OTP2(),
                                              ),
                                            );
                                          }
                                        } else if (jsonObj['data']
                                                    ['verified'] ==
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
                                        } else if (jsonObj['data']
                                                    ['verified'] ==
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
                                                    listen: false),
                                                edit: false,
                                              ),
                                            ),
                                          );
                                        } else {
                                          //FULL USER PROFILE COMPLETE
                                          //GET ALL SHOPS
                                          final List<dynamic> list =
                                              await Provider.of<ServerRequests>(
                                                      context,
                                                      listen: false)
                                                  .getShops();
                                          list.forEach((element) {
                                            Shop.fromjson(element);
                                            shops.add(Shop.fromjson(element));
                                          });
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
                                    pText =
                                        !(_password == null || _password == '');
                                  });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 25),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.black,
                                ),
                                child: Text(
                                  'Log In',
                                  style: josefinSansR18.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 25,
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
                                    onTap: () {
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
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: Divider(
                                      thickness: 1,
                                      color: Color(0x80707070),
                                    ),
                                    width: orientation == Orientation.portrait
                                        ? 100
                                        : 200,
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
                                    width: orientation == Orientation.portrait
                                        ? 100
                                        : 200,
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: orientation == Orientation.portrait
                                  ? 85
                                  : 200,
                            ),
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
                                  _userCredential = await Provider.of<Auth>(
                                          context,
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
                                  print(
                                      "PASSWORD: ${Provider.of<AppUser>(context, listen: false).password}");
                                  bool success1;
                                  try {
                                    success1 =
                                        await Provider.of<ServerRequests>(
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
                                          .getUser();
                                    } on PlatformException catch (e) {
                                      print(e.code);
                                      //TODO:SERVER DOWN CLOSE APP
                                      await errorBox(context, e);
                                    }
                                    if (json != null) {
                                      Provider.of<AppUser>(context,
                                              listen: false)
                                          .fromServer(
                                              json); //SETTING THE AppUSER IN PROVIDER
                                      //check profile complete or not
                                      final jsonObj = jsonDecode(json);
                                      if (jsonObj['data']['verified'] ==
                                          false) {
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
                                                  listen: false),
                                              edit: false,
                                            ),
                                          ),
                                        );
                                      } else {
                                        //FULL USER PROFILE COMPLETE
                                        //GET ALL SHOPS
                                        final List<dynamic> list =
                                            await Provider.of<ServerRequests>(
                                                    context,
                                                    listen: false)
                                                .getShops();
                                        list.forEach((element) {
                                          Shop.fromjson(element);
                                          shops.add(Shop.fromjson(element));
                                        });
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
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border(
                                    top: BorderSide(color: Color(0xffCBCBCB)),
                                    left: BorderSide(color: Color(0xffCBCBCB)),
                                    right: BorderSide(color: Color(0xffCBCBCB)),
                                    bottom:
                                        BorderSide(color: Color(0xffCBCBCB)),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Icon(FontAwesomeIcons.google),
                                    SvgPicture.asset(
                                      'assets/google.svg',
                                      height: 22,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Google',
                                      style: josefinSansR14.copyWith(
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
      },
    );
  }
}
