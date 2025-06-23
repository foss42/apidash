import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/providers/dashbot_providers.dart';
import 'package:apidash/providers/providers.dart';
import 'test_runner_widget.dart';
import 'chat_bubble.dart';

class DashBotWidget extends ConsumerStatefulWidget {
  const DashBotWidget({
    super.key,
  });

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
      if (response.startsWith("TEST_CASES_HIDDEN\n")) {
        final testCases = response.replaceFirst("TEST_CASES_HIDDEN\n", "");
        ref.read(chatMessagesProvider.notifier).addMessage({
          'role': 'bot',
          'message':
              "Test cases generated successfully. Click the button below to run them.",
          'testCases': testCases,
          'showTestButton': true,
        });
      } else {
        ref.read(chatMessagesProvider.notifier).addMessage({
          'role': 'bot',
          'message': response,
        });
      }
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
          _scrollController.position.minScrollExtent,
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
    final isMinimized = ref.watch(dashBotMinimizedProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isMinimized
          ? _buildMinimizedView(context)
          : Column(
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
    final isMinimized = ref.watch(dashBotMinimizedProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'DashBot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                padding: const EdgeInsets.all(8),
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  isMinimized ? Icons.fullscreen : Icons.remove,
                  size: 20,
                ),
                tooltip: isMinimized ? 'Maximize' : 'Minimize',
                onPressed: () {
                  ref.read(dashBotMinimizedProvider.notifier).state =
                      !isMinimized;
                },
              ),
              IconButton(
                padding: const EdgeInsets.all(8),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                padding: const EdgeInsets.all(8),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_sweep, size: 20),
                tooltip: 'Clear Chat',
                onPressed: () {
                  ref.read(chatMessagesProvider.notifier).clearMessages();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinimizedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildInputArea(context),
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool showDebugButton) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton.icon(
            onPressed: () => _sendMessage("Explain API"),
            icon: const Icon(Icons.info_outline, size: 16),
            label: const Text("Explain"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              visualDensity: VisualDensity.compact,
            ),
          ),
          if (showDebugButton)
            ElevatedButton.icon(
              onPressed: () => _sendMessage("Debug API"),
              icon: const Icon(Icons.bug_report_outlined, size: 16),
              label: const Text("Debug"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ElevatedButton.icon(
            onPressed: () => _sendMessage("Document API"),
            icon: const Icon(Icons.description_outlined, size: 16),
            label: const Text("Document"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              visualDensity: VisualDensity.compact,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _sendMessage("Test API"),
            icon: const Icon(Icons.science_outlined, size: 16),
            label: const Text("Test"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(List<Map<String, dynamic>> messages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages.reversed.toList()[index];
          final isBot = message['role'] == 'bot';
          final text = message['message'] as String;
          final showTestButton = message['showTestButton'] == true;
          final testCases = message['testCases'] as String?;

          if (isBot && showTestButton && testCases != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChatBubble(message: text, isUser: false),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                  child: ElevatedButton.icon(
                    onPressed: () => _showTestRunner(testCases),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text("Run Test Cases"),
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
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
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LinearProgressIndicator(),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final isMinimized = ref.watch(dashBotMinimizedProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ask DashBot...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (value) {
                _sendMessage(value);
                _controller.clear();
                if (isMinimized) {
                  ref.read(dashBotMinimizedProvider.notifier).state = false;
                }
              },
              maxLines: 1,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.send, size: 20),
            onPressed: () {
              _sendMessage(_controller.text);
              _controller.clear();
              if (isMinimized) {
                ref.read(dashBotMinimizedProvider.notifier).state = false;
              }
            },
          ),
        ],
      ),
    );
  }
}
