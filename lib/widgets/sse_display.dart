import 'dart:convert';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class SSEDisplay extends StatefulWidget {
  final String sseOutput;
  const SSEDisplay({super.key, required this.sseOutput});

  @override
  State<SSEDisplay> createState() => _SSEDisplayState();
}

class _SSEDisplayState extends State<SSEDisplay> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSizeMedium = theme.textTheme.bodyMedium?.fontSize;
    final isDark = theme.brightness == Brightness.dark;
    List<dynamic> sse;
    try {
      sse = jsonDecode(widget.sseOutput);
    } catch (e) {
      return Text(
        'Invalid SSE output',
        style: kCodeStyle.copyWith(
          fontSize: fontSizeMedium,
          color: isDark ? kColorDarkDanger : kColorLightDanger,
        ),
      );
    }

    return ListView(
      padding: kP1,
      children: sse.reversed.where((e) => e != '').map<Widget>((chunk) {
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
