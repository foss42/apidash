import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../widgets/popup_menu_scaling.dart';
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
    final List<int> scaleOptions = [70, 80, 90, 100, 110, 125, 150, 175, 200];

    int currentScaleValue = (settings.scaleFactor * 100).toInt();
    double scale = settings.scaleFactor;
    double scaledPadding = 20 * scale;
    double scaledFontSize = 16 * scale;
    if (!scaleOptions.contains(currentScaleValue)) {
      currentScaleValue = 100;
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !context.isMediumWindow
            ? Padding(
          padding: EdgeInsets.symmetric(
              horizontal: scaledPadding, vertical: scaledPadding ),
          child: kIsDesktop
              ? Text("Settings",
              style: TextStyle(fontSize: scaledFontSize*2))
              : const SizedBox.shrink(),
        )
            : const SizedBox.shrink(),
        kIsDesktop
            ? Padding(
          padding: EdgeInsets.symmetric(horizontal: scaledPadding),
          child: const Divider(height: 1),
        )
            : const SizedBox.shrink(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              SwitchListTile(
                hoverColor: kColorTransparent,
                title:  Text('Switch Theme Mode',style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text(
                    'Current selection: ${settings.isDark ? "Dark Mode" : "Light mode"}',
                    style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
                value: settings.isDark,
                onChanged: (bool? value) {
                  ref.read(settingsProvider.notifier).update(isDark: value);
                },
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: Text('UI Scale Factor', style: TextStyle(fontSize: scaledFontSize * 1.35)),
                subtitle: Text(
                  'Adjust the UI scale factor',
                  style: TextStyle(fontSize: scaledFontSize, color: Colors.grey),
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: scaledPadding * 0.5),
                  child: ScaleFactorPopupMenu(
                    value: currentScaleValue,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .update(scaleFactor: newValue / 100);
                      }
                    },
                    items: scaleOptions,
                  ),
                ),
              ),
              SwitchListTile(
                hoverColor: kColorTransparent,
                title: Text('Collection Pane Scrollbar Visibility',style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text(
                  'Current selection: ${settings.alwaysShowCollectionPaneScrollbar ? "Always show" : "Show only when scrolling"}',
                  style: TextStyle(fontSize: scaledFontSize,color: Colors.grey),
                ),
                value: settings.alwaysShowCollectionPaneScrollbar,
                onChanged: (bool? value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(alwaysShowCollectionPaneScrollbar: value);
                },
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title:  Text('Default URI Scheme',style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text(
                    '$kDefaultUri → ${settings.defaultUriScheme}://$kDefaultUri',
                    style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
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
                title:  Text('Default Code Generator',style: TextStyle(fontSize: scaledFontSize*1.35)),
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
                title:  Text("Save Responses",style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text("Save disk space by not storing API responses",style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
                value: settings.saveResponses,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(saveResponses: value);
                },
              ),
              CheckboxListTile(
                title:  Text("Show Save Alert on App Close",style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text(
                    "Show a confirmation dialog to save workspace when the user closes the app",style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
                value: settings.promptBeforeClosing,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .update(promptBeforeClosing: value);
                },
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title: Text('Export Data',style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text(
                    'Export your collection to HAR (HTTP Archive format).\nVersion control this file or import in other API clients.',
                    style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
                trailing: FilledButton.icon(
                  onPressed: () async {
                    var data = await ref
                        .read(collectionStateNotifierProvider.notifier)
                        .exportDataToHAR();
                    await saveCollection(data, sm);
                  },
                  label:  Text("Export",style: TextStyle(fontSize: scaledFontSize)),
                  icon: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 20,
                  ),
                ),
              ),
              ListTile(
                hoverColor: kColorTransparent,
                title:  Text('History Retention Period',style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text(
                    'Your request history will be retained${settings.historyRetentionPeriod == HistoryRetentionPeriod.forever ? "" : " for"} ${settings.historyRetentionPeriod.label}',
                    style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
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
                title:  Text('Clear Data',style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle:  Text('Delete all requests data from the disk',style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
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
                      title:  Text('Clear Data',style: TextStyle(fontSize: scaledFontSize)),
                      titleTextStyle:
                      Theme.of(context).textTheme.titleLarge,
                      content: ConstrainedBox(
                        constraints:
                        const BoxConstraints(maxWidth: 300),
                        child:  Text(
                            'This action will clear all the requests data from the disk and is irreversible. Do you want to proceed?',style: TextStyle(fontSize: scaledFontSize)),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, 'Cancel'),
                          child:  Text('Cancel',style: TextStyle(fontSize: scaledFontSize)),
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
                                getSnackBar("Requests Data Cleared",));
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
                  label:  Text("Clear",style: TextStyle(fontSize: scaledFontSize)),
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    size: 20,
                  ),
                ),
              ),
              ListTile(
                title:  Text('About',style: TextStyle(fontSize: scaledFontSize*1.35)),
                subtitle: Text(
                    'Release Details, Support Channel, Report Bug / Request New Feature',
                    style: TextStyle(fontSize: scaledFontSize,color: Colors.grey)),
                trailing: IconButton(
                  onPressed: () {
                    // Implement about dialog or page
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
