import 'package:bluemint/homeScreens/settings_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../constants/uiColors.dart';
import 'create_post_page.dart';
import 'home_page.dart';

class InterMedHomePage extends StatefulWidget {
  const InterMedHomePage({super.key});

  @override
  State<InterMedHomePage> createState() => _InterMedHomePageState();
}

class _InterMedHomePageState extends State<InterMedHomePage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  var index = 0;

  final screens = [
    const HomePage(),
    CreatePostPage(),
    // ignore: prefer_const_constructors
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 60,
        items: const [
          Icon(Icons.home, color: Pallete.whiteColor),
          Icon(Icons.post_add, color: Pallete.whiteColor),
          Icon(
            Icons.settings,
            color: Pallete.whiteColor,
          )
        ],
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        color: Pallete.blackColor,
      ),
      body: screens[index],
    );
  }
}
