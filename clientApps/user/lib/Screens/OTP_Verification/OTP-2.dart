import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';
import 'package:user/Screens/LoginPage.dart';

import '../../Services/auth.dart';
import '../../ErrorBox.dart';
import '../../Services/ServerRequests.dart';
import '../../Variables.dart';
import '../../Modals/User.dart';
import './OTP-1.dart';

//TODO: ADD BTN FOR RESEND OTP
class OTP2 extends StatefulWidget {
  @override
  _OTP2State createState() => _OTP2State();
}

class _OTP2State extends State<OTP2> {
  String _otp = '';
  bool validate = false;
  StreamController<String> _controller;
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 60;
  bool success = false;
  bool send = false;
  void startTimeout() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      if (!success) {
        _controller.add(
            '${((timerMaxSeconds - timer.tick) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - timer.tick) % 60).toString().padLeft(2, '0')}');
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          send = true;
        }
      }
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _controller = StreamController.broadcast();
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation);
    return OrientationBuilder(
      builder: (context, orientation) {
        print("orientation: $orientation");
        print(MediaQuery.of(context).size.width);
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
                        //Ask for logout
                        bool val = await errorBox(
                          context,
                          PlatformException(
                            code: 'Logout',
                            message: 'Are you sure you want to logout?',
                            details: 'double',
                          ),
                        );
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
                                      'assets/EmailVerify.svg',
                                      height: 250),
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    RichText(
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'OTP Verification\n',
                                        style: josefinSansB28.copyWith(
                                            color: Colors.black, height: 2),
                                        children: [
                                          TextSpan(
                                            text: 'Enter the OTP sent to\n',
                                            style: josefinSansSB14.copyWith(
                                              color: Color(0xff707070),
                                              height: 1.4,
                                            ),
                                          ),
                                          TextSpan(
                                            text: Provider.of<AppUser>(context,
                                                    listen: false)
                                                .email,
                                            style: josefinSansB14.copyWith(
                                              color: Colors.black,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      // decoration: BoxDecoration(border: Border.all()),
                                      child: OTPTextField(
                                        keyboardType: TextInputType.text,
                                        width: 300,
                                        fieldWidth: 40,
                                        style: josefinSansB31.copyWith(
                                            color: Colors.black),
                                        length: 6,
                                        textFieldAlignment:
                                            MainAxisAlignment.spaceAround,
                                        onChanged: (v) {
                                          _otp = v.replaceAll(RegExp(' '), '');
                                          if (_otp.length == 6)
                                            validate = true;
                                          else
                                            validate = false;
                                        },
                                        onCompleted: (v) async {
                                          _otp = v.replaceAll(RegExp(' '), '');
                                          if (_otp.length == 6)
                                            validate = true;
                                          else
                                            validate = false;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70),
                                      child: GestureDetector(
                                        onTap: () async {
                                          print(_otp);
                                          if (validate) {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) =>
                                                  WillPopScope(
                                                onWillPop: () => Future.delayed(
                                                    Duration(), () => false),
                                                child: Dialog(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              ),
                                            );
                                            bool success;
                                            try {
                                              success = await Provider.of<
                                                          ServerRequests>(
                                                      context,
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
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => OTP1(),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)),
                                            color: Colors.black,
                                          ),
                                          child: Text(
                                            'Verify and Proceed',
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
                                    GestureDetector(
                                      onTap: () async {
                                        if (send) {
                                          bool success = false;
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) => WillPopScope(
                                              onWillPop: () => Future.delayed(
                                                  Duration(), () => false),
                                              child: Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            ),
                                          );
                                          try {
                                            success = await Provider.of<
                                                        ServerRequests>(context,
                                                    listen: false)
                                                .regenerateOtp();
                                            Navigator.pop(context);
                                          } on PlatformException catch (e) {
                                            Navigator.pop(context);
                                            errorBox(context, e);
                                          }
                                          if (success)
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Color(0xffFFCB00),
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                  'OTP SENT',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          startTimeout();
                                        }
                                      },
                                      child: StreamBuilder<String>(
                                        stream: _controller.stream,
                                        initialData: "01:00",
                                        builder: (context, snapshot) => Text(
                                          snapshot.data == "00:00"
                                              ? 'Resend OTP'
                                              : snapshot.data,
                                          style: josefinSansSB14.copyWith(
                                              color: Color(0xffFFCB00)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                              ])
                            ]
                          : [
                              SizedBox(height: 50),
                              SvgPicture.asset('assets/EmailVerify.svg',
                                  height: 180),
                              SizedBox(height: 25),
                              RichText(
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'OTP Verification\n',
                                  style: josefinSansB28.copyWith(
                                      color: Colors.black, height: 2),
                                  children: [
                                    TextSpan(
                                      text: 'Enter the OTP sent to\n',
                                      style: josefinSansSB14.copyWith(
                                        color: Color(0xff707070),
                                        height: 1.4,
                                      ),
                                    ),
                                    TextSpan(
                                      text: Provider.of<AppUser>(context,
                                              listen: false)
                                          .email,
                                      style: josefinSansB14.copyWith(
                                        color: Colors.black,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 25),
                                // decoration: BoxDecoration(border: Border.all()),
                                child: OTPTextField(
                                  keyboardType: TextInputType.text,
                                  width: 300,
                                  fieldWidth: 40,
                                  style: josefinSansB31.copyWith(
                                      color: Colors.black),
                                  length: 6,
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  onChanged: (v) {
                                    _otp = v.replaceAll(RegExp(' '), '');
                                    if (_otp.length == 6)
                                      validate = true;
                                    else
                                      validate = false;
                                  },
                                  onCompleted: (v) async {
                                    _otp = v.replaceAll(RegExp(' '), '');
                                    if (_otp.length == 6)
                                      validate = true;
                                    else
                                      validate = false;
                                  },
                                ),
                              ),
                              SizedBox(height: 25),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 70),
                                child: GestureDetector(
                                  onTap: () async {
                                    print(_otp);
                                    if (validate) {
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
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      );
                                      bool success;
                                      try {
                                        success =
                                            await Provider.of<ServerRequests>(
                                                    context,
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(14)),
                                      color: Colors.black,
                                    ),
                                    child: Text(
                                      'Verify and Proceed',
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
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (send) {
                                      bool success = false;
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
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      );
                                      try {
                                        success =
                                            await Provider.of<ServerRequests>(
                                                    context,
                                                    listen: false)
                                                .regenerateOtp();
                                        Navigator.pop(context);
                                      } on PlatformException catch (e) {
                                        Navigator.pop(context);
                                        errorBox(context, e);
                                      }
                                      if (success)
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Color(0xffFFCB00),
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                              'OTP SENT',
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      startTimeout();
                                    }
                                  },
                                  child: StreamBuilder<String>(
                                    stream: _controller.stream,
                                    initialData: "01:00",
                                    builder: (context, snapshot) => Text(
                                      snapshot.data == "00:00"
                                          ? 'Resend OTP'
                                          : snapshot.data,
                                      style: josefinSansSB14.copyWith(
                                          color: Color(0xffFFCB00)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15)
                            ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
