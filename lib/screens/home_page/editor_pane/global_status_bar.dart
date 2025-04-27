import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class GlobalStatusBar extends ConsumerStatefulWidget {
  const GlobalStatusBar({super.key});

  @override
  ConsumerState<GlobalStatusBar> createState() => _GlobalStatusBarState();
}

class _GlobalStatusBarState extends ConsumerState<GlobalStatusBar> {
  bool _isExpanded = false;
  List<String> _cachedLines = [];
  String _lastMessage = '';

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(statusMessageProvider.select((s) => s.message));
    final type = ref.watch(statusMessageProvider.select((s) => s.type));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    _cachedLines = message != _lastMessage ? message.split('\n') : _cachedLines;
    _lastMessage = message;
    final needsExpansion = _cachedLines.length > 1;

    final color = switch (type) {
      StatusMessageType.info => kColorSchemeSeed,
      StatusMessageType.warning => kColorHttpMethodPut,
      StatusMessageType.error => kColorDarkDanger,
      _ => isDarkMode ? Colors.white : kColorBlack,
    };

    final icon = switch (type) {
      StatusMessageType.error => Icons.error_outline,
      StatusMessageType.warning => Icons.warning_amber_outlined,
      StatusMessageType.info => Icons.info_outline,
      _ => null,
    };

    return Container(
      width: double.infinity,
      color: icon != null
          ? color.withOpacity(kForegroundOpacity)
          : isDarkMode
              ? Theme.of(context).colorScheme.surface
              : kColorWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: kPh12,
            height: kStatusBarHeight,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: kButtonIconSizeSmall, color: color),
                  kHSpacer8,
                ],
                Expanded(
                  child: Text(
                    _cachedLines.isNotEmpty ? _cachedLines.first : '',
                    style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (needsExpansion)
                  InkWell(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    customBorder: const CircleBorder(),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 24,
                      color: color,
                    ),
                  ),
              ],
            ),
          ),
          if (_isExpanded && needsExpansion)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 12 + (icon != null ? 32 : 0),
                right: 12,
                bottom: 8,
              ),
              child: Text(
                _cachedLines.skip(1).join('\n'),
                style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
}