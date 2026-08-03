import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/ai_provider_utils.dart';
import 'package:apidash/widgets/anchored_overlay_menu.dart';

/// Compact dropdown of configured models + Add LLM.
///
/// Uses [showAnchoredOverlayMenu] so the menu paints above DashBot's
/// [OverlayEntry] (navigator [showMenu] would open underneath).
class AIModelSelectorButton extends ConsumerWidget {
  final AIRequestModel? aiRequestModel;
  final bool readonly;
  final Function(AIRequestModel)? onModelUpdated;
  final ButtonStyle? buttonStyle;
  final bool showAddWhenEmpty;
  final bool dashbotStyle;

  const AIModelSelectorButton({
    super.key,
    this.aiRequestModel,
    this.readonly = false,
    this.onModelUpdated,
    this.buttonStyle,
    this.showAddWhenEmpty = true,
    this.dashbotStyle = false,
  });

  Future<void> _select(WidgetRef ref, ConfiguredLLM llm) async {
    final settings = ref.read(settingsProvider);
    final model = resolveAIRequestFromLLM(llm);
    var providers =
        Map<String, Map<String, Object?>>.from(settings.aiProviders ?? {});
    if (model.model != null) {
      providers = setProviderLastModel(providers, llm.id, model.model!);
      await ref.read(settingsProvider.notifier).update(aiProviders: providers);
    }
    onModelUpdated?.call(applyProviderCredentials(model, providers));
  }

  Future<void> _openMenu(
    BuildContext context,
    WidgetRef ref,
    List<ConfiguredLLM> configured,
  ) async {
    final current = aiRequestModel?.model;
    final value = await showAnchoredOverlayMenu<String>(
      context: context,
      items: [
        for (final llm in configured)
          OverlayMenuItem(
            value: llm.id,
            label: llm.displayName,
            trailing: (current == llm.displayName || current == llm.lastModel)
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        if (configured.isNotEmpty) OverlayMenuItem.divider(),
        const OverlayMenuItem(value: '__add__', label: kLabelAddLLMEllipsis),
      ],
    );
    if (value == null) return;
    if (value == '__add__') {
      openAddLlmInSettings(ref);
      return;
    }
    await _select(ref, configured.firstWhere((e) => e.id == value));
  }

  Widget _chip(BuildContext context, String label, {VoidCallback? onTap}) {
    final blue = kColorSchemeSeed.shade700;
    final cs = Theme.of(context).colorScheme;
    final bg = dashbotStyle ? Colors.white : cs.secondaryContainer;
    final fg = dashbotStyle ? blue : cs.onSecondaryContainer;

    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fg,
                fontWeight: dashbotStyle ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 18, color: fg),
          ],
        ],
      ),
    );

    return Material(
      color: bg,
      borderRadius: kBorderRadius8,
      child: onTap == null
          ? child
          : InkWell(borderRadius: kBorderRadius8, onTap: onTap, child: child),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configured =
        listConfiguredLLMs(ref.watch(settingsProvider).aiProviders);

    if (showAddWhenEmpty && configured.isEmpty && !readonly) {
      if (dashbotStyle) {
        return _chip(
          context,
          kLabelAddLLM,
          onTap: () => openAddLlmInSettings(ref),
        );
      }
      return FilledButton.tonal(
        style: buttonStyle ??
            FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
        onPressed: () => openAddLlmInSettings(ref),
        child: const Text(kLabelAddLLM),
      );
    }

    final label = aiRequestModel?.model?.isNotEmpty == true
        ? aiRequestModel!.model!
        : (configured.isNotEmpty
            ? configured.first.displayName
            : kLabelSelectModel);

    if (readonly) return _chip(context, label);

    return Tooltip(
      message: kLabelSelectModel,
      child: _chip(
        context,
        label,
        onTap: () => _openMenu(context, ref, configured),
      ),
    );
  }
}

/// Default LLM control for DashBot / agents (persists [settings.defaultAIModel]).
class DefaultAIModelSelector extends ConsumerWidget {
  final ButtonStyle? buttonStyle;
  final bool dashbotStyle;

  const DefaultAIModelSelector({
    super.key,
    this.buttonStyle,
    this.dashbotStyle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final aiRequestModel = applyProviderCredentials(
      safeAIRequestModelFromJson(settings.defaultAIModel),
      settings.aiProviders,
    );

    return AIModelSelectorButton(
      aiRequestModel: aiRequestModel,
      buttonStyle: buttonStyle,
      dashbotStyle: dashbotStyle,
      onModelUpdated: (d) async {
        final withCreds = applyProviderCredentials(d, settings.aiProviders);
        await ref.read(settingsProvider.notifier).update(
              defaultAIModel: withCreds
                  .copyWith(
                    modelConfigs: [],
                    stream: null,
                    systemPrompt: '',
                    userPrompt: '',
                  )
                  .toJson(),
            );
      },
    );
  }
}
