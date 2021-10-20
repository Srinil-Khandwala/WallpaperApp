import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:wallpaper_app/screens/login_screen.dart';
import 'package:wallpaper_app/screens/registration_screen.dart';
import 'package:wallpaper_app/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WallpaperApp',
      theme: ThemeData(
          // primaryColor: Colors.white,

          ),
      home: Home(),
      initialRoute: WelcomeScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        Home.id: (context) => Home(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
      },
    );
  }
}
