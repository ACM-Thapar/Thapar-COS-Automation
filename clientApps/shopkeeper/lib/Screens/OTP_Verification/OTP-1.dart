import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../Screens/LoginPage.dart';
import '../../Screens/Intro/Intro1.dart';
import '../../Services/User.dart';
import '../../Services/auth.dart';
import '../../Services/ServerRequests.dart';
import '../../Variables.dart';
import '../../WidgetResizing.dart';
import '../../ErrorBox.dart';

// TODO : CHECK FOR THE SMS VERIFICATION UPDATE AS IT IS NOT YET IMPLEMENTED CAN ONLY GIVE AUTO VERIFICATION

class OTP1 extends StatefulWidget {
  @override
  _OTP1State createState() => _OTP1State();
}

class _OTP1State extends State<OTP1> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
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
                style: josefinSansSB14.copyWith(color: Color(0xff707070)),
                children: [
                  TextSpan(
                    text: 'One Time Password',
                    style: josefinSansSB14.copyWith(color: Colors.black),
                  ),
                  TextSpan(text: ' on this mobile number'),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 34 * boxSizeV / 6.4,
          ),
          Container(
            child: Text(
              'Enter Mobile Number',
              style: josefinSansSB14.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 19 * boxSizeV / 6.4),
          Container(
            padding: EdgeInsets.only(right: 15 * boxSizeH),
            // decoration: BoxDecoration(border: Border.all()),
            child: InternationalPhoneNumberInput(
              textFieldController: phoneController,
              autoValidateMode: AutovalidateMode.always,
              selectorTextStyle: josefinSansSB20.copyWith(
                color: Colors.black,
              ),
              autoFocus: true,
              keyboardAction: TextInputAction.done,
              textStyle: josefinSansSB20.copyWith(
                color: Colors.black,
              ),
              inputDecoration: InputDecoration(
                  border: UnderlineInputBorder(), hintText: 'Phone Number'),
              onInputChanged: (value) {
                phone = value;
              },
              onFieldSubmitted: (no) async {
                if (phone != null && phone.parseNumber().length == 10) {
                  await phoneVerify(phone.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                        'Enter the correct phone number',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              countries: ['IN'],
            ),
          ),
          SizedBox(height: 34.5 * boxSizeV / 6.4),
          GestureDetector(
            onTap: () async {
              if (phone != null && phone.parseNumber().length == 10) {
                await phoneVerify(phone.toString());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'Enter the correct phone number',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
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
                style: josefinSansR18.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 15 * boxSizeV / 6.4),
          // Container(
          //     // padding: EdgeInsets.symmetric(horizontal: 2 * boxSizeH),
          //     // decoration: BoxDecoration(border: Border.all()),
          //     child: RichText(
          //         maxLines: 2,
          //         textAlign: TextAlign.center,
          //         text: TextSpan(
          //             text: 'Note:',
          //             style: GoogleFonts.josefinSans(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 16,
          //                 color: Colors.black),
          //             children: [
          //               TextSpan(
          //                   text: ' Make sure this is your mobile\'s ',
          //                   style: TextStyle(
          //                       fontSize: 15,
          //                       fontWeight: FontWeight.normal,
          //                       color: Colors.black54)),
          //               TextSpan(text: 'SIM-1')
          //             ])))
        ],
      );

  Future<void> phoneVerify(String phone) async {
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
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 40),
        phoneNumber: phone,
        verificationCompleted: /*VERIFICATION COMPLETES AUTOMATICALLY*/ (PhoneAuthCredential
            phoneAuthCredential) async {
          if (phoneAuthCredential.token != null) {
            Provider.of<AppUser>(context, listen: false).setPhone(phone);
            bool success;
            try {
              success = await Provider.of<ServerRequests>(context,
                      listen: false)
                  .updateProfile(Provider.of<AppUser>(context, listen: false));
            } on PlatformException catch (e) {
              //SHOW ERROR ON UPDATE PROFILE
              await errorBox(context, e);
              success = false;
            }
            if (success) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Intro1(),
                ),
                (_) => false,
              );
            }
          } else {
            Navigator.pop(context); //Remove Circular indicator
            await errorBox(
              context,
              PlatformException(
                  code: 'Something went wrong',
                  message: 'Something went wrong. Try again after sometime.',
                  details: 'single'),
            );
          }
        },
        verificationFailed: (FirebaseAuthException authException) async {
          Navigator.pop(context); //Remove Circular indicator
          await errorBox(
            context,
            PlatformException(
                code: 'Something went wrong',
                message: 'Something went wrong. Try again after sometime.',
                details: 'single'),
          );
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          print('SENT');
          // this._verificationId = verificationId;
          // print(_verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          print('TIMEOUT');
          Navigator.pop(
              context); //ERROR PHONE AUTH NOT DONE TRY AGAIN AFTERWARDS
          await errorBox(
            context,
            PlatformException(
                code: 'Error phone not verified',
                message:
                    'OTP not recieved in time.Needs strong network.Try again after sometime',
                details: 'single'),
          );
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
      onWillPop: () async {
        bool val = await errorBox(
          context,
          PlatformException(
            code: 'Logout & Exit',
            message: 'Are you sure you want to logout and exit?',
            details: 'double',
          ),
        );
        print(val);
        if (val) {
          await Provider.of<Auth>(context, listen: false).logOut();
          store.clear();
          // exit(0);
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
      // => Future.delayed(
      //     Duration(),
      //     () =>
      //          sms
      //             ? {
      //                 setState(() {
      //                   sms = !sms;
      //                 }),
      //                 false
      //               }
      //             :
      //         true),
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
                        onTap: () async {
                          print("BACK");
                          //Ask for logout
                          bool val = await errorBox(
                            context,
                            PlatformException(
                              code: 'Logout',
                              message: 'Are you sure you want to logout?',
                              details: 'double',
                            ),
                          );
                          print(val);
                          if (val) {
                            await Provider.of<Auth>(context, listen: false)
                                .logOut();
                            store.clear();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                                (route) => false);
                          }
                        },

                        //CODE FOR SMS AND AUTO
                        // if (sms) {
                        //   setState(() {
                        //     sms = !sms;
                        //   });
                        // } else {
                        //   // GO BACK TO USERTYPE
                        // }
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
