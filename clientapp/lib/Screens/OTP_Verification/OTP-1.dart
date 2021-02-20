import 'package:clientapp/Screens/Intro/Intro1.dart';
import 'package:clientapp/Services/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../Variables.dart';
import '../../WidgetResizing.dart';

class OTP1 extends StatefulWidget {
  @override
  _OTP1State createState() => _OTP1State();
}

class _OTP1State extends State<OTP1> {
  // bool sms = false;
  // String _verificationId, _smsCode;
  PhoneNumber phone;
  TextEditingController phoneController;

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
              },
              onFieldSubmitted: (no) async {
                if (phone.parseNumber().length == 10) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => WillPopScope(
                      onWillPop: () => Future.delayed(Duration(), () => false),
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
                    onWillPop: () => Future.delayed(Duration(), () => false),
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
          ),
          SizedBox(height: 15 * boxSizeV / 6.4),
          Container(
              // padding: EdgeInsets.symmetric(horizontal: 2 * boxSizeH),
              // decoration: BoxDecoration(border: Border.all()),
              child: RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Note:',
                      style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text: ' Make sure this is your mobile\'s ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black54)),
                        TextSpan(text: 'SIM-1')
                      ])))
        ],
      );

  Future<bool> _verify({PhoneAuthCredential creds, User currentUser}) async {
    print('VERIFYING  $creds');
    final userCreds =
        await currentUser.linkWithCredential(creds).catchError((error) {
      print("Failed to verify SMS code: $error");
      Navigator.of(context).pop();
    });
    if (userCreds.user != null &&
        userCreds.user.phoneNumber != null &&
        userCreds.user.phoneNumber.isNotEmpty) {
      print('AFER OTP DONE : ${FirebaseAuth.instance.currentUser.phoneNumber}');
      FirebaseAuth.instance.currentUser.emailVerified
          ? Provider.of<AppUser>(context, listen: false)
              .fromFirebase(userCreds.user)
          : Provider.of<AppUser>(context, listen: false)
              .fromForm(phone: FirebaseAuth.instance.currentUser.phoneNumber);
      return true;
    } else
      return false;
  }

  Future<void> phoneVerify(String phone) async {
    // print('WORKING');
    FirebaseAuth _auth = FirebaseAuth.instance;
    User currentFUser = _auth.currentUser;
    await _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 40),
        phoneNumber: phone,
        verificationCompleted: /*LINKING COMPLETES AUTOMATICALLY*/ (PhoneAuthCredential
            phoneAuthCredential) async {
          print(
              "AUTOMATIC :::  $phoneAuthCredential :::  ${phoneAuthCredential == null}");
          if (await _verify(
              creds: phoneAuthCredential, currentUser: currentFUser)) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Intro1(),
              ),
            );
          } else {
            print('COULD NOT VERIFY PHONE TRY AGAIN');
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          print('ERROR MESSAGE:::${authException.message}');
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          print('SENT');
          // this._verificationId = verificationId;
          // print(_verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('TIMEOUT');
          Navigator.pop(
              context); //TODO ADD ERROR PHONE AUTH NOT DONE TRY AGAIN AFTERWARDS

          // this._verificationId = verificationId;
          // print(_verificationId);
          // setState(() {
          //   sms = !sms;
          // });
        });
  }

  @override
  void initState() {
    phoneController = TextEditingController();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
    return WillPopScope(
      //EXIT APP ERROR
      // print('EXIT APP');
      onWillPop: () => Future.delayed(
          Duration(),
          () =>
              //  sms
              //     ? {
              //         setState(() {
              //           sms = !sms;
              //         }),
              //         false
              //       }
              //     :
              true),
      child: SafeArea(
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
                          //CODE FOR SMS AND AUTO
                          // if (sms) {
                          //   setState(() {
                          //     sms = !sms;
                          //   });
                          // } else {
                          //   // TODO :GO BACK TO SIGNUP
                          // }

                          // TODO :GO BACK TO SIGNUP
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 32,
                        )),
                    // decoration: BoxDecoration(border: Border.all()),
                  ),
                  SizedBox(
                    height: 75 * boxSizeV / 6.4,
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
                  //CODE FOR AUTO AND SMS CHECK
                  // AnimatedSwitcher(
                  //   duration: Duration(seconds: 2),
                  //   child: sms ? _buildSMS() : _buildPhone(),
                  // ),
                  _buildPhone(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// TODO : CHECK FOR THE SMS VERIFICATION UPDATE AS IT IS NOT YET IMPLEMENTED CAN ONLY GIVE AUTO VERIFICATION

// Widget _buildSMS() => Column(
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 2 * boxSizeH),
//           // decoration: BoxDecoration(border: Border.all()),
//           child: RichText(
//             maxLines: 2,
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               text: 'Enter the OTP sent to\n',
//               style: GoogleFonts.josefinSans(
//                   fontSize: 22, color: Colors.black54),
//               children: [
//                 TextSpan(
//                     text:
//                         '+91- ${Provider.of<AppUser>(context, listen: false).phone}',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black)),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 34 * boxSizeV / 6.4,
//         ),
//         Container(
//           child: OTPTextField(
//             width: 300 * boxSizeH / 3.6,
//             fieldWidth: 40 * boxSizeH / 3.6,
//             style: GoogleFonts.josefinSans(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//                 color: Colors.black),
//             length: 6,
//             textFieldAlignment: MainAxisAlignment.spaceAround,
//             onChanged: (v) {
//               _smsCode = v;
//             },
//             onCompleted: (v) {
//               _smsCode = v;
//             },
//           ),
//         ),
//         SizedBox(height: 34.5 * boxSizeV / 6.4),
//         GestureDetector(
//           onTap: () async {
//             if (_smsCode.length != 6) {
//               print('ERROR NOT COMPLETE CODE');
//             } else {
//               showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (context) => WillPopScope(
//                   onWillPop: () {
//                     print('WORKING');
//                   },
//                   child: Dialog(
//                     backgroundColor: Colors.transparent,
//                     elevation: 0,
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                 ),
//               );
//               print(
//                   '_smsCode :: $_smsCode :: _verificationId  ::  $_verificationId');
//               // await _getValue(_verificationId, _smsCode);
//               final creds = await PhoneAuthProvider.credential(
//                   verificationId: _verificationId, smsCode: _smsCode);
//               print('CREDS : $creds   :::: ${creds == null}');
//               if (await _verify(creds)) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Intro1(),
//                   ),
//                 );
//               }
//             }
//           },
//           child: Container(
//             alignment: Alignment.center,
//             width: 291 * boxSizeH / 3.6,
//             height: 58 * boxSizeV / 6.4,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(14)),
//               color: Colors.black,
//             ),
//             child: Text(
//               'Verify and Proceed',
//               style: GoogleFonts.josefinSans(
//                 fontSize: 24,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         )
//       ],
//     );
