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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        //else if (snapshot.hasData) {
        //   return Consumer<AuthServices>(
        //     builder: (context, googleUserService, child) {
        //       return FutureBuilder(
        //         future: googleUserService.checkNewGoogleUser(
        //             snapshot.data!.uid, context),
        //         builder: (context, snapshot) {
        //           if (snapshot.hasError || !snapshot.hasData) {
        //             return HomePage();
        //           } else {
        //             return snapshot.data! ? const OnboardingPage() : HomePage();
        //           }
        //         },
        //       );
        //     },
        //   );
        // }
        if (snapshot.hasData) {
          return Consumer<AuthServices>(
              builder: (context, authServices, child) {
            return FutureBuilder(
                future:
                    authServices.checkSignupStatus(snapshot.data!.uid, context),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Authwrapper();
                  } else {
                    // final walletprovider = Provider.of<WalletProvider>(context);
                    return snapshot.data! ? NavBar() : MemonicsScreen();
                  }
                });
          });
        } else {
          return const Loginorsignup();
        }
      },
    );
  }
}
