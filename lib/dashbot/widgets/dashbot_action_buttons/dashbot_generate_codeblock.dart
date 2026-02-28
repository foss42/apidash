import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../../models/models.dart';
import '../dashbot_action.dart';

class DashbotGeneratedCodeBlock extends StatefulWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotGeneratedCodeBlock({super.key, required this.action});

  @override
  State<DashbotGeneratedCodeBlock> createState() =>
      _DashbotGeneratedCodeBlockState();
}

class _DashbotGeneratedCodeBlockState extends State<DashbotGeneratedCodeBlock> {
  bool _isCopied = false;

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    setState(() {
      _isCopied = true;
    });

    // Reset the icon back to copy after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final code =
        (widget.action.value is String) ? widget.action.value as String : '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeTheme = isDark ? kDarkCodeTheme : kLightCodeTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: codeTheme['root']?.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: code.isNotEmpty ? () => _copyCode(code) : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Text(
                code.isEmpty ? '// No code returned' : code,
                style: kCodeStyle.copyWith(
                  fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                  color: codeTheme['root']?.color ??
                      Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          if (code.isNotEmpty)
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: ADIconButton(
                  key: ValueKey(_isCopied),
                  icon: _isCopied ? Icons.check : Icons.content_copy,
                  iconSize: 16,
                  tooltip: _isCopied ? 'Copied!' : 'Copy',
                  color: _isCopied
                      ? Theme.of(context).colorScheme.primary
                      : (codeTheme['root']?.color ??
                              Theme.of(context).colorScheme.onSurface)
                          .withValues(alpha: 0.6),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _copyCode(code),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
