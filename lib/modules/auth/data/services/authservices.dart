import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncora_application/modules/auth/data/models/usermodel.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? getcurrentUser() {
    return _auth.currentUser;
  }

  Future login(String email, String password, BuildContext context) async {
    _showLoader(context);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message ?? 'An error occurred');
      }
    } finally {
      if (context.mounted) Navigator.pop(context); // Close the loader
    }
    notifyListeners();
  }

  // Signup function
  Future signup(String username, String email, String password,
      BuildContext context) async {
    _showSignupLoader(context);
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel user = UserModel(
        username: username,
        email: email,
        uid: _auth.currentUser!.uid,
        walletAddress: '',
        menoics: '',
        notificationId: '',
        isSignup: true,
        authProvider: 'email',
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message ?? 'An error occurred');
      }
    } finally {
      if (context.mounted) {
        Navigator.pop(_dialogContext!); // Close the loader
      }
    }
  }

  Future<dynamic> continueWithGoogle(BuildContext context) async {
    _showSignupLoader(context);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid ?? '')
          .get();
      if (!userSnapshot.exists) {
        UserModel user = UserModel(
          username: '',
          email: _auth.currentUser?.email ?? '',
          uid: _auth.currentUser?.uid ?? '',
          walletAddress: '',
          menoics: '',
          notificationId: '',
          isSignup: false,
          authProvider: 'google',
        );
        await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .set(user.toMap());
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message ?? 'An error occurred');
      }
    } finally {
      if (_dialogContext != null && _dialogContext!.mounted) {
        Navigator.pop(_dialogContext!); // Close the loader
        _dialogContext = null; // Reset after closing
      }
    }

    notifyListeners();
  }

  void _showLoader(BuildContext context) {
    Future.microtask(() {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    });
  }

  BuildContext? _dialogContext; // Store context of dialog

// Loader for signup
  void _showSignupLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        _dialogContext = dialogContext; // Store context of dialog
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

// Error function
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
