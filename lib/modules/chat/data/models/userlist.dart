import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/auth_exports.dart';
import '../../screens/chatscreen.dart';
import '../data_exports.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatservice = Chatservices();
    // List of users except current user
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatservice.getallusersStreamExcludingBlockedUsers(),
      builder: (context, snapshot) {
        // Error
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        // Loading..
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Return user list
        else if (snapshot.hasData) {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index];
              return _buildUserListItem(context, userData);
            },
          );
        } else {
          return const Center(
            child: Text('No users found'),
          );
        }
      },
    );
  }

  Widget _buildUserListItem(
      BuildContext context, Map<String, dynamic> userData) {
    // Display all users except current user
    final authservices = Provider.of<AuthServices>(context, listen: false);
    if (userData['email'] != authservices.getCurrentUser()!.email) {
      return UserTile(
        username: userData['username'],
        onTap: () {
          // Navigate to chat screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverID: userData['uid'],
                username: userData['username'],
                receiversEmail: userData['email'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
