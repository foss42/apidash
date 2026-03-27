import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'openresponses_structured_viewer.dart';

class SSEDisplay extends StatefulWidget {
  final AIRequestModel? aiRequestModel;
  final List<String>? sseOutput;
  const SSEDisplay({
    super.key,
    this.sseOutput,
    this.aiRequestModel,
  });

  @override
  State<SSEDisplay> createState() => _SSEDisplayState();
}

class _SSEDisplayState extends State<SSEDisplay> {
  final List<Map<String, dynamic>> streamingOutput = [];
  String out = '';
  int processedChunks = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSizeMedium = theme.textTheme.bodyMedium?.fontSize;
    final isDark = theme.brightness == Brightness.dark;
    if (widget.sseOutput == null || widget.sseOutput!.isEmpty) {
      return Text(
        'No content',
        style: kCodeStyle.copyWith(
          fontSize: fontSizeMedium,
          color: isDark ? kColorDarkDanger : kColorLightDanger,
        ),
      );
    }

    if (widget.aiRequestModel != null) {
      // For AI streaming: try to surface OpenResponses items live.
      // Only process new chunks since the last build.
      final chunks = widget.sseOutput!;
      for (var i = processedChunks; i < chunks.length; i++) {
        var x = chunks[i];
        x = x.trim();
        if (x.isEmpty || x.contains('[DONE]')) {
          continue;
        }

        // Start with JSON (skip any SSE prefix before '{')
        final pos = x.indexOf('{');
        if (pos == -1) continue;
        final jsonStr = x.substring(pos);

        Map<String, dynamic>? dec;
        try {
          final raw = jsonDecode(jsonStr);
          if (raw is Map<String, dynamic>) {
            dec = raw;
          }
        } catch (e) {
          debugPrint("SSEDisplay -> Error in JSONDEC $e");
        }

        if (dec != null) {
          // Existing AI streaming formatting for raw text.
          final z = widget.aiRequestModel?.getFormattedStreamOutput(dec);
          out += z ?? '';

          // Detect OpenResponses streaming items.
          // 1) Full OpenResponses response with `output` array.
          final output = dec['output'];
          if (output is List) {
            for (final item in output) {
              if (item is Map && item['type'] != null) {
                streamingOutput.add(
                  item.cast<String, dynamic>(),
                );
              }
            }
          }

          // 2) Streaming event carrying a single item (e.g. response.output_item.added).
          final eventItem = dec['item'];
          if (eventItem is Map && eventItem['type'] != null) {
            streamingOutput.add(
              eventItem.cast<String, dynamic>(),
            );
          }
        }
      }
      processedChunks = chunks.length;

      if (streamingOutput.isNotEmpty) {
        // Render current OpenResponses items using the existing structured viewer.
        return OpenResponsesStructuredViewer(
          root: <String, dynamic>{'output': streamingOutput},
        );
      }

      // Fallback: existing raw text streaming view.
      return SingleChildScrollView(
        child: Text(out),
      );
    }

    return ListView(
      padding: kP1,
      children:
          widget.sseOutput!.reversed.where((e) => e.trim() != '').map<Widget>((chunk) {
        Map<String, dynamic>? parsedJson;
        try {
          parsedJson = jsonDecode(chunk);
        } catch (_) {}

        return Card(
          color: theme.colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius6,
          ),
          child: Padding(
            padding: kP8,
            child: parsedJson != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: parsedJson.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: kCodeStyle.copyWith(
                                fontSize: fontSizeMedium,
                                color: isDark ? kColorGQL.toDark : kColorGQL,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                entry.value.toString(),
                                style: kCodeStyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : Text(
                    chunk.toString().trim(),
                    style: kCodeStyle.copyWith(
                      fontSize: fontSizeMedium,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
