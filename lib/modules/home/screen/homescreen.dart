import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/auth_exports.dart';
import '../widgets/helpchatbot.dart';
import '../widgets/postwidget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    Provider.of<WalletProvider>(context, listen: false).loadWalletData();
    super.initState();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    String uid = _auth.currentUser?.uid ?? "";
    if (uid.isEmpty) return null;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    return userDoc.exists ? userDoc.data() as Map<String, dynamic> : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.data != null) {
                    var userData = snapshot.data!;
                    String name = userData['username'] ?? 'User';
                    String? profileImage = userData['profileImage'];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (profileImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              profileImage,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                        const SizedBox(width: 16),
                        Text(
                          "Hello!!, $name",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 8),
              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              const SizedBox(height: 20),
              const Text(
                "Feed",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'FontMain',
                  color: Color(0xFF6A3200),
                ),
              ),
              Expanded(child: PostWidget()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          LucideIcons.messageCircle,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Helpchatbot(),
            ),
          );
        },
      ),
    );
  }
}
