import 'package:flutter/material.dart';

import '../../../common/commontextfield.dart';
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

  void sendmessage() async {
    if (messagecontroller.text.isNotEmpty) {
      await _chatservices.sendmessage(
          widget.receiverID, messagecontroller.text);
      messagecontroller.clear();
      scrolldown();
    }
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
              onPressed: sendmessage,
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
