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
    //list of user except current user
    return StreamBuilder(
        stream: chatservice.getallusersStreamExcludingBlockedUsers(),
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
            return ListView(
              children: snapshot.data!
                  .map((userData) => _buildUserListItem(context, userData))
                  .toList(),
            );
          }
        });
  }

  Widget _buildUserListItem(
      BuildContext context, Map<String, dynamic> userData) {
    //display all users except current user
    final authservices = Provider.of<AuthServices>(context, listen: false);
    if (userData['email'] != authservices.getCurrentUser()!.email) {
      return UserTile(
        username: userData['username'],
        onTap: () {
          //navigate to chat screen
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
