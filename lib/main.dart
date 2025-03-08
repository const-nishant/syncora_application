import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/config/configs.dart';
import 'package:syncora_application/firebase_options.dart';
import 'package:syncora_application/modules/auth/auth_exports.dart';

import 'modules/themes/theme_provider.dart';

Client client = Client();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  client
      .setEndpoint(Configs.appWriteEndpoint)
      .setProject(Configs.appWriteProjectId);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Phoenix(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncora',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AnimatedSplashScreen(
        splash: Image.asset("assets/images/app_icon.jpg"),
        duration: 2000,
        splashIconSize: 200,
        nextScreen: const Authwrapper(),
      ),
    );
  }
}
