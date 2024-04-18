import 'package:spatial/UI/nave_page.dart';
import 'package:spatial/UI/onboard.dart';
import 'package:spatial/homeScreens/intermed_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isOnboard = prefs.getBool("onboard");
  runApp(
    MaterialApp(
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: isOnboard != null ? const NavPage() : OnboardPage(),
      routes: {
        'homeScreen': (context) => const InterMedHomePage(),
        'navpage': (context) => const NavPage(),
      },
    ),
  );
}
