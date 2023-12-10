import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../utils/utils.dart';
import 'package:apidash/consts.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final clearingData = ref.watch(clearDataStateProvider);
    var sm = ScaffoldMessenger.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: kPh20t40,
            shrinkWrap: true,
            children: [
              kIsDesktop
                  ? Text("Settings",
                      style: Theme.of(context).textTheme.headlineLarge)
                  : const SizedBox.shrink(),
              kIsDesktop ? const Divider() : const SizedBox.shrink(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
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
                contentPadding: EdgeInsets.zero,
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
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: const Text('Default URI Scheme'),
                subtitle: Text(
                    'api.foss42.com → ${settings.defaultUriScheme}://api.foss42.com'),
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
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: const Text('Default Code Generator'),
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
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: const Text('Export Data'),
                subtitle: const Text(
                    'Export your collection to HAR (HTTP Archive format).\nVersion control this file or import in other API clients.'),
                trailing: FilledButton(
                  onPressed: () async {
                    var message = "";
                    try {
                      var data = await ref
                          .read(collectionStateNotifierProvider.notifier)
                          .exportDataToHAR();
                      var pth = await getFileDownloadpath(null, "har");
                      if (pth != null) {
                        await saveFile(pth, jsonMapToBytes(data));
                        var sp = getShortPath(pth);
                        message = 'Saved to $sp';
                      }
                    } catch (e) {
                      message = "An error occurred while exporting.";
                    }
                    sm.hideCurrentSnackBar();
                    sm.showSnackBar(getSnackBar(message, small: false));
                  },
                  child: const Text("Export Data"),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                hoverColor: kColorTransparent,
                title: const Text('Clear Data'),
                subtitle: const Text('Delete all requests data from the disk'),
                trailing: FilledButton.tonal(
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
                              title: const Text('Clear Data'),
                              content: const Text(
                                  'This action will clear all the requests data from the disk and is irreversible. Do you want to proceed?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
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
                  child: const Text("Clear Data"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
