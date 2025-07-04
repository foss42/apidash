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
    List<dynamic> sse;
    try {
      sse = jsonDecode(widget.sseOutput);
    } catch (e) {
      return Text(
        'Invalid SSE output',
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sse.reversed.where((e) => e != '').map<Widget>((chunk) {
          Map<String, dynamic>? parsedJson;
          try {
            parsedJson = jsonDecode(chunk);
          } catch (_) {}

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kColorGQL,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  : Text(
                      chunk.toString().trim(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
