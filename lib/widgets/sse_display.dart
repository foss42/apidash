import 'dart:convert';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SSEDisplay extends ConsumerStatefulWidget {
  final List<String> sseOutput;
  const SSEDisplay({
    super.key,
    required this.sseOutput,
  });

  @override
  ConsumerState<SSEDisplay> createState() => _SSEDisplayState();
}

class _SSEDisplayState extends ConsumerState<SSEDisplay> {
  @override
  Widget build(BuildContext context) {
    final requestModel = ref.read(selectedRequestModelProvider);
    final aiRequestModel = requestModel?.aiRequestModel;
    final isAIOutput = (aiRequestModel != null);

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

    if (isAIOutput) {
      String out = "";
      for (String x in widget.sseOutput) {
        x = x.substring(6);
        out += aiRequestModel.model.provider.modelController
                .streamOutputFormatter(jsonDecode(x)) ??
            "<?>";
      }
      return SingleChildScrollView(
        child: Text(out),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (widget.sseOutput)
            .reversed
            .where((e) => e != '')
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
      ),
    );
  }
}
