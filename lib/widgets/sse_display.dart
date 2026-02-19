import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';

class SSEDisplay extends StatelessWidget {
  final AIRequestModel? aiRequestModel;
  final List<String>? sseOutput;
  const SSEDisplay({
    super.key,
    this.sseOutput,
    this.aiRequestModel,
  });

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    final theme = Theme.of(context);
    final fontSizeMedium = theme.textTheme.bodyMedium?.fontSize?? 14 * ds.scaleFactor;
    final isDark = theme.brightness == Brightness.dark;
    if (sseOutput == null || sseOutput!.isEmpty) {
      return Text(
        'No content',
        style: kCodeStyle.copyWith(
          fontSize: fontSizeMedium*ds.scaleFactor,
          color: isDark ? kColorDarkDanger : kColorLightDanger,
        ),
      );
    }

    if (aiRequestModel != null) {
      // For RAW Text output (only AI Requests)
      String out = "";
      for (String x in sseOutput!) {
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
          final z = aiRequestModel?.getFormattedStreamOutput(dec!);
          out += z ?? '<?>';
        } catch (e) {
          debugPrint("SSEDisplay -> Error in JSONDEC $e");
        }
      }
      return SingleChildScrollView(
        child: Text(out),
      );
    }

    return ListView(
      padding: kP1,
      children:
          sseOutput!.reversed.where((e) => e.trim() != '').map<Widget>((chunk) {
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
                                fontSize: fontSizeMedium*ds.scaleFactor,
                                color: isDark ? kColorGQL.toDark : kColorGQL,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4*ds.scaleFactor),
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
                      fontSize: fontSizeMedium*ds.scaleFactor,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
