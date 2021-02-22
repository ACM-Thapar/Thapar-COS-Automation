import 'package:clientapp/Services/ServerRequests.dart';
import 'package:clientapp/Services/User.dart';
import 'package:clientapp/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Variables.dart';
import './OTP_Verification/OTP-2.dart';
import 'OTP_Verification/OTP-1.dart';

// TODO: ADD ERROR CHECKS ON Form FIELDS
class Registeruser extends StatefulWidget {
  @override
  _RegisteruserState createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
  String _email, _password, _name;
  TextEditingController _emailController, _nameController, _passwordController;
  bool eText = true, pText = true, nText = true;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.delayed(Duration(), () => true),
      child: SafeArea(
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
                          height: 50 / 6.4 * boxSizeV,
                          width: 291 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 32 / 6.4 * boxSizeV,
                            left: 35 / 3.6 * boxSizeH,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                          ),
                          child: TextField(
                            controller: _nameController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Full Name',
                              errorText: !nText ? 'Enter Name' : null,
                              hintStyle: TextStyle(fontSize: 18),
                              focusColor: Colors.blue[800],
                            ),
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                                nText = !(_name == null);
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 50 / 6.4 * boxSizeV,
                          width: 291 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 20 / 6.4 * boxSizeV,
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
                              hintStyle: TextStyle(fontSize: 18),
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
                          height: 50 / 6.4 * boxSizeV,
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
                              fontSize: 18,
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
                        GestureDetector(
                          onTap: () async {
                            if (_password != null &&
                                _name != null &&
                                _email !=
                                    null) //TODO : CONDITION FOR CHECK FIELDS
                            {
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
                                  //TODO SHOW ERROR
                                  print(exp.code);
                                  success = false;
                                }
                                Navigator.pop(context);
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
                            } else {
                              setState(() {
                                eText = !(_email == null);
                                pText = !(_password == null);

                                nText = !(_name == null);
                              });
                            }
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
                              'Register Now',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 21),
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
                              top: 20 / 6.4 * boxSizeV,
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
                              UserCredential userCredentials;
                              try {
                                userCredentials = await Provider.of<Auth>(
                                        context,
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
                                  //TODO SHOW ERROR
                                  print(exp.code);
                                  success = false;
                                }
                                if (success) {
                                  Navigator.pop(context);
                                  print('Navigating');
                                  // Provider.of<AppUser>(context, listen: false)
                                  //     .printUser();
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
                              height: 38 / 6.4 * boxSizeV,
                              // width: 132 / 3.6 * boxSizeH,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40 / 3.6 * boxSizeH),
                              margin: EdgeInsets.only(
                                top: 10 / 6.4 * boxSizeV,
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
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
