import 'package:apidash/models/settings_model.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:apidash/main.dart' as app;
import 'package:apidash/app.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';

import 'env_helper.dart';
import 'req_helper.dart';

class ApidashTestHelper {
  final WidgetTester tester;

  ApidashTestHelper(this.tester);

  ApidashTestRequestHelper? _reqHelper;
  ApidashTestEnvHelper? _envHelper;

  ApidashTestRequestHelper get reqHelper {
    _reqHelper ??= ApidashTestRequestHelper(tester);
    return _reqHelper!;
  }

  ApidashTestEnvHelper get envHelper {
    _envHelper ??= ApidashTestEnvHelper(tester);
    return _envHelper!;
  }

  static Future<IntegrationTestWidgetsFlutterBinding> initialize(
      {Size? size}) async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    await app.initApp(false);
    await app.initWindow(sz: size);

    return binding;
  }

  static Future<void> loadApp(WidgetTester tester) async {
    await app.initApp(false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(
            (ref) => ThemeStateNotifier(
                settingsModel: const SettingsModel()
                    .copyWithPath(workspaceFolderPath: "test")),
          )
        ],
        child: const DashApp(),
      ),
    );
  }

  Future<void> navigateToRequestEditor(
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    if (scaffoldKey != null) {
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byIcon(Icons.auto_awesome_mosaic_outlined));
    await tester.pumpAndSettle();
  }

  Future<void> navigateToEnvironmentManager(
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    if (scaffoldKey != null) {
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byIcon(Icons.laptop_windows_outlined));
    await tester.pumpAndSettle();
  }

  Future<void> navigateToHistory(
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    if (scaffoldKey != null) {
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byIcon(Icons.history_outlined));
    await tester.pumpAndSettle();
  }

  Future<void> navigateToSettings(
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    if (scaffoldKey != null) {
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
  }

  Future<void> changeURIScheme(String scheme) async {
    await tester.tap(find.descendant(
        of: find.byType(URIPopupMenu),
        matching: find.byIcon(Icons.unfold_more)));
    await tester.pumpAndSettle();

    await tester.tap(find.text(scheme).last);
    await tester.pumpAndSettle();
  }

  Future<void> changeCodegenLanguage(CodegenLanguage language) async {
    await tester.tap(find.descendant(
        of: find.byType(CodegenPopupMenu),
        matching: find.byIcon(Icons.unfold_more)));
    await tester.pumpAndSettle();

    await tester.tap(find.text(language.label).last);
    await tester.pumpAndSettle();
  }
}

@isTest
void apidashWidgetTest(
  String description,
  double? width,
  Future<void> Function(WidgetTester, ApidashTestHelper) test,
) {
  testWidgets(
    description,
    (widgetTester) async {
      await ApidashTestHelper.initialize(
          size: width != null ? Size(width, kMinWindowSize.height) : null);
      await ApidashTestHelper.loadApp(widgetTester);
      await test(widgetTester, ApidashTestHelper(widgetTester));
      await clearSharedPrefs();
    },
    semanticsEnabled: false,
  );
}
