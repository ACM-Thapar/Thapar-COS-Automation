import 'package:clientapp/Variables.dart';
import '../Intro/Intro1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';
import '../../Services/User.dart';
import './OTP-1.dart';

class OTP2 extends StatelessWidget {
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
                        print("BACK");
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => OTP1(),
                          ),
                        );
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
                    style: GoogleFonts.josefinSans(
                        fontSize: 28, fontWeight: FontWeight.w900),
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
                      style: GoogleFonts.josefinSans(
                          fontSize: 22, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: '+91- ${Provider.of<AppUser>(context).phone}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 34 * boxSizeV / 6.4,
                ),
                Container(
                    child: OTPTextField(
                  width: 209 * boxSizeH / 3.6,
                  fieldWidth: 35 * boxSizeH / 3.6,
                  style: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black),
                  length: 5,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                )),
                SizedBox(height: 34.5 * boxSizeV / 6.4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Intro1(),
                      ),
                    );
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
            ),
          ),
        ),
      ),
    );
  }
}
