import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostWidget extends StatefulWidget {
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int _currentIndex = 0;
  final List<String> _imageUrls = [
    "https://via.placeholder.com/150", // Replace with actual images
    "https://via.placeholder.com/150",
    "https://via.placeholder.com/150",
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.black)),
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
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Const_Ansh",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "22m ago",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.more_horiz, color: Colors.black54),
              ],
            ),
            SizedBox(height: 8),

            // Post Content
            Text(
              "🚀 The Future of Finance: Bitcoin & Digital Assets\n"
              "Revolutionizing the Game! 🔥💰 #Crypto #Bitcoin #Web3",
              style: TextStyle(fontSize: 14),
            ),

            SizedBox(height: 8),

            // Image Carousel
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: _imageUrls.map((url) {
                  return Container(
                    width: double.infinity,
                    color: Colors.grey.shade300, // Placeholder background
                    child: Image.network(url, fit: BoxFit.cover),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 8),

            // Dot Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imageUrls.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.black
                        : Colors.grey.shade400,
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 8),

            // Like & Comment Section
            Row(
              children: [
                Icon(LucideIcons.heart, size: 24),
                SizedBox(width: 4),
                Text("69"),
                SizedBox(width: 16),
                Icon(LucideIcons.messageCircle, size: 24),
                SizedBox(width: 4),
                Text("69"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
