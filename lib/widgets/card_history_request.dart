import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'texts.dart';

class HistoryRequestCard extends StatelessWidget {
  const HistoryRequestCard({
    super.key,
    required this.id,
    required this.model,
    this.isSelected = false,
    this.onTap,
  });

  final String id;
  final HistoryMetaModel model;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surface;
    final Color colorVariant = Theme.of(context).colorScheme.surfaceContainer;
    final Color surfaceTint = Theme.of(context).colorScheme.primary;
    return Card(
      shape: const ContinuousRectangleBorder(borderRadius: kBorderRadius12),
      elevation: isSelected ? 1 : 0,
      surfaceTintColor: isSelected ? surfaceTint : null,
      color: isSelected
          ? Theme.of(context).colorScheme.brightness == Brightness.dark
              ? colorVariant
              : color
          : color,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: kBorderRadius6,
        hoverColor: colorVariant,
        child: Padding(
          padding: kPv6 + kPh8,
          child: SizedBox(
            height: 20,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    humanizeTime(model.timeStamp),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: kCodeStyle,
                  ),
                ),
                kHSpacer4,
                StatusCode(statusCode: model.responseStatus),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
