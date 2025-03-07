import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getcurrentuserstream() {
    return _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        //got through each user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

  // Future<void> uploadimage(File image) async {
  //   final uid = _auth.currentUser!.uid;

  //   try {
  //     String? imageUrl;
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('profile_images')
  //         .child('$uid.jpg');
  //     await storageRef.putFile(image);
  //     imageUrl = await storageRef.getDownloadURL();

  //     await _firestore.collection('users').doc(uid).update({
  //       'profileImage': imageUrl,
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }
}
