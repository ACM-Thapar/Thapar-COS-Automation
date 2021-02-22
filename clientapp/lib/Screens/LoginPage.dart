import 'package:clientapp/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Services/User.dart';
import '../Services/ServerRequests.dart';
import '../Variables.dart';
import './Registeruserpage.dart';
import './HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  TextEditingController _emailController, _passwordController;
  bool eText = true, pText = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.delayed(Duration(), () => true);
      },
      child: SafeArea(
        child: Scaffold(
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
                          color: Color(0xffF8F8F8),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Email',
                            errorText: eText
                                ? _email != null
                                    ? _email.contains('@thapar.edu') &&
                                            _email.substring(
                                                    _email.indexOf('@')) ==
                                                '@thapar.edu'
                                        ? null
                                        : 'Please enter Thapar Id'
                                    : null
                                : 'Enter the email',
                            hintStyle: TextStyle(fontSize: 22),
                            focusColor: Colors.blue[800],
                          ),
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                              eText = !(_email == null || _email == '');
                            });
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
                          color: Color(0xffF8F8F8),
                        ),
                        child: TextField(
                          obscureText: true,
                          controller: _passwordController,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Password',
                            errorText: pText
                                ? _password != null
                                    ? _password.length < 6
                                        ? 'Password must have atleast 6 characters'
                                        : null
                                    : null
                                : 'Enter the password',
                            hintStyle: TextStyle(fontSize: 18),
                            focusColor: Colors.blue[800],
                          ),
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                              pText = !(_password == null || _password == '');
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 13 / 6.4 * boxSizeV,
                          left: 222 / 3.6 * boxSizeH,
                        ),
                        child: Text(
                          'Forget Password!',
                          style: TextStyle(
                            color: Color(0xffFFCB00),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_email != null && _password != null) {
                            if (_email.contains('@thapar.edu') &&
                                _email.substring(_email.indexOf('@')) ==
                                    '@thapar.edu') {
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
                              // final user = FirebaseAuth.instance.currentUser; //ALWAYS NULL
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
                                        listen:
                                            false)); //Profile will be complete always phir bhi check once
                              } on PlatformException catch (exp) {
                                //TODO SHOW ERROR
                                print(exp.code);
                              }
                              if (success1) {
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                  (_) => false,
                                );
                              }
                            }
                          } else
                            setState(() {
                              eText = !(_email == null);
                              pText = !(_password == null);
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
                            style: TextStyle(color: Colors.white, fontSize: 21),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
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
                                  style: TextStyle(
                                    color: Color(0xffFFCB00),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
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
                                ' Or sign in with ',
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
                              //TODO: SHOW ERROR
                              print(pltError.code);
                            } catch (e) {
                              //OTHER ERROR
                              print(e);
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
                                        listen:
                                            false)); //Profile will be complete always phir bhi check once
                              } on PlatformException catch (exp) {
                                //TODO SHOW ERROR
                                print(exp.code);
                                success1 = false;
                                Navigator.of(context).pop();
                              }
                              if (success1) {
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                  (_) => false,
                                );
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 38 / 6.4 * boxSizeV,
                            // width: 132 / 3.6 * boxSizeH,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40 / 3.6 * boxSizeH),
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
                            child: Text(
                              'Google',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
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
