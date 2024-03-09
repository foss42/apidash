import 'package:apidash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../common/utils.dart';
import '../consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final settings = ref.watch(settingsProvider);
    final clearingData = ref.watch(clearDataStateProvider);
    var sm = ScaffoldMessenger.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: kPh20t40,
          child: kIsDesktop
              ? Text(l10n!.kLabelSettings,
                  style: Theme.of(context).textTheme.headlineLarge)
              : const SizedBox.shrink(),
        ),
        kIsDesktop
            ? const Padding(
                padding: kPh20,
                child: Divider(
                  height: 1,
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: kPh20,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: Text(l10n!.kLabelSwitchThemeMode),
                subtitle: Text(
                    '${l10n.kLabelCurrentSelection} ${settings.isDark ? l10n.kLabelDarkMode : l10n.kLabelLightMode}'),
                value: settings.isDark,
                onChanged: (bool? value) {
                  ref.read(settingsProvider.notifier).update(isDark: value);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: Text(l10n.kLabelPaneScrollbarVisibility),
                subtitle: Text(
                    '${l10n.kLabelCurrentSelection} ${settings.alwaysShowCollectionPaneScrollbar ? l10n.kLabelAlwaysShow : l10n.kLabelShowWhenScrolling}'),
                value: settings.alwaysShowCollectionPaneScrollbar,
                onChanged: (bool? value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(alwaysShowCollectionPaneScrollbar: value);
                },
              ),
              ListTile(
                contentPadding: kPb10,
                hoverColor: kColorTransparent,
                title: Text(l10n.kLabelDefaultURIScheme),
                subtitle: Text(
                    'api.apidash.dev → ${settings.defaultUriScheme}://api.apidash.dev'),
                trailing: DropdownMenu(
                    onSelected: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .update(defaultUriScheme: value);
                    },
                    initialSelection: settings.defaultUriScheme,
                    dropdownMenuEntries: kSupportedUriSchemes
                        .map<DropdownMenuEntry<String>>((value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList()),
              ),
              ListTile(
                contentPadding: kPb10,
                hoverColor: kColorTransparent,
                title: Text(l10n.kLabelDefaultCodeGenerator),
                trailing: DropdownMenu(
                    onSelected: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .update(defaultCodeGenLang: value);
                    },
                    initialSelection: settings.defaultCodeGenLang,
                    dropdownMenuEntries: CodegenLanguage.values
                        .map<DropdownMenuEntry<CodegenLanguage>>((value) {
                      return DropdownMenuEntry<CodegenLanguage>(
                        value: value,
                        label: value.label,
                      );
                    }).toList()),
              ),
              ListTile(
                contentPadding: kPb10,
                hoverColor: kColorTransparent,
                title: Text(l10n.kLabelDefaultLocale),
                trailing: DropdownMenu(
                  onSelected: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .update(defaultLocale: value);
                  },
                  initialSelection: AppLocalizations.of(context)?.localeName,
                  dropdownMenuEntries: L10n.supportedLocales
                      .map(
                        (locale) => DropdownMenuEntry(
                          value: locale.languageCode,
                          label: L10n.getLanguageFromLocale(locale),
                        ),
                      )
                      .toList(),
                  // dropdownMenuEntries: CodegenLanguage.values
                  //     .map<DropdownMenuEntry<CodegenLanguage>>((value) {
                  //   return DropdownMenuEntry<CodegenLanguage>(
                  //     value: value,
                  //     label: value.label,
                  //   );
                  // }).toList(),
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.kLabelSaveResponses),
                subtitle: Text(l10n.kLabelSaveResponsesSubtitle),
                value: settings.saveResponses,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(saveResponses: value);
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.kLabelSaveAlertOnClose),
                subtitle: Text(l10n.kLabelSaveAlertOnCloseSubtitle),
                value: settings.promptBeforeClosing,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(promptBeforeClosing: value);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: Text(l10n.kLabelExportData),
                subtitle: Text(l10n.kLabelHARExport),
                trailing: FilledButton.icon(
                  onPressed: () async {
                    var data = await ref
                        .read(collectionStateNotifierProvider.notifier)
                        .exportDataToHAR();
                    await saveCollection(data, sm);
                  },
                  label: Text(l10n.kLabelExport),
                  icon: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 20,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: Text(l10n.kLabelClearData),
                subtitle: Text(l10n.kLabelClearDataSubtitle),
                trailing: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                      backgroundColor: settings.isDark
                          ? kColorDarkDanger
                          : kColorLightDanger,
                      surfaceTintColor: kColorRed,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary),
                  onPressed: clearingData
                      ? null
                      : () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(l10n.kLabelClearData),
                              content: Text(l10n.kLabelClearDataConfirm),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text(l10n.kLabelCancel),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'Yes');
                                    await ref
                                        .read(collectionStateNotifierProvider
                                            .notifier)
                                        .clearData();

                                    sm.hideCurrentSnackBar();
                                    sm.showSnackBar(
                                        getSnackBar("Requests Data Cleared"));
                                  },
                                  child: Text(
                                    'Yes',
                                    style: kTextStyleButton.copyWith(
                                        color: settings.isDark
                                            ? kColorDarkDanger
                                            : kColorLightDanger),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  label: Text(l10n.kLabelClear),
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
