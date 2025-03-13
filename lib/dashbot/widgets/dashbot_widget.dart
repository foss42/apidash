import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/providers/dashbot_providers.dart';
import 'package:apidash/providers/providers.dart';
import 'test_runner_widget.dart';
import 'chat_bubble.dart';

class DashBotWidget extends ConsumerStatefulWidget {
  const DashBotWidget({super.key});

  @override
  ConsumerState<DashBotWidget> createState() => _DashBotWidgetState();
}

class _DashBotWidgetState extends ConsumerState<DashBotWidget> {
  final TextEditingController _controller = TextEditingController();
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final dashBotService = ref.read(dashBotServiceProvider);
    final requestModel = ref.read(selectedRequestModelProvider);
    final responseModel = requestModel?.httpResponseModel;

    setState(() => _isLoading = true);

    ref.read(chatMessagesProvider.notifier).addMessage({
      'role': 'user',
      'message': message,
    });

    try {
      final response = await dashBotService.handleRequest(
          message, requestModel, responseModel);

      // If "Test API" is requested, append a button to the response
      final botMessage = message == "Test API"
          ? "$response\n\n**[Run Test Cases]**"
          : response;

      ref.read(chatMessagesProvider.notifier).addMessage({
        'role': 'bot',
        'message': botMessage,
      });
    } catch (error, stackTrace) {
      debugPrint('Error in _sendMessage: $error');
      debugPrint('StackTrace: $stackTrace');
      ref.read(chatMessagesProvider.notifier).addMessage({
        'role': 'bot',
        'message': "Error: ${error.toString()}",
      });
    } finally {
      setState(() => _isLoading = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showTestRunner(String testCases) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 500,
          child: TestRunnerWidget(testCases: testCases),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final requestModel = ref.read(selectedRequestModelProvider);
    final statusCode = requestModel?.httpResponseModel?.statusCode;
    final showDebugButton = statusCode != null && statusCode >= 400;

    return Container(
      height: 450,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildQuickActions(showDebugButton),
          const SizedBox(height: 12),
          Expanded(child: _buildChatArea(messages)),
          if (_isLoading) _buildLoadingIndicator(),
          const SizedBox(height: 10),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('DashBot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          tooltip: 'Clear Chat',
          onPressed: () {
            ref.read(chatMessagesProvider.notifier).clearMessages();
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool showDebugButton) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: () => _sendMessage("Explain API"),
          icon: const Icon(Icons.info_outline),
          label: const Text("Explain"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        if (showDebugButton)
          ElevatedButton.icon(
            onPressed: () => _sendMessage("Debug API"),
            icon: const Icon(Icons.bug_report_outlined),
            label: const Text("Debug"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ElevatedButton.icon(
          onPressed: () => _sendMessage("Document API"),
          icon: const Icon(Icons.description_outlined),
          label: const Text("Document"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _sendMessage("Test API"),
          icon: const Icon(Icons.science_outlined),
          label: const Text("Test"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildChatArea(List<Map<String, dynamic>> messages) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages.reversed.toList()[index];
        final isBot = message['role'] == 'bot';
        final text = message['message'] as String;

        // Check if the message contains the "Run Test Cases" button
        if (isBot && text.contains("[Run Test Cases]")) {
          final testCases = text.replaceAll("\n\n**[Run Test Cases]**", "");
          return Column(
            crossAxisAlignment:
            isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              ChatBubble(message: testCases, isUser: false),
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                child: ElevatedButton(
                  onPressed: () => _showTestRunner(testCases),
                  child: const Text("Run Test Cases"),
                ),
              ),
            ],
          );
        }

        return ChatBubble(
          message: text,
          isUser: message['role'] == 'user',
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: LinearProgressIndicator(),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ask DashBot...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                _sendMessage(value);
                _controller.clear();
              },
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(_controller.text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
