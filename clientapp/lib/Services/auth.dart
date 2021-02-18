import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Variables.dart';

class Auth {
  Future<void> formAuth({String email, String password}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> googleAuth() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        hostedDomain: store.getBool('userType') ? 'thapar.edu' : null);
    GoogleSignInAccount googleSignInAccount;
    GoogleSignInAuthentication googleSignInAuthentication;
    UserCredential authResult;
    googleSignInAccount =
        await googleSignIn.signIn(); //NEVER GIVES EXCEPTION SO IF ELSE CHECK
    if (googleSignInAccount != null) {
      try {
        googleSignInAuthentication = await googleSignInAccount.authentication;
      } on Exception catch (e) {
        print(
            'GOOGLE ERROR CAUGHT CUSTOM ERROR SENT ERROR GIVEN::${e.toString()}');
        throw PlatformException(
            code: 'Google_Auth_Failed',
            message: 'Google Authentication Failed');
      }
      try {
        authResult = await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: null,
              accessToken: googleSignInAuthentication.accessToken),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential')
          throw PlatformException(
              code:
                  'Email_Already_In_Use', //ONLY IF ALREADY GOOGLE, PRIORITY ORDER GOOGLE>FB>Email&Pas
              message: 'There is already an account with this email');
        else if (e.code == 'user-disabled')
          throw PlatformException(code: e.code, message: e.message);
        else {
          print('Something went WRONG HERE');
          throw PlatformException(
              code: 'Google_Auth_Failed',
              message: 'Google Authentication Failed');
        }
      } catch (error) {
        print(error.toString());
      }
    } else
      throw PlatformException(
          code: 'Error_Aborted_by_User',
          message:
              'Sign in aborted by user'); //NEVER CAUGHT IN APP  ONLY WHEN DEBUGGING IT CATCHES THE EXCEPTION
    return authResult;
  }
}
