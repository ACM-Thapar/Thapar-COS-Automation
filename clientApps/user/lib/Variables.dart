import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import './Modals/Shop.dart';

SharedPreferences store;
double boxSizeH;
double boxSizeV;
List<Shop> shops = [];
//josefinSans
TextStyle josefinSansR10 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w400,
  fontSize: 13,
);
TextStyle josefinSansR14 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w400,
  fontSize: 17,
);
TextStyle josefinSansR18 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w400,
  fontSize: 21,
);
TextStyle josefinSansR20 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w400,
  fontSize: 23,
);
TextStyle josefinSansSB10 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w600,
  fontSize: 13,
);
TextStyle josefinSansSB14 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w600,
  fontSize: 17,
);
TextStyle josefinSansSB18 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w600,
  fontSize: 21,
);
TextStyle josefinSansSB20 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w600,
  fontSize: 23,
);
TextStyle josefinSansSB25 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w600,
  fontSize: 28,
);
TextStyle josefinSansSB28 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w600,
  fontSize: 31,
);
TextStyle josefinSansSB45 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w600,
  fontSize: 45,
);
TextStyle josefinSansB12 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w700,
  fontSize: 15,
);
TextStyle josefinSansB14 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w700,
  fontSize: 17,
);
TextStyle josefinSansB20 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w700,
  fontSize: 23,
);
TextStyle josefinSansB28 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w700,
  fontSize: 31,
);
TextStyle josefinSansB31 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w700,
  fontSize: 34,
);
TextStyle josefinSansB37 = GoogleFonts.josefinSans(
  fontWeight: FontWeight.w700,
  fontSize: 40,
);
//openSans
TextStyle openSansSB9 = GoogleFonts.openSans(
  fontWeight: FontWeight.w600,
  fontSize: 12,
);
TextStyle openSansR10 = GoogleFonts.openSans(
  fontWeight: FontWeight.w300,
  fontSize: 13,
);
TextStyle openSansL14 = GoogleFonts.openSans(
  fontWeight: FontWeight.w300,
  fontSize: 17,
);
TextStyle openSansR14 = GoogleFonts.openSans(
  fontWeight: FontWeight.w400,
  fontSize: 17,
);
//robotoBold
TextStyle robotoB18 = GoogleFonts.roboto(
  fontWeight: FontWeight.w700,
  fontSize: 21,
);
TextStyle robotoB37 = GoogleFonts.roboto(
  fontWeight: FontWeight.w700,
  fontSize: 40,
);
TextStyle robotoB45 = GoogleFonts.roboto(
  fontWeight: FontWeight.w700,
  fontSize: 48,
);

// TextStyle robotoB37 = TextStyle(
//   fontFamily: 'robotoBold',
//   fontSize: 37,
// );
// TextStyle robotoB45 = TextStyle(
//   fontFamily: 'robotoBold',
//   fontSize: 45,
// );
// TextStyle robotoBK18 = TextStyle(
//   fontFamily: 'robotoBook',
//   fontSize: 21,
// );
