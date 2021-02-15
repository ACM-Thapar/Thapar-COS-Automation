import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  User _firebaseUser;
  String _name;
  String _email;
  String _password;
  String _phone;
  String _hostel;
  bool _user;
  void setFirebaseuser({
    User firebaseUser,
  }) {
    _firebaseUser = firebaseUser;
  }

  void setProfile({
    String name,
    String email,
    String password,
    String phone,
    String hostel,
    bool user,
  }) {
    this._name = name ?? this._name;
    this._email = email ?? this._email;
    this._password = password ?? this._password;
    this._phone = phone ?? this._phone;
    this._hostel = hostel ?? this._hostel;
    this._user = user ?? this._user;
  }

  String get name => this._name;
  String get email => this._email;
  String get password => this._password;
  String get phone => this._phone;
  String get hostel => this._hostel;
  bool get user => this._user;
  User get firebaseUser => _firebaseUser;

  void printUser(AppUser user) {
    print(user._name);
    print(user._email);
    print(user._password);
    print('phone ${user._phone}');
    print(user._hostel);
    print(user._user);
  }
}
