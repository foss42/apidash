import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class Previewer extends StatefulWidget {
  const Previewer(
      {super.key,
      required this.bytes,
      required this.type,
      required this.subtype});

  final Uint8List bytes;
  final String type;
  final String subtype;
  @override
  State<Previewer> createState() => _PreviewerState();
}

class _PreviewerState extends State<Previewer> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == kTypeApplication && widget.subtype == kSubTypePdf) {
      return const SelectableText("PDF viewing $kMimeTypeRaiseIssue");
    }
    if (widget.type == kTypeImage) {
      return Image.memory(
        widget.bytes,
        errorBuilder: (context, _, stackTrace) {
          return SelectableText(
              "${widget.type}/${widget.subtype} mimetype preview $kMimeTypeRaiseIssue");
        },
      );
    }
    if (widget.type == kTypeAudio) {
      return const SelectableText("Audio playing $kMimeTypeRaiseIssue");
    }
    if (widget.type == kTypeVideo) {
      return const SelectableText("Video playing $kMimeTypeRaiseIssue");
    }
    return SelectableText(
        "${widget.type}/${widget.subtype} mimetype preview $kMimeTypeRaiseIssue");
  }
}
