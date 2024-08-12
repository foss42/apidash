import 'dart:ui';

import 'package:apidash/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:integration_test/integration_test.dart';
import 'package:apidash/main.dart' as app;

class ApidashTestHelper {
  final WidgetTester tester;

  ApidashTestHelper(this.tester);

  static Future<IntegrationTestWidgetsFlutterBinding> initialize(
      {Size? size}) async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    await app.initApp();
    await app.initWindow(sz: size);

    return binding;
  }

  static Future<void> loadApp(WidgetTester tester) async {
    await app.initApp();
    await tester.pumpWidget(
      const ProviderScope(
        child: DashApp(),
      ),
    );
  }
}

@isTest
void apidashWidgetTest(
  String description,
  Future<void> Function(WidgetTester, ApidashTestHelper) test,
) {
  testWidgets(
    description,
    (widgetTester) async {
      await ApidashTestHelper.loadApp(widgetTester);
      await test(widgetTester, ApidashTestHelper(widgetTester));
    },
    semanticsEnabled: false,
  );
}
