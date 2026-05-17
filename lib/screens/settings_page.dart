import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import '../consts.dart';
import 'common_widgets/common_widgets.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final clearingData = ref.watch(clearDataStateProvider);
    var sm = ScaffoldMessenger.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !context.isMediumWindow
            ? Padding(
                padding: kPh20t40,
                child: kIsDesktop
                    ? Text(
                        kLabelSettings,
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                    : kSizedBoxEmpty,
              )
            : kSizedBoxEmpty,
        kIsDesktop
            ? const Padding(padding: kPh20, child: Divider(height: 1))
            : kSizedBoxEmpty,
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              ADListTile(
                type: ListTileType.switchOnOff,
                title: kLabelSwitchThemeMode,
                subtitle:
                    '$kLabelCurrentSelectionPrefix${settings.isDark ? kLabelDarkMode : kLabelLightMode}',
                value: settings.isDark,
                onChanged: (bool? value) {
                  ref.read(settingsProvider.notifier).update(isDark: value);
                },
              ),
              ADListTile(
                type: ListTileType.switchOnOff,
                title: kLabelDashBotSetting,
                subtitle:
                    '$kLabelCurrentSelectionPrefix${settings.isDashBotEnabled ? kLabelEnabled : kLabelDisabled}',
                value: settings.isDashBotEnabled,
                onChanged: (bool? value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(isDashBotEnabled: value);
                },
              ),
              ADListTile(
                type: ListTileType.switchOnOff,
                title: kLabelCollectionPaneScrollbar,
                subtitle:
                    '$kLabelCurrentSelectionPrefix${settings.alwaysShowCollectionPaneScrollbar ? kLabelAlwaysShow : kLabelShowOnlyWhenScrolling}',
                value: settings.alwaysShowCollectionPaneScrollbar,
                onChanged: (bool? value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(alwaysShowCollectionPaneScrollbar: value);
                },
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text(kLabelDefaultUriScheme),
                subtitle: Text(
                  '$kDefaultUri → ${settings.defaultUriScheme}://$kDefaultUri',
                ),
                trailing: DefaultUriSchemePopupMenu(
                  value: settings.defaultUriScheme,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .update(defaultUriScheme: value);
                  },
                ),
              ),
              !kIsWeb
                  ? ADListTile(
                      type: ListTileType.switchOnOff,
                      title: kLabelDisableSSL,
                      subtitle:
                          '$kLabelCurrentSelectionPrefix${settings.isSSLDisabled ? kLabelSSLDisabled : kLabelSSLEnabled}',
                      value: settings.isSSLDisabled,
                      onChanged: (bool? value) {
                        ref
                            .read(settingsProvider.notifier)
                            .update(isSSLDisabled: value ?? false);
                      },
                    )
                  : kSizedBoxEmpty,
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text(kLabelDefaultCodeGen),
                trailing: CodegenPopupMenu(
                  value: settings.defaultCodeGenLang,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .update(defaultCodeGenLang: value);
                  },
                ),
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text(kLabelDefaultLLM),
                trailing: AIModelSelectorButton(
                  aiRequestModel: AIRequestModel.fromJson(
                    settings.defaultAIModel ?? {},
                  ),
                  onModelUpdated: (d) {
                    ref
                        .read(settingsProvider.notifier)
                        .update(
                          defaultAIModel: d
                              .copyWith(
                                modelConfigs: [],
                                stream: null,
                                systemPrompt: '',
                                userPrompt: '',
                              )
                              .toJson(),
                        );
                  },
                ),
              ),
              CheckboxListTile(
                title: const Text(kLabelSaveResponses),
                subtitle: const Text(kLabelSaveResponsesSubtitle),
                value: settings.saveResponses,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(saveResponses: value);
                },
              ),
              CheckboxListTile(
                title: const Text(kLabelShowSaveAlert),
                subtitle: const Text(kLabelShowSaveAlertSubtitle),
                value: settings.promptBeforeClosing,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(promptBeforeClosing: value);
                },
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text(kLabelHistoryRetention),
                subtitle: Text(
                  'Your request history will be retained${settings.historyRetentionPeriod == HistoryRetentionPeriod.forever ? "" : " for"} ${settings.historyRetentionPeriod.label}',
                ),
                trailing: HistoryRetentionPopupMenu(
                  value: settings.historyRetentionPeriod,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .update(historyRetentionPeriod: value);
                  },
                ),
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text(kLabelExportData),
                subtitle: const Text(kLabelExportDataSubtitle),
                trailing: FilledButton.icon(
                  onPressed: () async {
                    var data = await ref
                        .read(collectionStateNotifierProvider.notifier)
                        .exportDataToHAR();
                    await saveCollection(data, sm);
                  },
                  label: const Text(kLabelExport),
                  icon: const Icon(Icons.arrow_outward_rounded, size: 20),
                ),
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text(kLabelClearData),
                subtitle: const Text(kLabelClearDataSubtitle),
                trailing: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    backgroundColor: settings.isDark
                        ? kColorDarkDanger
                        : kColorLightDanger,
                    surfaceTintColor: kColorRed,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: clearingData
                      ? null
                      : () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            icon: const Icon(Icons.manage_history_rounded),
                            iconColor: settings.isDark
                                ? kColorDarkDanger
                                : kColorLightDanger,
                            title: const Text(kLabelClearData),
                            titleTextStyle: Theme.of(
                              context,
                            ).textTheme.titleLarge,
                            content: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: const Text(kMsgClearDataConfirmation),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text(kLabelCancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context, 'Yes');
                                  await clearSharedPrefs();
                                  await ref
                                      .read(
                                        collectionStateNotifierProvider
                                            .notifier,
                                      )
                                      .clearData();

                                  sm.hideCurrentSnackBar();
                                  sm.showSnackBar(
                                    getSnackBar(kMsgRequestsDataCleared),
                                  );
                                },
                                child: Text(
                                  kLabelYes,
                                  style: kTextStyleButton.copyWith(
                                    color: settings.isDark
                                        ? kColorDarkDanger
                                        : kColorLightDanger,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  label: const Text(kLabelClear),
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              ListTile(
                title: const Text(kLabelAbout),
                subtitle: const Text(kLabelAboutSubtitle),
                onTap: () {
                  showAboutAppDialog(context);
                },
              ),
              kVSpacer20,
            ],
          ),
        ),
      ],
    );
  }
}
