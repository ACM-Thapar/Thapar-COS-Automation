import 'package:clientapp/PageResizing/Variables.dart';
import 'package:clientapp/PageResizing/WidgetResizing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class OTP1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
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
                          image: AssetImage('images/Group 42.png'),
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
                      text: 'We will send you a ',
                      style: GoogleFonts.josefinSans(
                          fontSize: 22, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: 'One Time Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
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
                        border: UnderlineInputBorder(),
                        hintText: 'Phone Number'),
                    onInputChanged: (value) {
                      print(value);
                    },
                    countries: ['IN'],
                  ),
                ),
                SizedBox(height: 34.5 * boxSizeV / 6.4),
                Container(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
