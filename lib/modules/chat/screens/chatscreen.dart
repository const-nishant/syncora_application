import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncora_application/modules/auth/data/services/walletaddressservices.dart';
import '../../../common/commontextfield.dart';
import '../../auth/auth_exports.dart';
import '../data/data_exports.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String receiversEmail;
  final String receiverID;

  const ChatScreen({
    super.key,
    required this.receiversEmail,
    required this.username,
    required this.receiverID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messagecontroller = TextEditingController();
  final Chatservices _chatservices = Chatservices();
  final ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Scroll down when the focus is gained
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
      }
    });

    // Scroll down initially after a delay
    Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
  }

  @override
  void dispose() {
    focusNode.dispose();
    messagecontroller.dispose();
    super.dispose();
  }

  void scrolldown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void sendMessage() async {
    if (messagecontroller.text.isNotEmpty) {
      String messageText = messagecontroller.text;

      // Regex to check for token transfer command
      RegExp regex = RegExp(r'request\s+@(\w+)\s+(\d+)\s+token');
      Match? match = regex.firstMatch(messageText);

      if (match != null) {
        String username = match.group(1)!; // Extracted username
        int amount = int.parse(match.group(2)!); // Extracted amount

        Provider.of<AuthServices>(context, listen: false)
            .requestTokens(username, amount, context);
      }

      RegExp sendregex = RegExp(r'send\s+@(\w+)\s+(\d+)\s+token');
      Match? sendmatch = sendregex.firstMatch(messageText);

      if (sendmatch != null) {
        String username = sendmatch.group(1)!; // Extracted username
        int amount = int.parse(sendmatch.group(2)!); // Extracted amount

        // Show confirmation dialog
        showConfirmationDialog(context, username, amount);
      }
      await _chatservices.sendmessage(widget.receiverID, messageText);
      messagecontroller.clear();
      scrolldown();
    }
  }

  void checkusernameWalletAddress(String username, String txnValue) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.first);

    if (userSnapshot.exists) {
      String walletAddress = userSnapshot['walletAddress'];
      Provider.of<WalletProvider>(context, listen: false)
          .sendTokens(walletAddress, txnValue, context);
    }
  }

  void showConfirmationDialog(
      BuildContext context, String username, int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Transaction'),
          content: Text('Do you want to send $amount tokens to $username?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Perform the transaction logic here
                checkusernameWalletAddress(username, amount.toString());
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        title: Text(widget.username),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Messagelist(
              receiverID: widget.receiverID,
              scrollController: _scrollController,
            ),
          ),
          _buildsendmessage(),
        ],
      ),
    );
  }

  Widget _buildsendmessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Commontextfield(
              keyboardType: TextInputType.text,
              focusNode: focusNode,
              hintText: "Message",
              controller: messagecontroller,
              readOnly: false,
              obscureText: false,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => sendMessage(),
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
