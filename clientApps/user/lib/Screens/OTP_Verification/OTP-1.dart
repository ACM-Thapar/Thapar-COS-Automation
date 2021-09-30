import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:user/Screens/LoginPage.dart';

import '../../Screens/Intro/Intro1.dart';
import '../../Modals/User.dart';
import '../../Services/auth.dart';
import '../../Services/ServerRequests.dart';
import '../../Variables.dart';
import '../../ErrorBox.dart';
import '../../WidgetResizing.dart';

// TODO : CHECK FOR THE SMS VERIFICATION UPDATE AS IT IS NOT YET IMPLEMENTED CAN ONLY GIVE AUTO VERIFICATION

class OTP1 extends StatefulWidget {
  @override
  _OTP1State createState() => _OTP1State();
}

class _OTP1State extends State<OTP1> {
  PhoneNumber phone;
  TextEditingController phoneController;
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
          print('SENT $verificationId, $forceResendingToken');
          // this._verificationId = verificationId;
          // print(_verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          print('TIMEOUT $verificationId');
          Navigator.pop(
              context); //ERROR PHONE AUTH NOT DONE TRY AGAIN AFTERWARDS
          print(
              "CREDENTIALS: ${PhoneAuthProvider.credential(verificationId: verificationId, smsCode: '618085')}");
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
    return OrientationBuilder(
      builder: (context, orientation) => WillPopScope(
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
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  snap: false,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () async {
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
                  ),
                  backgroundColor: Colors.white,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    MediaQuery.of(context).size.width > 600
                        ? [
                            Row(children: [
                              Expanded(
                                child: SvgPicture.asset(
                                    'assets/PhoneVerify.svg',
                                    height: 250),
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: RichText(
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'OTP Verification\n',
                                        style: josefinSansB28.copyWith(
                                            color: Colors.black, height: 2),
                                        children: [
                                          TextSpan(
                                            text: 'We will send you a ',
                                            style: josefinSansSB14.copyWith(
                                                color: Color(0xff707070),
                                                height: 1.4),
                                          ),
                                          TextSpan(
                                            text: 'One Time Password',
                                            style: josefinSansSB14.copyWith(
                                                color: Colors.black,
                                                height: 1.4),
                                          ),
                                          TextSpan(
                                            text: ' on this mobile number',
                                            style: josefinSansSB14.copyWith(
                                                color: Color(0xff707070),
                                                height: 1.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 25),
                                    // decoration: BoxDecoration(border: Border.all()),
                                    child: InternationalPhoneNumberInput(
                                      textFieldController: phoneController,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      selectorTextStyle:
                                          josefinSansSB20.copyWith(
                                        color: Colors.black,
                                      ),
                                      autoFocus: true,
                                      keyboardAction: TextInputAction.done,
                                      textStyle: josefinSansSB20.copyWith(
                                        color: Colors.black,
                                      ),
                                      inputDecoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          hintText: 'Phone Number'),
                                      onInputChanged: (value) {
                                        phone = value;
                                      },
                                      onFieldSubmitted: (no) async {
                                        if (phone != null &&
                                            phone.parseNumber().length == 10) {
                                          await phoneVerify(phone.toString());
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (phone != null &&
                                            phone.parseNumber().length == 10) {
                                          await phoneVerify(phone.toString());
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14)),
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
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ))
                            ])
                          ]
                        : [
                            SizedBox(height: 50),
                            SvgPicture.asset('assets/PhoneVerify.svg',
                                height: 180),
                            SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: RichText(
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'OTP Verification\n',
                                  style: josefinSansB28.copyWith(
                                      color: Colors.black, height: 2),
                                  children: [
                                    TextSpan(
                                      text: 'We will send you a ',
                                      style: josefinSansSB14.copyWith(
                                        color: Color(0xff707070),
                                        height: 1.4,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'One Time Password',
                                      style: josefinSansSB14.copyWith(
                                        color: Colors.black,
                                        height: 1.4,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' on this mobile number',
                                      style: josefinSansSB14.copyWith(
                                        color: Color(0xff707070),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
                              // decoration: BoxDecoration(border: Border.all()),
                              child: InternationalPhoneNumberInput(
                                textFieldController: phoneController,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                selectorTextStyle: josefinSansSB20.copyWith(
                                  color: Colors.black,
                                ),
                                autoFocus: true,
                                keyboardAction: TextInputAction.done,
                                textStyle: josefinSansSB20.copyWith(
                                  color: Colors.black,
                                ),
                                inputDecoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Phone Number'),
                                onInputChanged: (value) {
                                  phone = value;
                                },
                                onFieldSubmitted: (no) async {
                                  if (phone != null &&
                                      phone.parseNumber().length == 10) {
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
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: GestureDetector(
                                onTap: () async {
                                  if (phone != null &&
                                      phone.parseNumber().length == 10) {
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14)),
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
                            ),
                            SizedBox(
                              height: 20,
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
