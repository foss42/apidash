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
import 'package:mime/mime.dart';

/// Sniffs the first bytes of [bytes] using the `mime` package's built-in
/// magic-number database. Returns a (type, subtype) pair, or null if unknown.
(String, String)? _sniffMimeFromBytes(Uint8List bytes) {
  final mimeStr = lookupMimeType('', headerBytes: bytes);
  if (mimeStr == null) return null;
  final parts = mimeStr.split('/');
  if (parts.length != 2) return null;
  return (parts[0], parts[1]);
}

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

    // Sniff magic bytes when server reports a generic binary type.
    var type = widget.type;
    var subtype = widget.subtype;
    if (type == kTypeApplication && subtype == kSubTypeOctetStream) {
      final sniffed = _sniffMimeFromBytes(widget.bytes);
      if (sniffed != null) {
        type = sniffed.$1;
        subtype = sniffed.$2;
      }
    }

    if (type == kTypeApplication && subtype == kSubTypeJson) {
      try {
        var preview = JsonPreviewer(code: jsonDecode(widget.body));
        return preview;
      } catch (e) {
        // pass
      }
    }
    if (type == kTypeImage && subtype == kSubTypeSvg) {
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
    if (type == kTypeImage) {
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
    if (type == kTypeApplication && subtype == kSubTypePdf) {
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
    if (type == kTypeAudio) {
      return Uint8AudioPlayer(
        bytes: widget.bytes,
        type: type!,
        subtype: subtype!,
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
    if (type == kTypeText && subtype == kSubTypeCsv) {
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
    if (type == kTypeVideo) {
      try {
        var preview = VideoPreviewer(
          videoBytes: widget.bytes,
          videoFileExtension: getFileExtension(
            '$type/$subtype',
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
      "type": "$type/$subtype",
    });
    return ErrorMessage(message: errorText);
  }
}
