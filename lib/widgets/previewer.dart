import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:printing/printing.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';
import 'error_message.dart';
import 'previewer_csv.dart';
import 'previewer_json.dart';
import 'previewer_video.dart';
import 'uint8_audio_player.dart';
import '../consts.dart';
import '../utils/file_utils.dart';
import '../utils/magic_bytes_utils.dart';

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
    var resolvedType = widget.type;
    var resolvedSubtype = widget.subtype;
    if (resolvedType == kTypeApplication &&
        resolvedSubtype == kSubTypeOctetStream) {
      final (detectedType, detectedSubtype) = detectMimeTypeFromBytes(widget.bytes);
      if (detectedType != kTypeApplication || detectedSubtype != kSubTypeOctetStream) {
        resolvedType = detectedType;
        resolvedSubtype = detectedSubtype;
      }
    }
    if (resolvedType == kTypeApplication && resolvedSubtype == kSubTypeJson) {
      try {
        var preview = JsonPreviewer(code: jsonDecode(widget.body));
        return preview;
      } catch (e) {
        // pass
      }
    }
    if (resolvedType == kTypeImage && resolvedSubtype == kSubTypeSvg) {
      final String rawSvg = widget.body;
      try {
        parseWithoutOptimizers(rawSvg);
        var svgImg = SvgPicture.string(rawSvg);
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
    if (resolvedType == kTypeImage) {
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
    if (resolvedType == kTypeApplication && resolvedSubtype == kSubTypePdf) {
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
    if (resolvedType == kTypeAudio) {
      return Uint8AudioPlayer(
        bytes: widget.bytes,
        type: resolvedType!,
        subtype: resolvedSubtype!,
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
    if (resolvedType == kTypeText && resolvedSubtype == kSubTypeCsv) {
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
    if (resolvedType == kTypeVideo) {
      try {
        var preview = VideoPreviewer(
          videoBytes: widget.bytes,
          videoFileExtension: getFileExtension(
            '$resolvedType/$resolvedSubtype',
          ),
        );
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
      "type": "$resolvedType/$resolvedSubtype",
    });
    return ErrorMessage(message: errorText);
  }
}
