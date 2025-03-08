import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../auth_exports.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future login(String email, String password, BuildContext context) async {
    _showLoader(context);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Access WalletProvider before the widget is disposed
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      await walletProvider.loadWalletData();

      String? mnemonic = await getmenoics();
      await walletProvider.getExistingPrivateKey(mnemonic!);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message ?? 'An error occurred');
      }
    } finally {
      if (context.mounted) Navigator.pop(context); // Close the loader
    }
    notifyListeners();
  }

  //get current user
  User? getCurrentUser() => _auth.currentUser;

//request token
  Future<String> getCurrentUsername() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return "UnknownUser";

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists
        ? userDoc['username'] ?? "UnknownUser"
        : "UnknownUser";
  }

  Future<void> requestTokens(
      String receiverUsername, int amount, BuildContext context) async {
    try {
      String senderUsername = await getCurrentUsername();

      await FirebaseFirestore.instance.collection('requests').add({
        'sender': senderUsername,
        'receiver': receiverUsername,
        'amount': amount,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Request sent to @$receiverUsername for $amount tokens."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to request tokens: $e")),
      );
    }
    notifyListeners();
  }

  //get wallet address
  Future<String> getWalletAddress() async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    String walletAddress = userSnapshot['walletAddress'];
    return walletAddress;
  }

  //get wallet address
  Stream<DocumentSnapshot> getUserDataStream() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .snapshots();
  }

  //get menoics
  Future<String?> getmenoics() async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    return userSnapshot['menoics'];
  }

  //chnage sign up status
  Future<void> changeSignupStatus(bool status) async {
    await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      'isSignup': status,
    });
  }

  // Check signup status
  Future<bool> checkSignupStatus(String uid, BuildContext context) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return data?['isSignup'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error fetching signup status: $e');
      return false;
    }
  }

  // Signup function
  Future signup(String username, String email, String password,
      BuildContext context) async {
    _showSignupLoader(context);
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      await walletProvider.loadPrivateKey();

      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid ?? '')
          .get();
      if (!userSnapshot.exists) {
        await walletProvider.createWallet();
        String mnemonic = walletProvider.mnemonic ?? '';
        String walletAddress = walletProvider.walletAddress ?? '';
        UserModel user = UserModel(
          username: username,
          email: _auth.currentUser?.email ?? '',
          uid: _auth.currentUser?.uid ?? '',
          walletAddress: walletAddress,
          menoics: mnemonic,
          notificationId: '',
          isSignup: false,
          authProvider: 'email',
        );
        await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .set(user.toMap());
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, e.toString());
      }
    } finally {
      if (_dialogContext != null && _dialogContext!.mounted) {
        Navigator.pop(_dialogContext!); // Close the loader
        _dialogContext = null; // Reset after closing
      }
    }

    notifyListeners();
  }

  // Google Signin
  Future<dynamic> continueWithGoogle(BuildContext context) async {
    _showSignupLoader(context);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        _dismissLoader(context); // Close the loader
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      await walletProvider.loadPrivateKey();

      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid ?? '')
          .get();
      if (!userSnapshot.exists) {
        await walletProvider.createWallet();
        String mnemonic = walletProvider.mnemonic ?? '';
        String walletAddress = walletProvider.walletAddress ?? '';
        UserModel user = UserModel(
          username: googleUser.displayName ?? '',
          email: _auth.currentUser?.email ?? '',
          uid: _auth.currentUser?.uid ?? '',
          walletAddress: walletAddress,
          menoics: mnemonic,
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
      _dismissLoader(context); // Close the loader
    }

    notifyListeners();
  }

  void _showLoader(BuildContext context) {
    Future.microtask(() {
      showDialog(
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

  // Dismiss loader
  void _dismissLoader(BuildContext context) {
    if (_dialogContext != null && Navigator.canPop(_dialogContext!)) {
      Navigator.pop(_dialogContext!);
      _dialogContext = null; // Reset after closing
    }
  }

  // Error function
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void logout(BuildContext context) async {
    await Provider.of<WalletProvider>(context, listen: false).clearPrivateKey();
    await _auth.signOut();
    notifyListeners();
  }
}
