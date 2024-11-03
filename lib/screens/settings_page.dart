import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import '../common/utils.dart';
import '../consts.dart';
import '../extensions/extensions.dart';

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
                    ? Text("Settings",
                        style: Theme.of(context).textTheme.headlineLarge)
                    : const SizedBox.shrink(),
              )
            : const SizedBox.shrink(),
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
            children: [
              SwitchListTile(
                hoverColor: kColorTransparent,
                title: const Text('Switch Theme Mode'),
                subtitle: Text(
                    'Current selection: ${settings.isDark ? "Dark Mode" : "Light mode"}'),
                value: settings.isDark,
                onChanged: (bool? value) {
                  ref.read(settingsProvider.notifier).update(isDark: value);
                },
              ),
              SwitchListTile(
                hoverColor: kColorTransparent,
                title: const Text('Collection Pane Scrollbar Visiblity'),
                subtitle: Text(
                    'Current selection: ${settings.alwaysShowCollectionPaneScrollbar ? "Always show" : "Show only when scrolling"}'),
                value: settings.alwaysShowCollectionPaneScrollbar,
                onChanged: (bool? value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(alwaysShowCollectionPaneScrollbar: value);
                },
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text('Default URI Scheme'),
                subtitle: Text(
                    '$kDefaultUri → ${settings.defaultUriScheme}://$kDefaultUri'),
                trailing: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    borderRadius: kBorderRadius8,
                  ),
                  child: URIPopupMenu(
                    value: settings.defaultUriScheme,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .update(defaultUriScheme: value);
                    },
                    items: kSupportedUriSchemes,
                  ),
                ),
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text('Default Code Generator'),
                trailing: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    borderRadius: kBorderRadius8,
                  ),
                  child: CodegenPopupMenu(
                    value: settings.defaultCodeGenLang,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .update(defaultCodeGenLang: value);
                    },
                    items: CodegenLanguage.values,
                  ),
                ),
              ),
              CheckboxListTile(
                title: const Text("Save Responses"),
                subtitle:
                    const Text("Save disk space by not storing API responses"),
                value: settings.saveResponses,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(saveResponses: value);
                },
              ),
              CheckboxListTile(
                title: const Text("Show Save Alert on App Close"),
                subtitle: const Text(
                    "Show a confirmation dialog to save workspace when the user closes the app"),
                value: settings.promptBeforeClosing,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(promptBeforeClosing: value);
                },
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text('Export Data'),
                subtitle: const Text(
                    'Export your collection to HAR (HTTP Archive format).\nVersion control this file or import in other API clients.'),
                trailing: FilledButton.icon(
                  onPressed: () async {
                    var data = await ref
                        .read(collectionStateNotifierProvider.notifier)
                        .exportDataToHAR();
                    await saveCollection(data, sm);
                  },
                  label: const Text("Export"),
                  icon: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 20,
                  ),
                ),
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text('History Retention Period'),
                subtitle: Text(
                    'Your request history will be retained${settings.historyRetentionPeriod == HistoryRetentionPeriod.forever ? "" : " for"} ${settings.historyRetentionPeriod.label}'),
                trailing: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    borderRadius: kBorderRadius8,
                  ),
                  child: HistoryRetentionPopupMenu(
                    value: settings.historyRetentionPeriod,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .update(historyRetentionPeriod: value);
                    },
                    items: HistoryRetentionPeriod.values,
                  ),
                ),
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: const Text('Clear Data'),
                subtitle: const Text('Delete all requests data from the disk'),
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
                              icon: const Icon(Icons.manage_history_rounded),
                              iconColor: settings.isDark
                                  ? kColorDarkDanger
                                  : kColorLightDanger,
                              title: const Text('Clear Data'),
                              titleTextStyle:
                                  Theme.of(context).textTheme.titleLarge,
                              content: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: const Text(
                                    'This action will clear all the requests data from the disk and is irreversible. Do you want to proceed?'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'Yes');
                                    await clearSharedPrefs();
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
                  label: const Text("Clear"),
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    size: 20,
                  ),
                ),
              ),
              ListTile(
                title: const Text('About'),
                subtitle: const Text(
                    'Release Details, Support Channel, Report Bug / Request New Feature'),
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
