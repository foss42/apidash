import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: kPh60v40,
            shrinkWrap: true,
            children: [
              Text("Settings",
                  style: Theme.of(context).textTheme.headlineLarge),
              const Divider(),
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
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Save Responses"),
                subtitle: const Text(
                    "Saves disk space & clears all previous responses on App start"),
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
                title: const Text('Clear Data'),
                subtitle: const Text('Delete all requests data from the disk'),
                trailing: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                      backgroundColor: settings.isDark
                          ? kColorDarkDanger
                          : kColorLightDanger,
                      surfaceTintColor: Colors.red,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary),
                  onPressed: clearingData
                      ? null
                      : () async {
                          await ref
                              .read(collectionStateNotifierProvider.notifier)
                              .clearData();

                          sm.hideCurrentSnackBar();
                          sm.showSnackBar(getSnackBar("Requests Data Cleared"));
                        },
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
