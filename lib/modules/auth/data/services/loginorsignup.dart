import 'package:flutter/material.dart';

import '../../auth_exports.dart';

class Loginorsignup extends StatefulWidget {
  const Loginorsignup({super.key});

  @override
  State<Loginorsignup> createState() => _LoginorsignupState();
}

class _LoginorsignupState extends State<Loginorsignup> {
  bool showLogInScreen = true;

  //function to toggle between screens
  void toggleScreen() {
    setState(() {
      showLogInScreen = !showLogInScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInScreen) {
      return Loginscreen(onTap: toggleScreen);
    } else {
      return Signupscreen(onTap: toggleScreen);
    }
  }
}
