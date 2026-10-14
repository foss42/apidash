import 'dart:async';

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class OverlayMenuItem<T> {
  const OverlayMenuItem({
    required this.value,
    required this.label,
    this.trailing,
    this.isDivider = false,
  });

  final T? value;
  final String label;
  final Widget? trailing;
  final bool isDivider;

  static OverlayMenuItem<T> divider<T>() => OverlayMenuItem<T>(
        value: null,
        label: '',
        isDivider: true,
      );
}

Future<T?> showAnchoredOverlayMenu<T>({
  required BuildContext context,
  required List<OverlayMenuItem<T>> items,
  double verticalOffset = 4,
  double minWidth = 200,
  double maxWidth = 320,
}) {
  final overlayState = Overlay.of(context, rootOverlay: true);
  final box = context.findRenderObject() as RenderBox?;
  final overlayBox =
      overlayState.context.findRenderObject() as RenderBox?;
  if (box == null || overlayBox == null || !box.hasSize) {
    return Future<T?>.value(null);
  }

  final anchor = Rect.fromPoints(
    box.localToGlobal(Offset.zero, ancestor: overlayBox),
    box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlayBox),
  );

  final completer = Completer<T?>();
  late OverlayEntry entry;

  void dismiss([T? value]) {
    if (completer.isCompleted) return;
    entry.remove();
    completer.complete(value);
  }

  final media = MediaQuery.sizeOf(context);
  final left = anchor.left.clamp(8.0, media.width - minWidth - 8.0);
  final top = (anchor.bottom + verticalOffset)
      .clamp(8.0, media.height - 48.0);

  entry = OverlayEntry(
    builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Stack(
        children: [
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => dismiss(),
            ),
          ),
          Positioned(
            left: left,
            top: top,
            child: Material(
              elevation: 8,
              color: cs.surface,
              shadowColor: cs.shadow,
              borderRadius: kBorderRadius8,
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: minWidth,
                  maxWidth: maxWidth,
                  maxHeight: media.height - top - 16,
                ),
                child: IntrinsicWidth(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final item in items)
                          if (item.isDivider)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: cs.outlineVariant,
                            )
                          else
                            InkWell(
                              onTap: () => dismiss(item.value),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(ctx)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    if (item.trailing != null) ...[
                                      const SizedBox(width: 8),
                                      item.trailing!,
                                    ],
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlayState.insert(entry);
  return completer.future;
}
