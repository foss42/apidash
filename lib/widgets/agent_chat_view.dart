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

// Chat timeline where each agent turn is rendered via OpenResponsesViewer.
// Same structured cards as the response panel (reasoning, tool calls, message)
// but embedded inline inside the conversation instead of a separate pane.
class AgentChatView extends StatelessWidget {
  const AgentChatView({super.key, required this.turns});

  final List<AgentChatTurn> turns;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: kP8,
      itemCount: turns.length,
      separatorBuilder: (_, __) => kVSpacer10,
      itemBuilder: (_, i) => _TurnWidget(turn: turns[i]),
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
    final modelLabel = widget.response.model.isNotEmpty
        ? widget.response.model
        : 'agent';

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
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
                  Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant),
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
