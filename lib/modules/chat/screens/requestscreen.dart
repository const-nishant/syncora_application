import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_exports.dart';

class Requestscreen extends StatefulWidget {
  const Requestscreen({super.key});

  @override
  State<Requestscreen> createState() => _RequestscreenState();
}

class _RequestscreenState extends State<Requestscreen> {
  Future<void> handleRequest(String requestId, bool isApproved) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot requestDoc =
          await firestore.collection('requests').doc(requestId).get();

      if (!requestDoc.exists) {
        throw Exception("Request does not exist.");
      }

      // ignore: unused_local_variable
      String sender = requestDoc['sender'];
      String receiver = requestDoc['receiver'];
      int amount = requestDoc['amount'];

      if (isApproved) {
        await Provider.of<WalletProvider>(context, listen: false)
            .sendTokens(receiver, amount.toString(), context);

        await firestore
            .collection('requests')
            .doc(requestId)
            .update({'status': 'approved'});
      } else {
        await firestore
            .collection('requests')
            .doc(requestId)
            .update({'status': 'declined'});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isApproved ? "Request approved!" : "Request declined."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing request: $e")),
      );
    }
  }

  Stream<QuerySnapshot> getPendingRequests() {
    return FirebaseFirestore.instance
        .collection('requests')
        .where('receiver', isEqualTo: "receiverUsername") // Placeholder
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Requests",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      )),
      body: FutureBuilder<String>(
        future: Provider.of<AuthServices>(context, listen: false)
            .getCurrentUsername(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          String receiverUsername = snapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requests')
                .where('receiver', isEqualTo: receiverUsername)
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var requests = snapshot.data!.docs;
              if (requests.isEmpty) {
                return Center(
                    child: Text(
                  "No pending requests",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ));
              }

              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  var request = requests[index];
                  return ListTile(
                    title: Text(
                        "@${request['sender']} requested ${request['amount']} tokens"),
                    subtitle: Text("Status: ${request['status']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => handleRequest(request.id, true),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => handleRequest(request.id, false),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
