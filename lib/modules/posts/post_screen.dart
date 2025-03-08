import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../config/configs.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Storage storage;
  late final Client client;

  @override
  void initState() {
    super.initState();
    _initializeAppwrite();
  }

  void _initializeAppwrite() {
    client = Client()
        .setEndpoint(Configs.appWriteEndpoint)
        .setProject(Configs.appWriteProjectId);

    storage = Storage(client);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      log('Selected image path: ${image.path}');
    }
  }

  Future<void> post() async {
    if (_selectedImage != null && _controller.text.isNotEmpty) {
      try {
        String fileId = ID.unique(); // Generate a unique file ID

        // Upload image to Appwrite storage
        await storage.createFile(
          bucketId: Configs.appWriteUserImages,
          fileId: fileId,
          file: InputFile.fromPath(path: _selectedImage!.path),
        );

        // Construct download URL manually
        String downloadUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${Configs.appWriteUserImages}/files/$fileId/view?project=${Configs.appWriteProjectId}&mode=admin';

        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        String name = userDoc['name'];

        // Save post to Firestore
        await _firestore.collection('posts').add({
          'uid': _auth.currentUser!.uid,
          'name': name,
          'text': _controller.text,
          'image': downloadUrl,
          'likes': [],
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Reset state after successful post
        setState(() {
          _selectedImage = null;
          _controller.clear();
        });

        log('Post uploaded successfully with image: $downloadUrl');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload post: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: post,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              ),
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          LucideIcons.circleUserRound,
                          size: 40.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 75.0,
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: IconButton(
                      icon: Icon(
                        LucideIcons.image,
                        size: 28.0,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
