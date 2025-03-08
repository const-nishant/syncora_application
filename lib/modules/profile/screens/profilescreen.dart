import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncora_application/common/large_button.dart';
import 'package:syncora_application/config/configs.dart';
import 'package:syncora_application/modules/profile/widgets/transfertoken.dart';
import 'package:web3dart/web3dart.dart';
import '../../../main.dart';
import '../../auth/auth_exports.dart';
import '../../themes/theme_provider.dart';
import 'blocked_users.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final _auth = FirebaseAuth.instance;
  Storage _storage = Storage(client);
  final _firestore = FirebaseFirestore.instance;
  void copytoClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      String uid = _auth.currentUser?.uid ?? "";
      if (uid.isEmpty) return;

      final response = await _storage.createFile(
        bucketId: Configs.appWriteUserProfileStorageBucketId,
        fileId: "unique()",
        file: InputFile.fromPath(path: imageFile.path),
      );

      String imageUrl =
          "https://cloud.appwrite.io/v1/storage/buckets/your_bucket_id/files/${response.$id}/view?project=your_project_id";

      await _firestore.collection('users').doc(uid).update({
        'profileImage': imageUrl,
      });

      setState(() {});
    } catch (e) {
      print("Image upload error: $e");
    }
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    String uid = _auth.currentUser?.uid ?? "";
    if (uid.isEmpty) return null;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    return userDoc.exists ? userDoc.data() as Map<String, dynamic> : null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: Provider.of<AuthServices>(context, listen: false)
                .getUserDataStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Text('No user data found'),
                );
              } else {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String userName = userData['username'] ?? 'User Name';
                String walletAddress = userData['walletAddress'] ?? '0';
                String email = userData['email'] ?? 'No email';

// Get balance safely
                String balance =
                    Provider.of<WalletProvider>(context, listen: false)
                            .getBalance(walletAddress, 'sepolia')
                            ?.toString() ??
                        '0';

// Ensure balance is a valid number
                BigInt parsedBalance = BigInt.tryParse(balance) ?? BigInt.zero;

// Convert to EtherAmount
                EtherAmount latestBalance =
                    EtherAmount.fromBigInt(EtherUnit.wei, parsedBalance);
                String formattedBalance =
                    latestBalance.getValueInUnit(EtherUnit.ether).toString();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: FutureBuilder<Map<String, dynamic>?>(
                        future: _fetchUserData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var userData = snapshot.data!;
                          String name = userData['username'] ?? 'User';
                          String? profileImage = userData['profileImage'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: _pickImage,
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.grey.shade300,
                                        backgroundImage: _imageFile != null
                                            ? FileImage(_imageFile!)
                                            : profileImage != null
                                                ? NetworkImage(profileImage)
                                                : null,
                                        child: (_imageFile == null &&
                                                profileImage == null)
                                            ? const Icon(
                                                Icons.account_circle_outlined,
                                                size: 100,
                                                color: Colors.white)
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wallet Balance",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Text(
                          formattedBalance,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wallet Address",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              // Prevents overflow
                              child: Text(
                                walletAddress,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.copy,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                copytoClipboard(walletAddress);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transfer Tokens ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Transfertoken(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "E-mail",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Dark Mode",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            )),
                        Switch(
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade400,
                          trackOutlineColor:
                              const WidgetStatePropertyAll(Colors.transparent),
                          activeTrackColor: Colors.green,
                          value: Provider.of<ThemeProvider>(context).isDarkMode,
                          onChanged: (value) async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isDarkMode', value);
                            // ignore: use_build_context_synchronously
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Blocked users",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BlockedUsers(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    LargeButton(
                        onPressed: () {
                          Provider.of<AuthServices>(context, listen: false)
                              .logout(context);
                        },
                        text: "Logout"),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
