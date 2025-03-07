import 'package:flutter/material.dart';

class MemonicsScreen extends StatefulWidget {
  const MemonicsScreen({super.key});

  @override
  State<MemonicsScreen> createState() => _MemonicsScreenState();
}

class _MemonicsScreenState extends State<MemonicsScreen> {
  final List<String> phrases = List.filled(12, "syncora");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text(
                "Save your recovery Phrase",
                style: TextStyle(
                  fontFamily: 'fontMain',
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),

            // Warning Text
            const Text(
              "Keep it in a secure place that is not accessible to others and avoid sharing it with anyone.",
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Recovery Phrase Grid
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView.builder(
                itemCount: phrases.length,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling inside Grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        "#${index + 1}. ${phrases[index]}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // "Click to Copy" Text
            const Text(
              "click to copy",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Continue Button
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  // Add navigation or action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Skip Button
            TextButton(
              onPressed: () {
                // Skip action
              },
              child: Text(
                "skip",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
