import 'package:clientapp/SettingsPage.dart';
import 'package:clientapp/UserType.dart';

import './Builder.dart';

import 'package:flutter/material.dart';

import 'OTP Verification/OTP-1.dart';
import 'OTP Verification/OTP-2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OTP2(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileBuilder();
  }
}
