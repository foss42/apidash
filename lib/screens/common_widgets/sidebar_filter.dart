import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class SidebarFilter extends StatefulWidget {
  const SidebarFilter({
    super.key,
    this.onFilterFieldChanged,
    this.filterHintText,
  });

  final Function(String)? onFilterFieldChanged;
  final String? filterHintText;

  @override
  State<SidebarFilter> createState() => _SidebarFilterState();
}

class _SidebarFilterState extends State<SidebarFilter> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: kBorderRadius8,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Row(
        children: [
          kHSpacer5,
          Icon(
            Icons.filter_alt,
            size: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
          kHSpacer5,
          Expanded(
            child: ADRawTextField(
              controller: _controller,
              style: Theme.of(context).textTheme.bodyMedium,
              hintText: widget.filterHintText ?? "Filter by name",
              onChanged: widget.onFilterFieldChanged,
            ),
          ),
        ],
      ),
    );
  }
}
