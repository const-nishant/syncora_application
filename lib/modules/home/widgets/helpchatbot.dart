import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse("https://cdn.botpress.cloud/webchat/v2.3/shareable.html?configUrl=https://files.bpcontent.cloud/2025/02/19/13/20250219135903-P62NW4N2.json"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help Chatbot")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
