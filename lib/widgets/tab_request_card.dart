import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/texts.dart';

class TabRequestCard extends StatefulWidget {
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
  State<TabRequestCard> createState() => _TabRequestCardState();
}

class _TabRequestCardState extends State<TabRequestCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.isSelected ? 1 : 0,
      shape: const RoundedRectangleBorder(borderRadius: kBorderRadius8),
      margin: const EdgeInsets.only(right: 4),
      child: Stack(
        children: [
          // MouseRegion to detect hover state
          MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: kBorderRadius8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SidebarRequestCardTextBox(apiType: widget.apiType, method: widget.method),
                    kHSpacer8,
                    Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    kHSpacer8,
                    // Show close button only when hovering
                    if (_isHovering)
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    // Add space even when close button is not visible
                    if (!_isHovering)
                      const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
          if (widget.isSelected) // Adds a visual indicator for the selected tab as mentioned in wireframe
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