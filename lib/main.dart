import 'package:drivers_app/AllScreens/loginScreen.dart';
import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'AllScreens/mainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lai Xe An Toan',
      theme: ThemeData(
        fontFamily: "Roboto",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.idScreen,
      routes: {
        RegisterationScreen.idScreen: (context) => RegisterationScreen(),
        LoginScreen.idScreen : (context) => LoginScreen(),
        MainScreen.idScreen : (context) => MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


