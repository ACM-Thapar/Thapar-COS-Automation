import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/Services/ServerRequests.dart';
import 'package:user/Modals/User.dart';
import 'package:user/Services/auth.dart';

import '../Variables.dart';
import '../ErrorBox.dart';
import './OTP_Verification/OTP-2.dart';
import 'OTP_Verification/OTP-1.dart';

// TODO: ADD ERROR CHECKS ON Form FIELDS
class Registeruser extends StatefulWidget {
  @override
  _RegisteruserState createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
  FocusNode _emailFocus, _passFocus, _nameFocus, _escapeNode;
  String _email, _password, _name;
  TextEditingController _emailController, _nameController, _passwordController;
  bool eText = true, pText = true, nText = true, hidePass = true;

  @override
  void initState() {
    _emailFocus = FocusNode();
    _escapeNode = FocusNode();
    _passFocus = FocusNode();
    _nameFocus = FocusNode();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _escapeNode.dispose();
    _passFocus.dispose();
    _nameFocus.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    return OrientationBuilder(
      builder: (context, orientation) => WillPopScope(
        //redirects to login
        onWillPop: () => Future.delayed(Duration(), () => true),
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
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 14,
                            top: 134,
                            left: orientation == Orientation.portrait ? 40 : 70,
                          ),
                          child: Text(
                            'Create A New\nAccount',
                            style: robotoB37.copyWith(
                                color: Colors.black, height: 1.3),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal:
                                orientation == Orientation.portrait ? 42 : 72,
                          ),
                          child: TextField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            focusNode: _nameFocus,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                                nText = !(_name == null || _name == '');
                              });
                            },
                            onSubmitted: (v) {
                              print(v);
                              FocusScope.of(context).requestFocus(_emailFocus);
                            },
                            style: openSansR14.copyWith(color: Colors.black),
                            cursorColor: Color(0xffFFCB00),
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              errorText: nText ? null : 'Enter Name',
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
                          decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal:
                                orientation == Orientation.portrait ? 40 : 70,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              if (_name != null &&
                                  _password != null &&
                                  _email != null) //CONDITION FOR CHECK FIELDS
                              {
                                if ((RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@thapar\.edu$")
                                        .hasMatch(_email)) &&
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
                                    name: _name,
                                    email: _email,
                                    password: _password,
                                  ); //SET AppUSER in Provider
                                  bool success;
                                  try {
                                    success = await Provider.of<ServerRequests>(
                                            context,
                                            listen: false)
                                        .registerForm(Provider.of<AppUser>(
                                            context,
                                            listen:
                                                false)); //SEND EMAIL OTP FROM SERVER
                                  } on PlatformException catch (exp) {
                                    Navigator.pop(
                                        context); //Remove Circular Indicator
                                    //SHOW ERROR
                                    await errorBox(context, exp);
                                    success = false;
                                  }
                                  if (success) {
                                    //FIREBASE REGISTER
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .formAuth(
                                            email: _email,
                                            password:
                                                _password); //This Will never throw error
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OTP2(),
                                      ),
                                      (_) => false,
                                    );
                                  }
                                }
                              } else
                                setState(() {
                                  eText = !(_email == null);
                                  pText = !(_password == null);

                                  nText = !(_name == null);
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
                                'Register Now',
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
                                Text('Already have an account ? ',
                                    style: josefinSansSB14.copyWith(
                                        color: Colors.black)),
                                GestureDetector(
                                  onTap: () {
                                    //BACK TO LOGIN
                                    Navigator.pop(context);
                                  },
                                  child: Text('Sign In',
                                      style: josefinSansSB14.copyWith(
                                          color: Color(0xffFFCB00))),
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
                            horizontal:
                                orientation == Orientation.portrait ? 85 : 200,
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
                              UserCredential userCredentials;
                              try {
                                userCredentials = await Provider.of<Auth>(
                                        context,
                                        listen: false)
                                    .googleAuth(); //GOOGLE SIGN IN TO GET FirebaseUserCredentials
                              } on PlatformException catch (pltfmError) {
                                Navigator.pop(
                                    context); //Remove Circular Indicator
                                //SHOW ERROR Register
                                await errorBox(context, pltfmError);
                              }
                              if (userCredentials != null) {
                                User firebaseUser = userCredentials
                                    .user; //Getting FirebaseUser from Credentials
                                Provider.of<AppUser>(context, listen: false)
                                    .fromFirebase(
                                        firebaseUser); //Setting profile for user
                                bool success;
                                try {
                                  success = await Provider.of<ServerRequests>(
                                          context,
                                          listen: false)
                                      .registerGoogle(Provider.of<AppUser>(
                                          context,
                                          listen:
                                              false)); //CHECKS FOR DUPLICATE USER
                                } on PlatformException catch (exp) {
                                  Navigator.pop(
                                      context); //Remove Circular Indicator
                                  //SHOW ERROR
                                  await errorBox(context, exp);
                                  success = false;
                                }
                                if (success) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => OTP1(),
                                    ),
                                    (_) => false,
                                  );
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
                                  bottom: BorderSide(color: Color(0xffCBCBCB)),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
      ),
    );
  }
}
