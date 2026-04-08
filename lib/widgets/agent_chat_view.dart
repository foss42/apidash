import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

import 'open_responses_viewer.dart';

class AgentChatTurn {
  const AgentChatTurn({
    required this.userMessage,
    required this.agentResponse,
  });

  final String userMessage;
  final OpenResponsesResult agentResponse;
}

// Interactive chat timeline. User types a message, the widget POSTs it to
// [serverUrl]/mcp/query, and the Open Responses reply renders inline.
// Pass [initialTurns] to pre-populate the conversation (e.g. from /agent-chat).
class AgentChatView extends StatefulWidget {
  const AgentChatView({
    super.key,
    this.initialTurns = const [],
    this.serverUrl = 'http://localhost:8765',
  });

  final List<AgentChatTurn> initialTurns;
  final String serverUrl;

  @override
  State<AgentChatView> createState() => _AgentChatViewState();
}

class _AgentChatViewState extends State<AgentChatView> {
  late final List<AgentChatTurn> _turns;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _turns = List.of(widget.initialTurns);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final message = _controller.text.trim();
    if (message.isEmpty || _loading) return;

    _controller.clear();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await post(
        Uri.parse('${widget.serverUrl}/mcp/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );
      if (!mounted) return;
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final result = OpenResponsesResult.fromJson(json);
        setState(() => _turns.add(AgentChatTurn(
              userMessage: message,
              agentResponse: result,
            )));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        setState(() => _error = 'Server returned ${res.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Could not reach ${widget.serverUrl} — is mock_server.py running?');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: _turns.isEmpty && !_loading
              ? Center(
                  child: Text(
                    'Ask the agent something',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: kP8,
                  itemCount: _turns.length + (_loading ? 1 : 0),
                  separatorBuilder: (_, __) => kVSpacer10,
                  itemBuilder: (_, i) {
                    if (i == _turns.length) return _TypingIndicator();
                    return _TurnWidget(turn: _turns[i]);
                  },
                ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              _error!,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ),
        _InputBar(
          controller: _controller,
          loading: _loading,
          onSend: _send,
        ),
      ],
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.loading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool loading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !loading,
              decoration: InputDecoration(
                hintText: 'Ask the agent…',
                hintStyle: TextStyle(color: theme.colorScheme.outline),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          kHSpacer8,
          loading
              ? SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                )
              : IconButton.filled(
                  onPressed: onSend,
                  icon: const Icon(Icons.send_rounded, size: 18),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(36, 36),
                  ),
                ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.auto_awesome_rounded,
              size: 16, color: theme.colorScheme.primary),
        ),
        kHSpacer8,
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Row(
            children: List.generate(3, (i) {
              final delay = i / 3;
              final t = (_anim.value - delay).clamp(0.0, 1.0);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary
                      .withValues(alpha: 0.3 + 0.7 * t),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _TurnWidget extends StatelessWidget {
  const _TurnWidget({required this.turn});
  final AgentChatTurn turn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UserBubble(message: turn.userMessage),
        kVSpacer8,
        _AgentResponseCard(response: turn.agentResponse),
      ],
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: kP8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        kHSpacer8,
        CircleAvatar(
          radius: 14,
          backgroundColor: theme.colorScheme.primary,
          child: Icon(Icons.person_rounded,
              size: 16, color: theme.colorScheme.onPrimary),
        ),
      ],
    );
  }
}

class _AgentResponseCard extends StatefulWidget {
  const _AgentResponseCard({required this.response});
  final OpenResponsesResult response;

  @override
  State<_AgentResponseCard> createState() => _AgentResponseCardState();
}

class _AgentResponseCardState extends State<_AgentResponseCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = widget.response.output.length;
    final modelLabel =
        widget.response.model.isNotEmpty ? widget.response.model : 'agent';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.auto_awesome_rounded,
              size: 16, color: theme.colorScheme.primary),
        ),
        kHSpacer8,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(12),
                  ),
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Row(
                      children: [
                        Text(
                          modelLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        kHSpacer8,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$itemCount items',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _expanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          size: 16,
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_expanded) ...[
                  Divider(height: 1, color: theme.colorScheme.outlineVariant),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 420),
                    child: OpenResponsesViewer(result: widget.response),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
