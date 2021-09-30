import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './Services/auth.dart';
import './Modals/User.dart';
import './Services/ServerRequests.dart';
import './Screens/SplashScreen.dart';
import './Variables.dart';
import 'Modals/Order.dart';

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
      // DeviceOrientation.landscapeLeft,
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
        ),
        ChangeNotifierProvider<Order>(create: (context) => Order())
      ],
      child: Consumer<ServerRequests>(
        builder: (context, serverRequests, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xffFFCB00),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Color(0xffFFCB00),
              ),
              accentColor: Color(0xffFFCB00)),
          home: Consumer<AppUser>(
            builder: (context, appUser, child) => Consumer<Order>(
              builder: (context, order, child) => SplashScreen(
                serverRequests: serverRequests,
                appUser: appUser,
                order: order,
              ),
            ),
          ),
          // Logic()),
        ),
      ),
    );
  }
}
