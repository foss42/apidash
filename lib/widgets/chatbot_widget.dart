import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotWidget extends ConsumerStatefulWidget {
  const ChatbotWidget({Key? key}) : super(key: key);

  @override
  _ChatbotWidgetState createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends ConsumerState<ChatbotWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  List<Map<String, dynamic>> get _messages => ref.watch(chatMessagesProvider);

  Future<void> _handleCodeGeneration() async {
    final language = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var lang in [
                'Flutter (UI)',
                'React (UI)',
                'Dart (Console)',
                'Python',
                'JavaScript',
                'Node.js',
                'Java',
                'C#'
              ])
                ListTile(
                  title: Text(lang),
                  onTap: () => Navigator.pop(context, lang),
                ),
            ],
          ),
        ),
      ),
    );

    if (language != null) {
      _sendMessage("Generate $language Code");
    }
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    final ollamaService = ref.read(ollamaServiceProvider);
    final requestModel = ref.read(selectedRequestModelProvider);
    final responseModel = requestModel?.httpResponseModel;

    setState(() {
      _isLoading = true;
    });

    ref.read(chatMessagesProvider.notifier).addMessage({
      'role': 'user',
      'message': message
    });

    try {
      String response;

      if (message == "Explain API") {
        response = await ollamaService.explainLatestApi(
          requestModel: requestModel,
          responseModel: responseModel,
        );
      } else if (message == "Debug API") {
        response = await ollamaService.debugApi(
          requestModel: requestModel,
          responseModel: responseModel,
        );
      } else if (message == "Generate Test Case") {
        response = await ollamaService.generateTestCases(
          requestModel: requestModel,
          responseModel: responseModel,
        );
      } else if (message.startsWith("Generate ") && message.endsWith(" Code")) {
        final language = message.replaceAll("Generate ", "").replaceAll(" Code", "");
        response = await ollamaService.generateCode(
          requestModel: requestModel,
          responseModel: responseModel,
          language: language,
        );
      } else {
        response = await ollamaService.generateResponse(message);
      }

      setState(() {
        _messages.add({
          'role': 'bot',
          'message': response.contains("```") ? response : "```\n$response\n```"
        });
      });
    } catch (error) {
      setState(() {
        _messages.add({'role': 'bot', 'message': "Error: ${error.toString()}"});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestModel = ref.watch(selectedRequestModelProvider);
    final statusCode = requestModel?.httpResponseModel?.statusCode;
    final showDebugButton = statusCode != null && statusCode >= 400;

    return Container(
      height: 450,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('DashBot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear Chat History',
                onPressed: () => ref.read(chatMessagesProvider.notifier).clearMessages(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _sendMessage("Explain API"),
                icon: const Icon(Icons.info_outline),
                label: const Text("Explain API"),
              ),
              if (showDebugButton)
                ElevatedButton.icon(
                  onPressed: () => _sendMessage("Debug API"),
                  icon: const Icon(Icons.bug_report),
                  label: const Text("Debug"),
                ),
              ElevatedButton.icon(
                onPressed: () => _sendMessage("Generate Test Case"),
                icon: const Icon(Icons.developer_mode),
                label: const Text("Test Case"),
              ),
              ElevatedButton.icon(
                onPressed: _handleCodeGeneration,
                icon: const Icon(Icons.code),
                label: const Text("Generate Code"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                return ChatBubble(
                  message: message['message'],
                  isUser: message['role'] == 'user',
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask something...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: MarkdownBody(
          data: message,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            h2: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            h3: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            listBullet: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
