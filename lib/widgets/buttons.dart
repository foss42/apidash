import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import "snackbars.dart";

class CopyButton extends StatefulWidget {
  const CopyButton({
    super.key,
    required this.toCopy,
    this.showLabel = true,
  });

  final String toCopy;
  final bool showLabel;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return Tooltip(
      message: widget.showLabel ? '' : kLabelCopy,
      child: SizedBox(
        width: widget.showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: widget.toCopy));
            sm.hideCurrentSnackBar();
            sm.showSnackBar(getSnackBar("Copied"));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.content_copy,
                size: 20,
              ),
              if (widget.showLabel) const Text(kLabelCopy)
            ],
          ),
        ),
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
        mainAxisSize: MainAxisSize.min,
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
    this.showLabel = true,
  });

  final Uint8List? content;
  final String? mimeType;
  final String? name;
  final bool showLabel;

  @override
  State<SaveInDownloadsButton> createState() => _SaveInDownloadsButtonState();
}

class _SaveInDownloadsButtonState extends State<SaveInDownloadsButton> {
  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return Tooltip(
      message: widget.showLabel ? '' : kLabelDownload,
      child: SizedBox(
        width: widget.showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.download,
                size: 20,
              ),
              if (widget.showLabel) const Text(kLabelDownload)
            ],
          ),
        ),
      ),
    );
  }
}
