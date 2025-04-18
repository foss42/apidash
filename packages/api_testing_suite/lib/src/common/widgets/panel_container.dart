import 'package:flutter/material.dart';

/// A reusable panel container with a title and consistent styling
class PanelContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final double? width;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<Widget>? actions;
  final bool collapsible;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const PanelContainer({
    super.key,
    required this.title,
    required this.child,
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.actions,
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    if (collapsible) {
      return _buildCollapsiblePanel(context);
    }
    return _buildFixedPanel(context);
  }

  Widget _buildFixedPanel(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF212121),
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : const Border(
                left: BorderSide(color: Color(0xFF333333)),
                right: BorderSide(color: Color(0xFF333333)),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(12.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsiblePanel(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF212121),
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : const Border(
                left: BorderSide(color: Color(0xFF333333)),
                right: BorderSide(color: Color(0xFF333333)),
              ),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: initiallyExpanded,
        collapsedBackgroundColor: const Color(0xFF272727),
        backgroundColor: const Color(0xFF272727),
        childrenPadding: padding ?? const EdgeInsets.all(12.0),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (actions != null) ...actions!,
            const Icon(Icons.expand_more, color: Colors.white54),
          ],
        ),
        children: [child],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF272727),
        border: Border(bottom: BorderSide(color: Color(0xFF333333))),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
