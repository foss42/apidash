import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import "snackbars.dart";

class DeleteMessagesButton extends StatelessWidget {
  const DeleteMessagesButton({
    super.key,
    required this.onTap,
    this.showLabel = true,
  });

  final bool showLabel;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return Tooltip(
      message: showLabel ? '' : kLabelCopy,
      child: SizedBox(
        width: showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
          onPressed: () {
            onTap();
            sm.hideCurrentSnackBar();
            sm.showSnackBar(getSnackBar("Messages deleted"));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete,
                size: 20,
              ),
              if (showLabel) const Text(kLabelDelete)
            ],
          ),
        ),
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  const CopyButton({
    super.key,
    required this.toCopy,
    this.showLabel = true,
  });

  final String toCopy;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return Tooltip(
      message: showLabel ? '' : kLabelCopy,
      child: SizedBox(
        width: showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: toCopy));
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
              if (showLabel) const Text(kLabelCopy)
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectWebsocketButton extends StatelessWidget {
  const ConnectWebsocketButton({
    super.key,
    required this.selectedId,
    required this.sentRequestId,
    required this.connected,
    required this.onTap,
  });

  final String? selectedId;
  final String? sentRequestId;
  final bool connected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    bool disable = sentRequestId != null;
    bool isBusy = selectedId == sentRequestId;
    return FilledButton(
      onPressed: disable ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (disable)
            Text(
              (isBusy ? kLabelSending : kLabelBusy),
              style: kTextStyleButton,
            )
          else ...[
            Text(
              connected ? kLabelDisconnect : kLabelConnect,
              style: kTextStyleButton,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: VerticalDivider(
                color: Colors.white,
                thickness: 2,
                width: 2,
              ),
            ),
            CircleAvatar(
              radius: 8,
              backgroundColor: connected ? Colors.green : Colors.red,
            ),
          ]
        ],
      ),
    );
  }
}

class SendRequestButton extends StatelessWidget {
  const SendRequestButton({
    super.key,
    required this.selectedId,
    required this.sentRequestId,
    required this.onTap,
  });

  final String? selectedId;
  final String? sentRequestId;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    bool disable = sentRequestId != null;
    return FilledButton(
      onPressed: disable ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            disable
                ? (selectedId == sentRequestId ? kLabelSending : kLabelBusy)
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

class SaveInDownloadsButton extends StatelessWidget {
  const SaveInDownloadsButton({
    super.key,
    this.content,
    this.mimeType,
    this.ext,
    this.name,
    this.showLabel = true,
  });

  final Uint8List? content;
  final String? mimeType;
  final String? ext;
  final String? name;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return Tooltip(
      message: showLabel ? '' : kLabelDownload,
      child: SizedBox(
        width: showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
          onPressed: (content != null)
              ? () async {
                  var message = "";
                  var path = await getFileDownloadpath(
                    name,
                    ext ?? getFileExtension(mimeType),
                  );
                  if (path != null) {
                    try {
                      await saveFile(path, content!);
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
              if (showLabel) const Text(kLabelDownload)
            ],
          ),
        ),
      ),
    );
  }
}

class RepoButton extends StatelessWidget {
  const RepoButton({
    super.key,
    this.text,
    this.icon,
  });

  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    var label = text ?? "GitHub";
    if (icon == null) {
      return FilledButton(
        onPressed: () {
          launchUrl(Uri.parse(kGitUrl));
        },
        child: Text(
          label,
          style: kTextStyleButton,
        ),
      );
    }
    return FilledButton.icon(
      onPressed: () {
        launchUrl(Uri.parse(kGitUrl));
      },
      icon: Icon(
        icon,
        size: 20.0,
      ),
      label: Text(
        label,
        style: kTextStyleButton,
      ),
    );
  }
}

class DiscordButton extends StatelessWidget {
  const DiscordButton({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    var label = text ?? 'Discord Server';
    return FilledButton.icon(
      onPressed: () {
        launchUrl(Uri.parse(kDiscordUrl));
      },
      icon: const Icon(
        Icons.discord,
        size: 20.0,
      ),
      label: Text(
        label,
        style: kTextStyleButton,
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.save,
        size: 20,
      ),
      label: const Text(
        kLabelSave,
        style: kTextStyleButton,
      ),
    );
  }
}
