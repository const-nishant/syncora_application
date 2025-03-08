import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncora_application/modules/chat/data/models/userlist.dart';
import 'package:syncora_application/modules/chat/screens/requestscreen.dart';

class MainChatscreen extends StatefulWidget {
  const MainChatscreen({super.key});

  @override
  State<MainChatscreen> createState() => _MainChatscreenState();
}

class _MainChatscreenState extends State<MainChatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: const Text(
          'Chats',
          style: TextStyle(
              // color: Colors.white,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                LucideIcons.walletCards,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Requestscreen()));
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UserList(),
      ),
    );
  }
}
