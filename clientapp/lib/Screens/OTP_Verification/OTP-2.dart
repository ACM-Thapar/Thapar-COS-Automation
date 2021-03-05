import 'package:clientapp/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clientapp/ErrorBox.dart';
import 'package:clientapp/Services/ServerRequests.dart';
import 'package:clientapp/Variables.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';
import '../../Services/User.dart';
import '../../WidgetResizing.dart';
import '../UserType.dart';
import './OTP-1.dart';

//TODO: ADD BTN FOR RESEND OTP
class OTP2 extends StatefulWidget {
  @override
  _OTP2State createState() => _OTP2State();
}

class _OTP2State extends State<OTP2> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _otp = '';
  bool validate = false;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
    return WillPopScope(
      //Logout and EXIT
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
          key: _scaffoldKey,
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
                          }
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => UserType(),
                              ),
                              (route) => false);
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
                            image: AssetImage('assets/Group57.png'),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    height: 33 * boxSizeV / 6.4,
                  ),
                  Container(
                    child: Text(
                      'OTP Verification',
                      style: josefinSansB28,
                    ),
                  ),
                  SizedBox(
                    height: 24 * boxSizeV / 6.4,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2 * boxSizeH),
                    // decoration: BoxDecoration(border: Border.all()),
                    child: RichText(
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Enter the OTP sent to\n',
                        style: josefinSansSB14.copyWith(
                          color: Color(0xff707070),
                        ),
                        children: [
                          TextSpan(
                            text: Provider.of<AppUser>(context, listen: false)
                                .email,
                            style: josefinSansB14.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 34 * boxSizeV / 6.4,
                  ),
                  Container(
                      child: OTPTextField(
                    keyboardType: TextInputType.text,
                    width: 300 * boxSizeH / 3.6,
                    fieldWidth: 40 * boxSizeH / 3.6,
                    style: josefinSansB31.copyWith(color: Colors.black),
                    length: 6,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    onChanged: (v) {
                      _otp = v;
                      if (_otp.length == 6)
                        validate = true;
                      else
                        validate = false;
                    },
                    onCompleted: (v) async {
                      _otp = v;
                      if (_otp.length == 6)
                        validate = true;
                      else
                        validate = false;
                    },
                  )),
                  SizedBox(height: 34.5 * boxSizeV / 6.4),
                  GestureDetector(
                    onTap: () async {
                      print(_otp);
                      if (validate) {
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
                        bool success;
                        try {
                          success = await Provider.of<ServerRequests>(context,
                                  listen: false)
                              .checkOTP(_otp);
                        } on PlatformException catch (e) {
                          //TODO Impliment RESEND OTP BTN
                          print(e.code);
                          await errorBox(context, e);
                          success = false;
                          Navigator.pop(context);
                        }
                        if (success) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => OTP1(),
                            ),
                          );
                        }
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(
                              'Enter the complete OTP',
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
                        'Verify and Proceed',
                        style: josefinSansR18.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
