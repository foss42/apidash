import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';

class CopyButton extends StatefulWidget {
  const CopyButton({super.key, required this.toCopy});

  final String toCopy;
  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: widget.toCopy));
      },
      child: Row(
        children: const [
          Icon(
            Icons.content_copy,
            size: 20,
          ),
          Text(kLabelCopy)
        ],
      ),
    );
  }
}

class SendRequestButton extends StatefulWidget {
  const SendRequestButton({
    super.key,
    required this.activeId,
    required this.sentRequestId,
    required this.onTap,
  });

  final String? activeId;
  final String? sentRequestId;
  final void Function() onTap;

  @override
  State<SendRequestButton> createState() => _SendRequestButtonState();
}

class _SendRequestButtonState extends State<SendRequestButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool disable = widget.sentRequestId != null;
    return FilledButton(
      onPressed: disable ? null : widget.onTap,
      child: Row(
        children: [
          Text(
            disable
                ? (widget.activeId == widget.sentRequestId
                    ? kLabelSending
                    : kLabelBusy)
                : kLabelSend,
            style: kTextStyleButton,
          ),
          if (!disable) kHSpacer10,
          if (!disable)
            const Icon(
              size: 16,
              Icons.send,
            ),
        ],
      ),
    );
  }
}
