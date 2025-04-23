import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiUrlCard extends StatelessWidget {
  const ApiUrlCard({
    super.key,
    required this.endpoint,
    this.isSelected = false,
    this.onTap,
  });

  final ApiEndpoint endpoint;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = endpoint.name.isNotEmpty 
        ? endpoint.name 
        : endpoint.path;

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
                    method: endpoint.method,
                  ),
                  kHSpacer4,
                  Expanded(
                    child: Text(
                      displayName,
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