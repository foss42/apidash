import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:printing/printing.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';
import 'error_message.dart';
import 'uint8_audio_player.dart';
import 'json_previewer.dart';
import 'csv_previewer.dart';
import 'video_previewer.dart';
import '../consts.dart';

class Previewer extends StatefulWidget {
  const Previewer({
    super.key,
    required this.bytes,
    required this.body,
    this.type,
    this.subtype,
    this.hasRaw = false,
  });

  final Uint8List bytes;
  final String body;
  final String? type;
  final String? subtype;
  final bool hasRaw;

  @override
  State<Previewer> createState() => _PreviewerState();
}

class _PreviewerState extends State<Previewer> {
  @override
  Widget build(BuildContext context) {
    var errorTemplate = jj.Template(kMimeTypeRaiseIssue);
    if (widget.type == kTypeApplication && widget.subtype == kSubTypeJson) {
      try {
        var preview = JsonPreviewer(
          code: jsonDecode(widget.body),
        );
        return preview;
      } catch (e) {
        // pass
      }
    }
    if (widget.type == kTypeImage && widget.subtype == kSubTypeSvg) {
      final String rawSvg = widget.body;
      try {
        parseWithoutOptimizers(rawSvg);
        var svgImg = SvgPicture.string(
          rawSvg,
        );
        return svgImg;
      } catch (e) {
        return ErrorMessage(
          message: errorTemplate.render({
            "showRaw": true,
            "showContentType": false,
            "type": "svg",
          }),
        );
      }
    }
    if (widget.type == kTypeImage) {
      return Image.memory(
        widget.bytes,
        errorBuilder: (context, _, stackTrace) {
          return ErrorMessage(
            message: errorTemplate.render({
              "showRaw": false,
              "showContentType": false,
              "type": kTypeImage,
            }),
          );
        },
      );
    }
    if (widget.type == kTypeApplication && widget.subtype == kSubTypePdf) {
      return PdfPreview(
        build: (_) => widget.bytes,
        useActions: false,
        onError: (context, error) {
          return ErrorMessage(
            message: errorTemplate.render({
              "showRaw": false,
              "showContentType": false,
              "type": kSubTypePdf,
            }),
          );
        },
      );
    }
    if (widget.type == kTypeAudio) {
      return Uint8AudioPlayer(
        bytes: widget.bytes,
        type: widget.type!,
        subtype: widget.subtype!,
        errorBuilder: (context, error, stacktrace) {
          return ErrorMessage(
            message: errorTemplate.render({
              "showRaw": false,
              "showContentType": false,
              "type": kTypeAudio,
            }),
          );
        },
      );
    }
    if (widget.type == kTypeText && widget.subtype == kSubTypeCsv) {
      return CsvPreviewer(
        body: widget.body,
        errorWidget: ErrorMessage(
          message: errorTemplate.render({
            "showRaw": false,
            "showContentType": false,
            "type": kSubTypeCsv,
          }),
        ),
      );
    }
    if (widget.type == kTypeVideo) {
      try {
        var preview = VideoPreviewer(videoBytes: widget.bytes);
        return preview;
      } catch (e) {
        return ErrorMessage(
          message: errorTemplate.render({
            "showRaw": false,
            "showContentType": false,
            "type": kTypeVideo,
          }),
        );
      }
    }
    var errorText = errorTemplate.render({
      "showRaw": widget.hasRaw,
      "showContentType": true,
      "type": "${widget.type}/${widget.subtype}",
    });
    return ErrorMessage(
      message: errorText,
    );
  }
}
