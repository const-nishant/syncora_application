import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? username;
  final String? email;
  final String uid;
  final String? walletAddress;
  final String? menoics;
  final String? notificationId;
  final String? profileImage;
  final bool isSignup;
  final String authProvider;

  UserModel({
    required this.username,
    this.profileImage,
    required this.email,
    required this.uid,
    required this.walletAddress,
    required this.menoics,
    required this.notificationId,
    required this.isSignup,
    required this.authProvider,
  });

  // Convert object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'uid': uid,
      'profileImage': profileImage,
      'walletAddress': walletAddress,
      'menoics': menoics,
      'notificationId': notificationId,
      'isSignup': isSignup,
      'authProvider': authProvider,
    };
  }

  // Create an object from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      profileImage: map['profileImage'] ?? '',
      walletAddress: map['walletAddress'] ?? '',
      menoics: map['menoics'] ?? '',
      notificationId: map['notificationId'] ?? '',
      isSignup: map['isSignup'] ?? false,
      authProvider: map['authProvider'] ?? '',
    );
  }

  // Create an object from Firestore document snapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }
}
