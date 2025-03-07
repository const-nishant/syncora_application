import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  final void Function()? onTap;
  const Loginscreen({super.key, this.onTap});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login Screen'),
      ),
    );
  }
}
