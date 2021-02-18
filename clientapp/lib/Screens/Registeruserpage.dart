import 'package:clientapp/Services/User.dart';
import 'package:clientapp/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Variables.dart';
import './OTP_Verification/OTP-1.dart';

class Registeruser extends StatefulWidget {
  @override
  _RegisteruserState createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
  String email;
  String password;
  bool eText = true, pText = true;
  @override
  Widget build(BuildContext context) {
    print(store.getBool('userType'));
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Container(
                  height: 176 / 6.4 * boxSizeV,
                  width: 100 * boxSizeH,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/MaskGroup2.png'),
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
                          top: 123 / 6.4 * boxSizeV,
                          left: 36 / 3.6 * boxSizeH,
                        ),
                        child: Text(
                          'Create A New\nAccount',
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
                      GestureDetector(
                        onTap: () {
                          // Provider.of<AppUser>(context, listen: false)
                          //         .gSign = false;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTP1(),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 58 / 6.4 * boxSizeV,
                          width: 291 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 33 / 6.4 * boxSizeV,
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
                      ),
                      Container(
                          margin: EdgeInsets.only(
                            top: 20 / 6.4 * boxSizeV,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account ? ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //BACK TO LOGIN
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: Text(
                                  'Sign In',
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
                            UserCredential userCredentials;
                            try {
                              userCredentials = await Provider.of<Auth>(context,
                                      listen: false)
                                  .googleAuth(); //GOOGLE SIGN IN TO GET FirebaseUserCredentials
                            } on PlatformException catch (pltfmError) {
                              //TODO :SHOW ERROR Register
                              print('PLTFM EXCPT : ${pltfmError.message}');
                            } catch (otherError) {
                              //TODO :SHOW ERROR LOGIN
                              print('OTHER ERROR : $otherError');
                            }
                            if (userCredentials != null) {
                              User firebaseUser = userCredentials
                                  .user; //Getting FirebaseUser from Credentials
                              Provider.of<AppUser>(context, listen: false)
                                  .fromFirebase(
                                      firebaseUser); //Setting profile for user

                              // Provider.of<AppUser>(context, listen: false)
                              //     .printUser();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => OTP1(),
                                ),
                              );
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
