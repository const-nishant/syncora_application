import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostWidget extends StatefulWidget {
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    temp();
    super.initState();
  }

  String profileImage = '';

  void temp() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    String name = userDoc['profileImage'] ?? '';
    profileImage = name;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index];
            String postId = post.id;
            String userId = post['uid'];
            String name = post['name'];
            String text = post['text'];
            String imageUrl = post['image'] ?? '';
            Timestamp? timestamp = post['timestamp'] as Timestamp?;
            List<dynamic> likes = post['likes'] ?? []; // Store liked users
            String timeAgo =
                timestamp != null ? _timeAgo(timestamp.toDate()) : 'Just now';
            bool isLiked = likes.contains(_auth.currentUser!.uid);

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: profileImage != null &&
                                    profileImage.isNotEmpty
                                ? NetworkImage(profileImage) as ImageProvider
                                : null, // Show image if available
                            child: profileImage == null || profileImage.isEmpty
                                ? Icon(Icons.person,
                                    color: Colors.grey) // Show icon if no image
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              timeAgo,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.more_horiz, color: Colors.black54),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Text(
                      text,
                      style: const TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 8),

                    if (imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      ),

                    const SizedBox(height: 8),

                    // Like & Comment Section
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _toggleLike(postId, likes),
                          child: Icon(
                            isLiked ? LucideIcons.heart : LucideIcons.heart,
                            size: 24,
                            color: isLiked ? Colors.red : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(likes.length.toString()),
                        const SizedBox(width: 16),
                        const Icon(LucideIcons.messageCircle, size: 24),
                        const SizedBox(width: 4),
                        const Text("69"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Like/Unlike function
  void _toggleLike(String postId, List<dynamic> likes) {
    String userId = _auth.currentUser!.uid;
    if (likes.contains(userId)) {
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }

  // Time Formatting
  String _timeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    return "${difference.inDays}d ago";
  }
}
