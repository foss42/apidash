// Standalone demo for AgentChatView.
// Run: flutter run -t lib/agent_chat_demo.dart
// Needs mock_server.py running: python3 mock_server.py
import 'package:flutter/material.dart';
import 'widgets/agent_chat_view.dart';

void main() => runApp(const _Demo());

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agent Chat Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agent Chat'),
          centerTitle: true,
        ),
        body: const AgentChatView(
          serverUrl: 'https://apidash-liart.vercel.app',
        ),
      ),
    );
  }
}
