import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import "snackbars.dart";

class CopyButton extends StatefulWidget {
  const CopyButton({super.key, required this.toCopy});

  final String toCopy;
  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return TextButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: widget.toCopy));
        sm.hideCurrentSnackBar();
        sm.showSnackBar(getSnackBar("Copied"));
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

class SaveInDownloadsButton extends StatefulWidget {
  const SaveInDownloadsButton({
    super.key,
    this.content,
    this.mimeType,
    this.name,
  });

  final Uint8List? content;
  final String? mimeType;
  final String? name;

  @override
  State<SaveInDownloadsButton> createState() => _SaveInDownloadsButtonState();
}

class _SaveInDownloadsButtonState extends State<SaveInDownloadsButton> {
  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return TextButton(
      onPressed: (widget.content != null)
          ? () async {
              var message = "";
              var ext = getFileExtension(widget.mimeType);
              var path = await getFileDownloadpath(
                widget.name,
                ext,
              );
              if (path != null) {
                try {
                  await saveFile(path, widget.content!);
                  var sp = getShortPath(path);
                  message = 'Saved to $sp';
                } catch (e) {
                  message = "An error occurred while saving file.";
                }
              } else {
                message = "Unable to determine the download path.";
              }
              sm.hideCurrentSnackBar();
              sm.showSnackBar(getSnackBar(message, small: false));
            }
          : null,
      child: Row(
        children: const [
          Icon(
            Icons.download,
            size: 20,
          ),
          Text(kLabelDownload)
        ],
      ),
    );
  }
}
