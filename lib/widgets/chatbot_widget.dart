import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class ChatbotWidget extends ConsumerStatefulWidget {
  const ChatbotWidget({Key? key}) : super(key: key);

  @override
  _ChatbotWidgetState createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends ConsumerState<ChatbotWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    final ollamaService = ref.read(ollamaServiceProvider);
    final requestModel = ref.read(selectedRequestModelProvider);
    final responseModel = requestModel?.httpResponseModel;

    setState(() {
      _messages.add({'role': 'user', 'message': message});
      _controller.clear();
      _isLoading = true;
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
      } else {
        response = await ollamaService.generateResponse(message);
      }

      setState(() {
        _messages.add({'role': 'bot', 'message': response});
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
      height: 400,
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
            children: [
              ElevatedButton.icon(
                onPressed: () => _sendMessage("Explain API"),
                icon: const Icon(Icons.info_outline),
                label: const Text("Explain API"),
              ),
              if (showDebugButton) ...[
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _sendMessage("Debug API"),
                  icon: const Icon(Icons.bug_report),
                  label: const Text("Debug"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Ask something...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
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
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(message),
      ),
    );
  }
}
