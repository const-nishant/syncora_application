import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission handler

class Helpchatbot extends StatefulWidget {
  const Helpchatbot({super.key});

  @override
  State<Helpchatbot> createState() => _HelpchatbotState();
}

class _HelpchatbotState extends State<Helpchatbot> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request microphone permissions

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse(
          "https://cdn.botpress.cloud/webchat/v2.3/shareable.html?configUrl=https://files.bpcontent.cloud/2025/02/19/13/20250219135903-P62NW4N2.json"))
      ..runJavaScript("""
      document.body.addEventListener("click", function() {
          var audioElements = document.getElementsByTagName('audio');
          for (var i = 0; i < audioElements.length; i++) {
              audioElements[i].play();
          }
      });
  """);
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Microphone permission is required for voice input.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help Chatbot")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
