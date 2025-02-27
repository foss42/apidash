import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/providers/dashbot_providers.dart';
import 'package:apidash/providers/providers.dart';
import 'package:highlighter/highlighter.dart' show highlight;
import 'package:json_explorer/json_explorer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';

class DashBotWidget extends ConsumerStatefulWidget {
  const DashBotWidget({Key? key}) : super(key: key);

  @override
  _DashBotWidgetState createState() => _DashBotWidgetState();
}

class _DashBotWidgetState extends ConsumerState<DashBotWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

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
      final response = await dashBotService.handleRequest(message, requestModel, responseModel);
      final formattedResponse = _limitResponse(response);

      ref.read(chatMessagesProvider.notifier).addMessage({
        'role': 'bot',
        'message': formattedResponse,
      });
    } catch (error) {
      ref.read(chatMessagesProvider.notifier).addMessage({
        'role': 'bot',
        'message': "Error: ${error.toString()}",
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _limitResponse(String response) {
    return response;
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
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
        const Text('DashBot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy Last Response',
              onPressed: () {
                final lastBotMessage = ref.read(chatMessagesProvider).lastWhere(
                      (msg) => msg['role'] == 'bot',
                  orElse: () => {'message': ''},
                )['message'];
                Share.share(lastBotMessage);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear Chat',
              onPressed: () => ref.read(chatMessagesProvider.notifier).clearMessages(),
            ),
          ],
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
      ],
    );
  }

  Widget _buildChatArea(List<Map<String, dynamic>> messages) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages.reversed.toList()[index];
        return ChatBubble(
          message: message['message'],
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
              onSubmitted: _sendMessage,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(_controller.text),
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
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: _renderContent(context, message),
      ),
    );
  }

  Widget _renderContent(BuildContext context, String text) {
    final codeBlockPattern = RegExp(r'```(\w+)?\n([\s\S]*?)```', multiLine: true);
    final matches = codeBlockPattern.allMatches(text);

    if (matches.isEmpty) {
      return MarkdownBody(
        data: text,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          h3: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
          strong: TextStyle(fontWeight: FontWeight.bold),
          em: TextStyle(fontStyle: FontStyle.italic),
          listBullet: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          p: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      );
    }

    List<Widget> children = [];
    int lastEnd = 0;

    for (var match in matches) {
      if (match.start > lastEnd) {
        children.add(
          MarkdownBody(
            data: text.substring(lastEnd, match.start),
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              h3: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
              strong: TextStyle(fontWeight: FontWeight.bold),
              em: TextStyle(fontStyle: FontStyle.italic),
              listBullet: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              p: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        );
      }

      final language = match.group(1) ?? 'text';
      final code = match.group(2)!.trim();

      if (language == 'json' && _isValidJson(code)) {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonDecode(code));
        children.add(
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: SelectableText(
              prettyJson,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        );
      } else {
        final highlighted = highlight.parse(code, language: language);
        final spans = _buildTextSpans(highlighted, context);
        children.add(
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: SelectableText.rich(
              TextSpan(children: spans),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        );
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      children.add(
        MarkdownBody(
          data: text.substring(lastEnd),
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            h3: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
            strong: TextStyle(fontWeight: FontWeight.bold),
            em: TextStyle(fontStyle: FontStyle.italic),
            listBullet: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            p: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: children,
    );
  }

  bool _isValidJson(String text) {
    try {
      jsonDecode(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  List<TextSpan> _buildTextSpans(dynamic highlighted, BuildContext context) {
    final List<TextSpan> spans = [];
    for (var span in highlighted.spans ?? []) {
      spans.add(TextSpan(
        text: span.text,
        style: TextStyle(
          color: _getColorForClassName(span.className, context),
        ),
      ));
    }
    return spans.isEmpty ? [TextSpan(text: highlighted.source)] : spans;
  }

  Color _getColorForClassName(String? className, BuildContext context) {
    switch (className) {
      case 'keyword':
        return Colors.blue;
      case 'string':
        return Colors.green;
      case 'comment':
        return Colors.grey;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }
}
