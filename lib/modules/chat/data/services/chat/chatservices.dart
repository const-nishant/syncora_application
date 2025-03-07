import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data_exports.dart';

class Chatservices extends ChangeNotifier {
  //get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all user stream
  Stream<List<Map<String, dynamic>>> getuserstream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //got through each user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

//get all users stream excluding blocked users
  Stream<List<Map<String, dynamic>>> getallusersStreamExcludingBlockedUsers() {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('blockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // Get list of blocked users ids
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      // Get all users
      final userSnapshot = await _firestore.collection('users').get();

      // Return stream list, excluding blocked users and current user
      return userSnapshot.docs
          .where((doc) =>
              !blockedUsersIds.contains(doc.id) && doc.id != currentUser.uid)
          .map((doc) => doc.data())
          .toList();
    });
  }

  //send message
  Future<void> sendmessage(String receiverID, String message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create message
    Message newmessage = Message(
      message: message,
      senderID: currentUserID,
      receiverID: receiverID,
      timestamp: timestamp,
      senderEmail: currentUserEmail,
    );
    //construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //sort the ids (this ensure the chat room ID is same for both users)
    String chatroomID = ids.join('_');

    //add a new message to database
    await _firestore
        .collection('chatrooms')
        .doc(chatroomID)
        .collection('messages')
        .add(newmessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    //construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [userID, otherUserID];
    ids.sort(); //sort the ids (this ensure the chat room ID is same for both users)
    String chatroomID = ids.join('_');
    return _firestore
        .collection('chatrooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //Report user
  Future<void> reportuser(String messageId, String userID) async {
    final String currentUserID = _auth.currentUser!.uid;

    final report = {
      'messageID': messageId,
      'reportedBy': currentUserID,
      'messageOwnerId': userID,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }

  //Block user
  Future<void> blockUser(String userID) async {
    final String currentUserID = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('blockedUsers')
        .doc(userID)
        .set({});
    notifyListeners();
  }

  //Unblock user
  Future<void> unblockUser(String userID) async {
    final String currentUserID = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('blockedUsers')
        .doc(userID)
        .delete();
    notifyListeners();
  }

  //Get blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userID) {
    return _firestore
        .collection('users')
        .doc(userID)
        .collection('blockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get list of blocked users ids
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        blockedUsersIds.map(
          (id) => _firestore.collection('users').doc(id).get(),
        ),
      );

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
