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
        var preview = JsonPreviewer(code: jsonDecode(widget.body));
        return preview;
      } catch (e) {
        // pass
      }
    }
    if (widget.type == kTypeImage && widget.subtype == kSubTypeSvg) {
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
        var preview = VideoPreviewer(
          videoBytes: widget.bytes,
          videoFileExtension: getFileExtension(
            '${widget.type}/${widget.subtype}',
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
    // var errorText = errorTemplate.render({
    //   "showRaw": widget.hasRaw,
    //   "showContentType": true,
    //   "type": "${widget.type}/${widget.subtype}",
    // });
    // return ErrorMessage(message: errorText);
    
    //Adding magic bytes fallback feature
    
    if (widget.type ==kTypeApplication && widget.subtype ==kSubTypeOctetStream ||
        widget.type == null || widget.subtype==null){

      final b = widget.bytes;
      if (b.length>=4){

        //PNG 89 50 4E 47
        if (b[0]==0x89 && b[1]==0x50 && b[2]==0x4E && b[3]==0x47){
          return Image.memory(b);
        }
        // JPEG FF D8 FF 
        if(b[0]==0xFF && b[1]==0xD8 && b[2]==0xFF){
          return Image.memory(b);
        }

        //GIF 47 49 46 38 

        if (b[0]==0x47 && b[1]==0x49 && b[2]==0x46 && b[3]==0x38){
          return Image.memory(b);
        }
        // BMP 42 40 BMP
        if (b[0]==0x42 && b[1]==0x4D){
          return Image.memory(b);
        }

        // WebP 52 49 46 46 57 45 42 50
        
        if (b.length>= 12 &&
        b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46 &&
        b[8] == 0x57 && b[9] == 0x45 && b[10] == 0x42 && b[11] == 0x50){
          return Image.memory(b);
        }

    //PDF 25 50 44 46 
    if(b[0]==0x25 && b[1]==0x50 && b[2]==0x44 && b[3]==0x46){
      return PdfPreview(build:(_) =>b, useActions: false);
    }

    // MP3 49 44 33
    if(b.length >= 3 && b[0]==0x49 && b[1]==0x44 && b[2]==0x33){
      return Uint8AudioPlayer(
        bytes: b,
        type: kTypeAudio,
        subtype: 'mpeg',
        errorBuilder: (context, error, stacktrace)=> ErrorMessage(message:errorTemplate.render({
          "showRaw": false,
          "showContentType": false,
          "type": kTypeAudio,
        }),
        ),
      );
    }

    //video 66 74 99 70
    if (b.length >= 8 &&
          b[4] == 0x66 && b[5] == 0x74 && b[6] == 0x79 && b[7] == 0x70){
      return VideoPreviewer(videoBytes: b, videoFileExtension: 'mp4'); 
    }

    if (b[0] == 0x1A && b[1] == 0x45 && b[2] == 0xDF && b[3] == 0xA3){
      return VideoPreviewer(videoBytes: b, videoFileExtension: 'webm'); 
    }

    // SVG
    final prefix = String.fromCharCodes(b.take(200));
    if (prefix.contains('<svg') || prefix.contains('<?xml')){
      return SvgPicture.string(widget.body);
    }
      }
    }
    return ErrorMessage(
      message: errorTemplate.render({
        "showRaw": widget.hasRaw,
        "showContentType": true,
        "type": "${widget.type}/${widget.subtype}",
      }),
    );
  }
}