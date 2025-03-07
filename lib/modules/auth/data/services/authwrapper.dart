import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/common/navbar.dart';
import 'package:syncora_application/modules/auth/screen/memonics_screen.dart';
import '../../auth_exports.dart';

class Authwrapper extends StatefulWidget {
  const Authwrapper({super.key});

  @override
  State<Authwrapper> createState() => _AuthwrapperState();
}

class _AuthwrapperState extends State<Authwrapper> {
  Future<bool>? _signupStatusFuture;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        if (user == null) {
          return const Loginorsignup();
        }

        final authServices = Provider.of<AuthServices>(context, listen: false);

        // Cache the Future to prevent unnecessary calls
        _signupStatusFuture ??=
            authServices.checkSignupStatus(user.uid, context);

        return FutureBuilder<bool>(
          future: _signupStatusFuture,
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (futureSnapshot.hasError || !futureSnapshot.hasData) {
              return const Loginorsignup();
            }

            return futureSnapshot.data! ? NavBar() : MemonicsScreen();
          },
        );
      },
    );
  }
}
