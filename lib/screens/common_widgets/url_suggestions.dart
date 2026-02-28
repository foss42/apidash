import 'package:apidash/consts.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/providers/url_history_provider.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class URLSuggestions extends ConsumerWidget {
  final String query;
  final void Function(String, String) onSuggestionTap;

  const URLSuggestions({
    super.key,
    required this.query,
    required this.onSuggestionTap,
  });

  List<Map<String, dynamic>> _getFilteredUrls(
      List<Map<String, dynamic>> urlHistory,
      Map<String?, List<EnvironmentVariableModel>> envMap) {
    urlHistory = urlHistory.where((urlObj) {
      final resolved = urlObj[kUrlHistoryKeyResolved] as String? ?? '';
      return resolved.isNotEmpty;
    }).toList();

    if (query.isEmpty) {
      return urlHistory.take(7).toList();
    }

    return urlHistory
        .where((urlObj) {
          final resolved = urlObj[kUrlHistoryKeyResolved] as String? ?? '';
          final raw = urlObj[kUrlHistoryKeyRaw] as String? ?? '';
          return resolved.toLowerCase().contains(query.toLowerCase()) ||
              raw.toLowerCase().contains(query.toLowerCase());
        })
        .take(7)
        .toList();
  }

  // check if env variable in raw url missimng or not
  bool _missingVariables(String? raw, String resolved,
      Map<String?, List<EnvironmentVariableModel>> envMap) {
    if (raw == null || raw.isEmpty) {
      return false;
    }

    if (!raw.contains('{{') || !raw.contains('}}')) {
      return false;
    }

    final regex = RegExp(r'\{\{([^}]+)\}\}');
    final matches = regex.allMatches(raw);

    final combinedEnvVarMap = <String, String>{};
    for (var varList in envMap.values) {
      for (var variable in varList) {
        combinedEnvVarMap[variable.key] = variable.value;
      }
    }

    for (var match in matches) {
      final varName = match.group(1)?.trim() ?? '';
      if (!combinedEnvVarMap.containsKey(varName)) {
        return true;
      }
    }

    return false;
  }

  String _getSubtitleText(
      String? raw, String resolved, bool hasUnresolvedVars) {
    if (raw == null || raw.isEmpty) {
      return 'Variable - Not available';
    }

    if (!raw.contains('{{') || !raw.contains('}}')) {
      return 'Variable - Not available';
    }

    if (hasUnresolvedVars) {
      return 'Variable - Missing';
    }

    return 'Variable - $raw';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  use env variable provider
    final envMap = ref.watch(availableEnvironmentVariablesStateProvider);

    List<Map<String, dynamic>> urlHistory = ref.watch(urlHistoryProvider);
    final suggestions = _getFilteredUrls(urlHistory, envMap);

    if (suggestions.isEmpty) {
      return Material(
        elevation: 6,
        borderRadius: kBorderRadius8,
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Text(
            'No URL',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  fontFamily: kFontFamily,
                ),
          ),
        ),
      );
    }

    return SuggestionsMenuBox(
      maxHeight: kSuggestionsMenuMaxHeight,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Theme.of(context).dividerColor),
        itemBuilder: (context, index) {
          final urlObj = suggestions[index];

          final raw = urlObj[kUrlHistoryKeyRaw] as String?;
          final resolved = urlObj[kUrlHistoryKeyResolved] as String? ?? '';
          final method = urlObj['method'] as String? ?? 'GET';

          final hasVariables =
              raw != null && raw.contains('{{') && raw.contains('}}');
          final hasUnresolvedVariables =
              _missingVariables(raw, resolved, envMap);

          final displayUrl = hasUnresolvedVariables
              ? resolved
              : (hasVariables ? raw : resolved);

          final subtitleText =
              _getSubtitleText(raw, resolved, hasUnresolvedVariables);

          return InkWell(
            onTap: () {
              onSuggestionTap(displayUrl, method);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: kP4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: kBorderRadius4,
                    ),
                    child: Padding(
                      padding: kP4,
                      child: Text(
                        method.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontFamily: kFontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resolved,
                          style: kCodeStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Opacity(
                          opacity: hasUnresolvedVariables
                              ? 0.8
                              : (hasVariables ? 1.0 : 0.8),
                          child: Text(
                            subtitleText,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant,
                                      fontFamily: kFontFamily,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
