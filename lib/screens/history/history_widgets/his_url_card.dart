import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'his_action_buttons.dart';

class HistoryURLCard extends StatelessWidget {
  const HistoryURLCard({
    super.key,
    required this.historyRequestModel,
  });

  final HistoryRequestModel? historyRequestModel;

  @override
  Widget build(BuildContext context) {
    final method = historyRequestModel?.metaData.method;
    final url = historyRequestModel?.metaData.url;
    final fontSize = Theme.of(context).textTheme.titleMedium?.fontSize;

    return LayoutBuilder(builder: (context, constraints) {
      final isCompact = constraints.maxWidth <= kMinWindowSize.width;
      final isExpanded = constraints.maxWidth >= kMediumWindowWidth - 8;
      return Card(
        color: kColorTransparent,
        surfaceTintColor: kColorTransparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          borderRadius: kBorderRadius8,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: isCompact ? 10 : 16,
          ),
          child: Row(
            children: [
              isCompact ? const SizedBox.shrink() : kHSpacer10,
              Text(
                method!.name.toUpperCase(),
                style: kCodeStyle.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: getHTTPMethodColor(
                    method,
                    brightness: Theme.of(context).brightness,
                  ),
                ),
              ),
              isCompact ? kHSpacer10 : kHSpacer20,
              Expanded(
                child: ReadOnlyTextField(
                  initialValue: url,
                  style: kCodeStyle.copyWith(
                    fontSize: fontSize,
                  ),
                ),
              ),
              isExpanded
                  ? HistoryActionButtons(
                      historyRequestModel: historyRequestModel,
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      );
    });
  }
}
