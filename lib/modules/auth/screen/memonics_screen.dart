import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/modules/auth/screen/verifymnemonics.dart';
import '../data/services/authservices.dart';

class MemonicsScreen extends StatefulWidget {
  const MemonicsScreen({super.key});

  @override
  State<MemonicsScreen> createState() => _MemonicsScreenState();
}

class _MemonicsScreenState extends State<MemonicsScreen> {
  late Future<String?> _mnemonicFuture;

  @override
  void initState() {
    super.initState();
    _mnemonicFuture =
        Provider.of<AuthServices>(context, listen: false).getmenoics();
  }

  String? mnemonic;

  void copytoClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Text(
                "Save your recovery Phrase",
                style: TextStyle(
                  fontFamily: 'fontMain',
                  fontSize: 24,
                  color: Color(0xFF6A3200),
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
            FutureBuilder<String?>(
              future: _mnemonicFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading mnemonic'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No mnemonic found'));
                } else {
                  final mnemonic = snapshot.data!;
                  this.mnemonic = mnemonic;
                  final mnemonicWords = mnemonic.split(" ");
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GridView.builder(
                      itemCount: mnemonicWords.length,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling inside Grid
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              "#${index + 1}. ${mnemonicWords[index]}",
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
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // "Click to Copy" Text
            TextButton(
              onPressed: () => copytoClipboard(mnemonic ?? ''),
              child: Text(
                "click to copy",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 20),

            // Continue Button
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Verifymnemonics(mnemonic: mnemonic ?? '');
                  }));
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
          ],
        ),
      ),
    );
  }
}
