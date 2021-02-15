import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Future<UserCredential> googleAuth() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      if (googleSignInAuthentication.accessToken != null &&
          googleSignInAuthentication.idToken != null) {
        print(googleSignInAuthentication.accessToken);
        final authResult = FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleSignInAuthentication.idToken,
              accessToken: googleSignInAuthentication.accessToken),
        );
        return authResult;
      } else {
        throw PlatformException(
            code: 'Error_Missing_Google_Auth_Token',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'Error_Aborted_by_User', message: 'Sign in aborted by user');
    }
  }
}
