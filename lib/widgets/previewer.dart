import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';
import 'error_message.dart';
import 'uint8_audio_player.dart';
import 'json_previewer.dart';
import 'csv_previewer.dart';
import '../consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
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
        return ErrorMessage(message: l10n!.kSvgError);
      }
    }
    if (widget.type == kTypeImage) {
      return Image.memory(
        widget.bytes,
        errorBuilder: (context, _, stackTrace) {
          return ErrorMessage(message: l10n!.kImageError);
        },
      );
    }
    if (widget.type == kTypeApplication && widget.subtype == kSubTypePdf) {
      return PdfPreview(
        build: (_) => widget.bytes,
        useActions: false,
        onError: (context, error) {
          return ErrorMessage(message: l10n!.kPdfError);
        },
      );
    }
    if (widget.type == kTypeAudio) {
      return Uint8AudioPlayer(
        bytes: widget.bytes,
        type: widget.type!,
        subtype: widget.subtype!,
        errorBuilder: (context, error, stacktrace) {
          return ErrorMessage(message: l10n!.kAudioError);
        },
      );
    }
    if (widget.type == kTypeText && widget.subtype == kSubTypeCsv) {
      return CsvPreviewer(body: widget.body);
    }
    if (widget.type == kTypeVideo) {
      // TODO: Video Player
    }
    String message = widget.hasRaw
        ? "${l10n!.kMimeTypeRawRaiseIssueStart}${widget.type}/${widget.subtype}${l10n.kMimeTypeRaiseIssue}"
        : "${l10n!.kMimeTypeRaiseIssueStart}${widget.type}/${widget.subtype}${l10n.kMimeTypeRaiseIssue}";
    return ErrorMessage(message: message);
  }
}
