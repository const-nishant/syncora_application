import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes/theme_provider.dart';
import '../services/chat/chatservices.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String messageId;
  final String userID;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userID,
  });

  //show options
  void showOptions(BuildContext context, String messageId, String userID) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                //report message button
                ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text('Report'),
                  onTap: () {
                    Navigator.pop(context);
                    //report message
                    reportMesage(context, messageId, userID);
                  },
                ),

                //block  button
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Block User'),
                  onTap: () {
                    //pop the dialog
                    Navigator.pop(context);
                    //pop the screen
                    Navigator.pop(context);
                    //block user
                    blockUser(context, userID);
                  },
                ),
                //cancel button
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  //report message

  void reportMesage(BuildContext context, String messageId, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Message'),
        content: const Text('Are you sure you want to report this message?'),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          //report button
          TextButton(
            onPressed: () {
              //report message
              Chatservices().reportuser(messageId, userID);
              Navigator.pop(context);
              //show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message Reported'),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  //block user
  void blockUser(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: const Text('Are you sure you want to block this user?'),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          //block button
          TextButton(
            onPressed: () {
              //report message
              Chatservices().blockUser(userID);
              Navigator.pop(context);
              //show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User Blocked'),
                ),
              );
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          showOptions(
            context,
            messageId,
            userID,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(
          vertical: 2.5,
          horizontal: 25,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isCurrentUser
                ? Colors.white
                : (isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
