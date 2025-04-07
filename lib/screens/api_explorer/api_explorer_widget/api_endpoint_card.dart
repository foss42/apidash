import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';

class ApiUrlCard extends StatelessWidget {
  const ApiUrlCard({
    super.key,
    required this.apiEndpoint,
    this.isSelected = false,
    this.onTap,
  });

  final Map<String, dynamic> apiEndpoint;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final method = (apiEndpoint['method'] as String? ?? 'get').toUpperCase();
    final colorScheme = Theme.of(context).colorScheme;
    final apiName = (apiEndpoint['name'] as String? ?? apiEndpoint['path']).toUpperCase();
    final HTTPVerb methodEnum = HTTPVerb.values.firstWhere(
      (e) => e.name.toUpperCase() == method,
      orElse: () => HTTPVerb.get,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Material(
        borderRadius: kBorderRadius8,
        color: isSelected
            ? colorScheme.brightness == Brightness.dark
                ? colorScheme.surfaceContainer
                : colorScheme.surface
            : colorScheme.surface,
        child: InkWell(
          borderRadius: kBorderRadius8,
          hoverColor: colorScheme.surfaceContainer,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  SidebarRequestCardTextBox(
                    apiType: APIType.rest,
                    method: methodEnum,
                  ),
                  kHSpacer4,
                  Expanded(
                    child: Text(
                      apiName,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected 
                            ? colorScheme.primary 
                            : colorScheme.onSurface,
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