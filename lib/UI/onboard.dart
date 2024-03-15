import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardPage extends StatelessWidget {
  OnboardPage({super.key});

  void onboardComplete() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('onboard', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onboardComplete();
          Navigator.pushReplacementNamed(context, 'navpage');
        },
        label: const Text(
          "Skip",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue.withOpacity(0.1),
        elevation: 0.0,
      ),
      body: LiquidSwipe(
        pages: pages,
        slideIconWidget: const Icon(Icons.arrow_back_ios),
        enableLoop: false,
      ),
    );
  }

  final pages = [
    Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Image.asset(
              'assets/images/locationPin.png',
              height: 400,
              width: 400,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "View Posts from around you",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    ),
    Container(
      width: double.infinity,
      color: Colors.blue[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Image.asset(
              'assets/images/question.png',
              height: 400,
              width: 400,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "Remain Anonymous while being a part of Spatial",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    ),
    Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Image.asset(
              'assets/images/social.png',
              height: 400,
              width: 400,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "A social media to connect places",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    )
  ];
}
