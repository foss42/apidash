import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class RequestEditorDefault extends ConsumerWidget {
  const RequestEditorDefault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Icon(
              Icons.rocket_launch_outlined,
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
            SizedBox(height: 24*ds.scaleFactor),

            // Main heading
            Text(
              'Get Started with API Dash',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12*ds.scaleFactor),

            // Subtitle
            Text(
              'Create your first API request to begin testing',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32*ds.scaleFactor),

            // Primary action button
            ElevatedButton(
              onPressed: () {
                ref.read(collectionStateNotifierProvider.notifier).add();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: Text(
                kLabelPlusNew,
                style: kTextStyleButton(ds.scaleFactor),
              ),
            ),
            SizedBox(height: 40*ds.scaleFactor),

            // Quick tips section
            Container(
              constraints: BoxConstraints(maxWidth: 500*ds.scaleFactor),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 8*ds.scaleFactor),
                      Text(
                        'Quick Tips',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16*ds.scaleFactor),
                  _buildTipItem(
                    context,
                    icon: Icons.add_circle_outline,
                    text: 'Click "+ New" to create a new API request',
                  ),
                  SizedBox(height: 12*ds.scaleFactor),
                  _buildTipItem(
                    context,
                    icon: Icons.folder_outlined,
                    text: 'Organize requests into collections',
                  ),
                  SizedBox(height: 12*ds.scaleFactor),
                  _buildTipItem(
                    context,
                    icon: Icons.upload_file_outlined,
                    text:
                        'Import existing collections from Postman or Insomnia',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final ds = DesignSystemProvider.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: colorScheme.primary.withValues(alpha: 0.8),
        ),
        SizedBox(width: 12*ds.scaleFactor),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
