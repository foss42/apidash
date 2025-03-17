
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/texts.dart';

class TabRequestCard extends StatelessWidget {
  const TabRequestCard({
    super.key,
    required this.apiType,
    required this.method,
    required this.name,
    required this.isSelected,
    this.onTap,
    this.onClose,
  });

  final APIType apiType;
  final HTTPVerb method;
  final String name;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 1 : 0,
      shape: const RoundedRectangleBorder(
        borderRadius: kBorderRadius8, 
      ),
      margin: const EdgeInsets.only(right: 4),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: kBorderRadius8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SidebarRequestCardTextBox(
                    apiType: apiType,
                    method: method,
                  ),
                  kHSpacer8,
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  kHSpacer8,
                  GestureDetector(
                    onTap: onClose,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 2, 
                color: Theme.of(context).colorScheme.primary, 
              ),
            ),
        ],
      ),
    );
  }
}