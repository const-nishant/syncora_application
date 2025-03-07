import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../chat/data/data_exports.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({super.key});

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  //chat & auth services
  final Chatservices _chatservices = Chatservices();
  // final Authservices _authservices = Authservices();

  //get current user id
  String userID = FirebaseAuth.instance.currentUser!.uid;

  //show unblock dialog
  void showUnblockDialog(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unblock User'),
          content: const Text('Are you sure you want to unblock this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _chatservices.unblockUser(userID);
                Navigator.pop(context);
                //show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User Unblocked'),
                  ),
                );
              },
              child: const Text('Unblock'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: const Text(
          'Blocked Users',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _chatservices.getBlockedUsersStream(userID),
          builder: (context, snapshot) {
            //error
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            //loading..
            else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //return user list

            else {
              final blockedUsers = snapshot.data ?? [];
              if (blockedUsers.isEmpty) {
                return const Center(
                  child: Text('No Blocked Users'),
                );
              }
              return ListView.builder(
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = blockedUsers[index];
                  return UserTile(
                    username: user['username'],
                    onTap: () => showUnblockDialog(context, user['uid']),
                  );
                },
              );
            }
          }),
    );
  }
}
