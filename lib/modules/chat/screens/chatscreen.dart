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

  // final Authservices _auth = Authservices();
  final Chatservices _chatservices = Chatservices();

  //for textfield scroll

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //add listner to focus node
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        //cause a delay so that the keyboard has time to show up
        //then the amount of remaining space is calculated
        //then scroll down
        Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
      }
    });
    //wait a bit for the list view to be built, then scrolldown
    Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    messagecontroller.dispose();
  }

//scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrolldown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message
  void sendmessage() async {
    //if message is not empty
    if (messagecontroller.text.isNotEmpty) {
      //send message
      await _chatservices.sendmessage(
          widget.receiverID, messagecontroller.text);
      //clear message
      messagecontroller.clear();

      //scrolldown
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
        title: Text(
          widget.username,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //message list
          Expanded(
            child: Messagelist(
              receiverID: widget.receiverID,
              scrollController: _scrollController,
            ),
          ),
          //textfield
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
              // margin: EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: sendmessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ));
  }
}
