import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './Services/auth.dart';
import './Services/User.dart';
import './Services/ServerRequests.dart';
import './Screens/SplashScreen.dart';
import './Variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  store = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        Provider<ServerRequests>(
          create: (context) => ServerRequests(),
        ),
        Provider<Auth>(
          create: (context) => Auth(),
        ),
        Provider<AppUser>(
          create: (context) => AppUser(),
        )
      ],
      child: Consumer<ServerRequests>(
        builder: (context, serverRequests, child) => MaterialApp(
          theme: ThemeData(
              primaryColor: Color(0xffFFCB00),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Color(0xffFFCB00),
              ),
              accentColor: Color(0xffFFCB00)),
          title: 'Flutter Demo',
          home: Consumer<AppUser>(
              builder: (context, appUser, child) => SplashScreen(
                  serverRequests: serverRequests, appUser: appUser)),
        ),
      ),
    );
  }
}
