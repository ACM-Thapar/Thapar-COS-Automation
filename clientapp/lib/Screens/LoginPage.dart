import 'package:clientapp/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Services/User.dart';
import '../Variables.dart';
import './Registeruserpage.dart';
import './HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (_) => false);
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
                            // UserCredential userCredentials;
                            // try {
                            //   userCredentials = await Provider.of<Auth>(context,
                            //           listen: false)
                            //       .googleAuth(Provider.of<AppUser>(context,
                            //               listen: false)
                            //           .user);
                            // } on PlatformException catch (pltfmError) {
                            //   //TODO :SHOW ERROR LOGIN
                            //   print(pltfmError.message);
                            //   print('VALUE OF userCreds::::: $userCredentials');
                            // } catch (otherError) {
                            //   //TODO :SHOW ERROR LOGIN
                            //   print('otherError :::::  $otherError');
                            //   print('VALUE OF userCreds::::: $userCredentials');
                            // }
                            // if (userCredentials != null) {
                            //   User firebaseUser = userCredentials
                            //       .user; //Getting FirebaseUser from Credentials
                            //   Provider.of<AppUser>(context, listen: false)
                            //       .setFirebaseuser(
                            //           firebaseUser:
                            //               firebaseUser); //Setting FirebaseUser for whole APP
                            //   Provider.of<AppUser>(context, listen: false)
                            //       .setProfile(
                            //     name: firebaseUser.displayName,
                            //     email: firebaseUser.email,
                            //     password: firebaseUser.uid,
                            //     phone: firebaseUser.phoneNumber,
                            //   ); //Setting profile for user
                            //   // Provider.of<AppUser>(context, listen: false)
                            //   //     .printUser();
                            //   Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(
                            //       builder: (context) => HomePage(),
                            //     ),
                            //   );
                            // }
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
