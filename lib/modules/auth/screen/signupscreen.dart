import 'package:flutter/material.dart';

class Signupscreen extends StatefulWidget {
  final void Function()? onTap;
  const Signupscreen({super.key, this.onTap});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Signup Screen'),
      ),
    );
  }
}
