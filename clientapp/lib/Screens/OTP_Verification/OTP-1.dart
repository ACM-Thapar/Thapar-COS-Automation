import 'package:clientapp/Screens/Intro/Intro1.dart';
import 'package:clientapp/Services/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';

import '../../PageResizing/Variables.dart';

class OTP1 extends StatefulWidget {
  @override
  _OTP1State createState() => _OTP1State();
}

class _OTP1State extends State<OTP1> {
  bool sms = false;
  PhoneNumber phone;
  String _verificationId, _smsCode;
  TextEditingController phoneController, smsController;

  Widget _buildPhone() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2 * boxSizeH),
            // decoration: BoxDecoration(border: Border.all()),
            child: RichText(
              maxLines: 2,
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'We will send you a ',
                style: GoogleFonts.josefinSans(
                    fontSize: 22, color: Colors.black54),
                children: [
                  TextSpan(
                      text: 'One Time Password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(text: ' on this mobile number'),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 34 * boxSizeV / 6.4,
          ),
          Container(
            child: Text('Enter Mobile Number',
                style: GoogleFonts.josefinSans(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 19 * boxSizeV / 6.4),
          Container(
            padding: EdgeInsets.only(right: 15 * boxSizeH),
            // decoration: BoxDecoration(border: Border.all()),
            child: InternationalPhoneNumberInput(
              textFieldController: phoneController,
              autoValidate: true,
              selectorTextStyle: GoogleFonts.josefinSans(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              autoFocus: true,
              keyboardAction: TextInputAction.done,
              textStyle: GoogleFonts.josefinSans(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              inputDecoration: InputDecoration(
                  border: UnderlineInputBorder(), hintText: 'Phone Number'),
              onInputChanged: (value) {
                phone = value;
                Provider.of<AppUser>(context, listen: false)
                    .setProfile(phone: value.parseNumber());
              },
              onFieldSubmitted: (no) async {
                if (phone.parseNumber().length == 10) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => WillPopScope(
                      onWillPop: () {
                        print('WORKING');
                      },
                      child: Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  );
                  await phoneVerify(phone.toString());
                }
              },
              countries: ['IN'],
            ),
          ),
          SizedBox(height: 34.5 * boxSizeV / 6.4),
          GestureDetector(
            onTap: () async {
              if (phone.parseNumber().length == 10) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => WillPopScope(
                    onWillPop: () {
                      print('WORKING');
                    },
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
                await phoneVerify(phone.toString());
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: 291 * boxSizeH / 3.6,
              height: 58 * boxSizeV / 6.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Colors.black,
              ),
              child: Text(
                'Get OTP',
                style: GoogleFonts.josefinSans(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      );
  Widget _buildSMS() => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2 * boxSizeH),
            // decoration: BoxDecoration(border: Border.all()),
            child: RichText(
              maxLines: 2,
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Enter the OTP sent to\n',
                style: GoogleFonts.josefinSans(
                    fontSize: 22, color: Colors.black54),
                children: [
                  TextSpan(
                      text:
                          '+91- ${Provider.of<AppUser>(context, listen: false).phone}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 34 * boxSizeV / 6.4,
          ),
          Container(
            child: OTPTextField(
              width: 300 * boxSizeH / 3.6,
              fieldWidth: 40 * boxSizeH / 3.6,
              style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black),
              length: 6,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              onChanged: (v) {
                _smsCode = v;
              },
              onCompleted: (v) {
                _smsCode = v;
              },
            ),
          ),
          SizedBox(height: 34.5 * boxSizeV / 6.4),
          GestureDetector(
            onTap: () async {
              if (_smsCode.length != 6) {
                print('ERROR NOT COMPLETE CODE');
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => WillPopScope(
                    onWillPop: () {
                      print('WORKING');
                    },
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
                if (await _verify(PhoneAuthProvider.credential(
                    verificationId: _verificationId, smsCode: _smsCode))) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Intro1(),
                    ),
                  );
                }
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: 291 * boxSizeH / 3.6,
              height: 58 * boxSizeV / 6.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Colors.black,
              ),
              child: Text(
                'Verify and Proceed',
                style: GoogleFonts.josefinSans(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      );
  Future<bool> _verify(PhoneAuthCredential creds) async {
    final userCreds = await Provider.of<AppUser>(context,
            listen: false) //LINKING THE PHONE NUMBER
        .firebaseUser
        .linkWithCredential(creds)
        .catchError((error) {
      print("Failed to verify SMS code: $error");
      Navigator.of(context).pop();
    });
    if (userCreds != null) {
      Provider.of<AppUser>(context, listen: false).setFirebaseuser(
          //SETTING VERFIED FirebaseUser
          firebaseUser: userCreds.user);
    }
    if (Provider.of<AppUser>(context, listen: false).firebaseUser != null &&
        Provider.of<AppUser>(context, listen: false).firebaseUser.phoneNumber !=
            null &&
        Provider.of<AppUser>(context, listen: false)
            .firebaseUser
            .phoneNumber
            .isNotEmpty)
      return true;
    else
      return false;
  }

  Future<void> phoneVerify(String phone) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 2),
        phoneNumber: phone,
        verificationCompleted: /*LINKING COMPLETES AUTOMATICALLY*/ (PhoneAuthCredential
            phoneAuthCredential) async {
          if (await _verify(phoneAuthCredential)) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Intro1(),
            ));
          } else {
            print('COULD NOT VERIFY PHONE TRY AGAIN');
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          print('ERROR MESSAGE:::${authException.message}');
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          this._verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this._verificationId = verificationId;
          Navigator.pop(context);
          setState(() {
            sms = !sms;
          });
        });
  }

  @override
  void initState() {
    phoneController = TextEditingController();
    smsController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 100 * boxSizeV,
          width: 100 * boxSizeH,
          padding: EdgeInsets.symmetric(
              vertical: 19 * boxSizeV / 6.4, horizontal: 34 * boxSizeH / 3.6),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () {
                        if (sms) {
                          setState(() {
                            sms = !sms;
                          });
                        } else {
                          // TODO :GO BACK TO SIGNUP
                        }
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 32,
                      )),
                  // decoration: BoxDecoration(border: Border.all()),
                ),
                SizedBox(
                  height: 92 * boxSizeV / 6.4,
                ),
                Container(
                  height: 113.92 * boxSizeV / 6.4,
                  width: 74.3 * boxSizeH / 3.6,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/Group42.png'),
                          fit: BoxFit.fill)),
                ),
                SizedBox(
                  height: 33 * boxSizeV / 6.4,
                ),
                Container(
                  child: Text(
                    'OTP Verification',
                    style: GoogleFonts.josefinSans(
                        fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 24 * boxSizeV / 6.4,
                ),
                AnimatedSwitcher(
                  duration: Duration(seconds: 2),
                  child: sms ? _buildSMS() : _buildPhone(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
