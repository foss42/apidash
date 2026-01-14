import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class RequestEditorDefault extends ConsumerWidget {
  const RequestEditorDefault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              Icons.api_rounded,
              size: 64,
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              kMsgEmptyRequestEditorTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              kMsgEmptyRequestEditorSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Primary Action Button
            ElevatedButton.icon(
              onPressed: () {
                ref.read(collectionStateNotifierProvider.notifier).add();
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                kLabelNewRequest,
                style: kTextStyleButton,
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Keyboard Shortcut Hint
            if (kIsMacOS || kIsWindows)
              Text(
                kIsMacOS ? kMsgKeyboardShortcut : "Press Ctrl+N to create new",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
