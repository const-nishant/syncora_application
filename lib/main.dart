import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/config/configs.dart';
import 'package:syncora_application/firebase_options.dart';
import 'package:syncora_application/modules/auth/data/services/authwrapper.dart';
import 'modules/auth/data/services/authservices.dart';
import 'modules/home/data/services/walletaddressservices.dart';

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
        ChangeNotifierProvider(create: (_) => WalletProvider()),
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
      // theme: ,
      home: Authwrapper(),
    );
  }
}
