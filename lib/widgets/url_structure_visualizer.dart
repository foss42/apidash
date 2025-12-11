import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class URLStructureVisualizer extends StatelessWidget {
  const URLStructureVisualizer({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    final parsedUrl = _parseUrl(url);
    
    if (parsedUrl == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: kP12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerLow,
            colorScheme.surface,
          ],
        ),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: kBorderRadius12,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: kBorderRadius8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 16,
                  color: colorScheme.onPrimaryContainer,
                ),
                kHSpacer5,
                Text(
                  'URL STRUCTURE BREAKDOWN',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
          ),
          kVSpacer10,
          _buildUrlPart(
            context,
            'Protocol',
            parsedUrl.scheme.toUpperCase(),
            Icons.https,
            isDark ? Colors.green.shade300 : Colors.green.shade700,
          ),
          if (parsedUrl.host.isNotEmpty)
            _buildUrlPart(
              context,
              'Host',
              parsedUrl.host,
              Icons.language,
              isDark ? Colors.blue.shade300 : Colors.blue.shade700,
            ),
          if (parsedUrl.hasPort)
            _buildUrlPart(
              context,
              'Port',
              parsedUrl.port.toString(),
              Icons.router,
              isDark ? Colors.orange.shade300 : Colors.orange.shade700,
            ),
          if (parsedUrl.path.isNotEmpty && parsedUrl.path != '/')
            _buildUrlPart(
              context,
              'Path',
              parsedUrl.path,
              Icons.alt_route,
              isDark ? Colors.purple.shade300 : Colors.purple.shade700,
            ),
          if (parsedUrl.queryParameters.isNotEmpty)
            _buildQueryParams(context, parsedUrl.queryParameters),
        ],
      ),
    );
  }

  Widget _buildUrlPart(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: kBorderRadius8,
          border: Border.all(
            color: accentColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 16,
                color: accentColor,
              ),
            ),
            kHSpacer10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SelectableText(
                      value,
                      style: kCodeStyle.copyWith(
                        fontSize: 12,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryParams(
    BuildContext context,
    Map<String, String> queryParams,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? Colors.cyan.shade300 : Colors.cyan.shade700;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: kBorderRadius8,
          border: Border.all(
            color: accentColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.tune,
                    size: 16,
                    color: accentColor,
                  ),
                ),
                kHSpacer10,
                Text(
                  'QUERY PARAMETERS (${queryParams.length})',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...queryParams.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withOpacity(0.8),
                              accentColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          entry.key,
                          style: kCodeStyle.copyWith(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      kHSpacer10,
                      Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      kHSpacer10,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: SelectableText(
                            entry.value,
                            style: kCodeStyle.copyWith(
                              fontSize: 11,
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Uri? _parseUrl(String urlString) {
    if (urlString.isEmpty) return null;
    
    try {
      return Uri.parse(urlString);
    } catch (e) {
      return null;
    }
  }
}
