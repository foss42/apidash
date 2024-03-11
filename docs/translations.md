# Translations

Our objective is to ensure the localization of API Dash, extending its reach to diverse linguistic communities across various regions, thereby fostering collaboration among developers worldwide.


## Adding new UI strings

### Adding a string to the translation database

To add a new string in the UI, start by
- adding an entry in the ARB file `lib/l10n/app_en.arb`.
- This includes a name that you choose for the string, its value in English, and a "resource attribute" describing the string in context.
- The name will become an identifier in our Dart code.
- The description will provide context for people contributing translations.

For example, this entry describes a UI string named `kLabelSendAPIRequest` which appears in English as "*Send direct message*":
```
  "kLabelSendAPIRequest": "Send API Request",
  "@kLabelSendAPIRequest": {
    "description": "Label for button to send an API request."
  },
```

 - Then run the app (with `flutter run` or in your IDE), or perform a hot reload, to cause the Dart bindings to be updated based on your changes to the ARB file.

#### NOTE
- Also do generate the string for other supported locales before merging the PR. The steps are same, but you'll not need to add `@kLabelSendAPIRequest` key for `.arb` file.
- You can also trigger an update directly, with `flutter gen-l10n`.


### Using a translated string in the code

To use in our widgets, you need to import the generated bindings:
```
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

 - Then in your widget code, pull the localizations object off of the
   Flutter build context:
  ```
  Widget build(BuildContext context) {
    final l10n= AppLocalizations.of(context);
  ```
 - Finally, on the localizations object use the getter that was generated for the new string:  
 `Text(l10n.kLabelSendAPIRequest)`.


## Enforce specific locale

For testing the app's behavior in different locales, you can use your device's system settings to change the preferred language.

Alternatively, you may find it helpful to pass a `localeResolutionCallback` to the `MaterialApp` in `app.dart` to enforce a particular locale:

```
return MaterialApp(
    title: 'API Dash',
    localizationsDelegates: L10n.delegates,
    supportedLocales: L10n.supportedLocales,
    localeResolutionCallback: (locale, supportedLocales) {
      return const Locale("es");
    },
    home: const SomeWidget());
```

 - When using this hack, returning a locale not in `supportedLocales`
   will cause a crash.
 - The default behavior without `localeResolutionCallback` ensures a
   fallback is always selected.

## Tests

Widgets that access localizations will fail if the ambient `MaterialApp` isn't set up for localizations.

In tests, this typically requires a test's setup code to provide arguments `localizationDelegates` and `supportedLocales`.


For example:
```
late  AppLocalizations  l10n;
await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: L10n.delegates,
        locale: L10n.fallbackLocale,
        title: 'Copy Button',
        home: Builder(builder: (context) {
          l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: SomeWidget(),
          );
        }),
      ),
    );
```


## Other notes

- Our approach uses the `flutter_localizations` package.
- We use the `gen_l10n` way, where we write ARB files and the tool generates the Dart bindings.
