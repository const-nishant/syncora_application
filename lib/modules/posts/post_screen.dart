import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncora_application/main.dart';

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
  XFile? _selectedVideo;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = Storage(client);

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      // Handle the selected image
      log('Selected image path: ${image.path}');
    }
  }

  // Future<void> _pickVideo() async {
  //   final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
  //   if (video != null) {
  //     setState(() {
  //       _selectedVideo = video;
  //     });
  //     // Handle the selected video
  //     log('Selected video path: ${video.path}');
  //   }
  // }

  void post() async {
    if (_selectedImage != null && _controller.text.isNotEmpty) {
      try {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        await storage.createFile(
          bucketId: Configs.appWriteUserImages,
          fileId: imageName,
          file: InputFile.fromPath(path: _selectedImage!.path),
        );

        String downloadUrl =
            'https://cloud.appwrite.io/v1/storage/buckets/${Configs.appWriteUserImages}/files/$imageName/view?project=${Configs.appWriteProjectId}&mode=admin';

        await _firestore.collection('posts').add({
          'uid': _auth.currentUser!.uid,
          'text': _controller.text,
          'image': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _selectedImage = null;
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              post();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                color: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
                child: const Center(
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (_selectedImage != null && _selectedVideo == null)
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
                // IconButton(
                //   icon: Icon(
                //     LucideIcons.video,
                //     size: 28.0,
                //     color: Theme.of(context).colorScheme.inversePrimary,
                //   ),
                //   onPressed: _pickVideo,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
