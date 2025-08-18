import 'dart:convert';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:genai/genai.dart';

class SSEDisplay extends StatefulWidget {
  final LLMModel? selectedLLModel;
  final List<String> sseOutput;
  const SSEDisplay({
    super.key,
    required this.sseOutput,
    this.selectedLLModel,
  });

  @override
  State<SSEDisplay> createState() => _SSEDisplayState();
}

class _SSEDisplayState extends State<SSEDisplay> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSizeMedium = theme.textTheme.bodyMedium?.fontSize;
    final isDark = theme.brightness == Brightness.dark;
    if (widget.sseOutput.isEmpty) {
      return Text(
        'No content',
        style: kCodeStyle.copyWith(
          fontSize: fontSizeMedium,
          color: isDark ? kColorDarkDanger : kColorLightDanger,
        ),
      );
    }

    if (widget.selectedLLModel != null) {
      // For RAW Text output (only AI Requests)
      String out = "";
      final mc = widget.selectedLLModel!.provider.modelController;
      for (String x in widget.sseOutput) {
        x = x.trim();
        if (x.isEmpty || x.contains('[DONE]')) {
          continue;
        }

        // Start with JSON
        final pos = x.indexOf('{');
        if (pos == -1) continue;
        x = x.substring(pos);

        Map? dec;
        try {
          dec = jsonDecode(x);
          final z = mc.streamOutputFormatter(dec!);
          out += z ?? '<?>';
        } catch (e) {
          print("Error in JSONDEC $e");
        }
      }
      return SingleChildScrollView(
        child: Text(out),
      );
    }

    return ListView(
      padding: kP1,
      children: widget.sseOutput.reversed
          .where((e) => e.trim() != '')
          .map<Widget>((chunk) {
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
