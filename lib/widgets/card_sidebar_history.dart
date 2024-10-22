import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'texts.dart' show MethodBox;

class SidebarHistoryCard extends StatelessWidget {
  const SidebarHistoryCard({
    super.key,
    required this.id,
    required this.models,
    required this.method,
    this.isSelected = false,
    this.requestGroupSize = 1,
    this.onTap,
  });

  final String id;
  final List<HistoryMetaModel> models;
  final HTTPVerb method;
  final bool isSelected;
  final int requestGroupSize;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surface;
    final Color colorVariant =
        Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5);
    final model = models.first;
    final Color surfaceTint = Theme.of(context).colorScheme.primary;
    final String name = getHistoryRequestName(model);
    return Tooltip(
      message: name,
      triggerMode: TooltipTriggerMode.manual,
      waitDuration: const Duration(seconds: 1),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: kBorderRadius8,
        ),
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
          borderRadius: kBorderRadius8,
          hoverColor: colorVariant,
          focusColor: colorVariant.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 6,
              right: 6,
              top: 5,
              bottom: 5,
            ),
            child: SizedBox(
              height: 20,
              child: Row(
                children: [
                  MethodBox(method: method),
                  kHSpacer4,
                  Expanded(
                    child: Text(
                      name,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  requestGroupSize > 1 ? kHSpacer4 : const SizedBox.shrink(),
                  Visibility(
                    visible: requestGroupSize > 1,
                    child: Container(
                      padding: kPh4,
                      constraints: const BoxConstraints(minWidth: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: kBorderRadius6,
                      ),
                      child: Center(
                        child: Text(
                            requestGroupSize > 9
                                ? "9+"
                                : requestGroupSize.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
