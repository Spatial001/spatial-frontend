// ignore_for_file: use_build_context_synchronously
import 'dart:ui';
import 'package:spatial/homeScreens/intermed_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/login.dart';
import '../services/api_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool defaultValue = true;
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void signIn() async {
    LoginBody loginBody = LoginBody(
        email: mailController.text, password: passwordController.text);
    var apiresponse =
        defaultValue ? await login(loginBody) : await signup(loginBody);
    if (apiresponse?.statusCode == 200) {
      var data = jsonDecode(apiresponse!.body);

      var sp = await SharedPreferences.getInstance();

      sp.setString('isLoggedIn', data["token"]);
      sp.setString('userId', data['result']['_id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const InterMedHomePage(),
        ),
      );
      var snackBar = const SnackBar(content: Text("Successfull"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (apiresponse?.statusCode == 400) {
      var error = jsonDecode(apiresponse!.body);
      var snackBar = SnackBar(content: Text(error['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (apiresponse?.statusCode == 404) {
      var error = jsonDecode(apiresponse!.body);
      var snackBar = SnackBar(content: Text(error['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset('assets/images/Spline.png'),
          ),
          const RiveAnimation.asset('assets/riveAssets/shapes.riv'),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Text(
                        defaultValue ? 'Login' : 'Register',
                        style: const TextStyle(
                          fontSize: 40,
                          height: 3.5,
                        ),
                      ).animate().fadeIn().slideX(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 50, bottom: 50),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade200,
                                  blurRadius: 15,
                                  offset: const Offset(0, 10),
                                )
                              ]),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              controller: mailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                                contentPadding: const EdgeInsets.only(left: 10),
                              ),
                            ),
                          ),
                        ),
                      ).animate().slideY(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade200,
                                  blurRadius: 15,
                                  offset: const Offset(0, 10),
                                )
                              ]),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 10)),
                            ),
                          ),
                        ),
                      ).animate().slideY(),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: InkWell(
                          onTap: signIn,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(166, 0, 174, 255),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Center(
                                child: Text(
                              defaultValue ? "Login" : "Register",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            onPressed: () {
                              defaultValue = !defaultValue;
                              setState(() {});
                            },
                            child: Text(
                              defaultValue
                                  ? "New User? Register here"
                                  : "Already have an Account? Click Here",
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
