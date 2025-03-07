import 'package:flutter/material.dart';
import 'package:syncora_application/modules/chat/data/models/userlist.dart';

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
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: UserList(),
      ),
    );
  }
}
