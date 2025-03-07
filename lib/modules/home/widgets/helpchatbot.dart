import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HelpChatbot extends StatefulWidget {
  const HelpChatbot({super.key});

  @override
  State<HelpChatbot> createState() => _HelpChatbotState();
}

class _HelpChatbotState extends State<HelpChatbot> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request necessary permissions

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.dataFromString(_getHtml(), mimeType: 'text/html'));
  }

  // Request permissions for mic and storage
  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  // Injects HTML with voice and image upload support
  String _getHtml() {
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Botpress Chatbot</title>
        <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
        <script src="https://files.bpcontent.cloud/2025/02/19/13/20250219135903-7DA499PG.js"></script>
        <script src="https://cdn.botpress.cloud/webchat/addons/file-upload.js"></script>
        <script src="https://cdn.botpress.cloud/webchat/addons/voice-input.js"></script>
    </head>
    <body>
        <h1>Chatbot</h1>
        <p>Interact using voice or image upload.</p>
    </body>
    </html>
    """;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help Chatbot")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
