import 'package:bluemint/UI/login.dart';
import 'package:bluemint/homeScreens/intermed_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  var checkVar = false;

  Future getVar() async {
    var sp = await SharedPreferences.getInstance();
    var res = sp.getString('isLoggedIn');
    if (res != null) {
      checkVar = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getVar(),
      builder: ((context, snapshot) {
        if (checkVar) {
          return const InterMedHomePage();
        } else {
          return const LoginScreen();
        }
      }),
    );
  }
}
