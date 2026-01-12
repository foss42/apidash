import 'package:apidash/screens/home_page/editor_pane/details_card/websocket_message_pane.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'error_message.dart';

class WebsocketResponseMessage extends StatelessWidget {
  const WebsocketResponseMessage({
    super.key,
    this.selectedRequestModel,
    this.isPartOfHistory = false,
  });

  final RequestModel? selectedRequestModel;
  final bool isPartOfHistory;

  @override
  Widget build(BuildContext context) {
    final websocketConnectionModel =
        selectedRequestModel?.websocketConnectionModel;
    if (websocketConnectionModel == null) {
      return const ErrorMessage(
          message: '$kNullResponseModelError $kUnexpectedRaiseIssue');
    }

    var messages = websocketConnectionModel.messages;

    if (messages.isEmpty) {
      return const ErrorMessage(
        message: kMsgNoContent,
        showIcon: false,
        showIssueButton: false,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return WebSocketMessageTile(message: messages[index]);
      },
    );
  }
}
