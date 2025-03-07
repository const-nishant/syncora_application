import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/modules/auth/data/services/authservices.dart';

import '../data_exports.dart';

class Messagelist extends StatelessWidget {
  final ScrollController scrollController;
  final String receiverID;

  const Messagelist({
    super.key,
    required this.receiverID,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final Chatservices chatservice = Chatservices();
    final authservices = Provider.of<AuthServices>(context, listen: false);
    String senderID = authservices.getcurrentUser()!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: chatservice.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet'),
          );
        } else {
          return ListView(
            controller: scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageListItem(context, doc))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildMessageListItem(BuildContext context, DocumentSnapshot doc) {
    final authservices = Provider.of<AuthServices>(context, listen: false);
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == authservices.getcurrentUser()!.uid;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
          messageId: doc.id,
          userID: data['senderID'],
          message: data['message'],
          isCurrentUser: isCurrentUser,
        ),
      ],
    );
  }
}
