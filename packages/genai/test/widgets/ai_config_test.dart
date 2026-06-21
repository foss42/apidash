import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/models.dart';
import 'package:genai/widgets/widgets.dart';

void main() {
  group('AIConfigBool', () {
    testWidgets('renders and updates', (tester) async {
      bool updated = false;
      var config = ModelConfig(
        id: 'bool1',
        name: 'Bool',
        description: '',
        type: ConfigType.boolean,
        value: ConfigBooleanValue(value: false),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AIConfigBool(
            configuration: config,
            onConfigUpdated: (c) {
              updated = true;
            },
          ),
        ),
      ));

      expect(find.byType(Switch), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(updated, isTrue);
    });

    testWidgets('readonly ignores tap', (tester) async {
      bool updated = false;
      var config = ModelConfig(
        id: 'bool1',
        name: 'Bool',
        description: '',
        type: ConfigType.boolean,
        value: ConfigBooleanValue(value: false),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AIConfigBool(
            configuration: config,
            readonly: true,
            onConfigUpdated: (c) {
              updated = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(updated, isFalse);
    });
  });

  group('AIConfigField', () {
    testWidgets('renders text and updates', (tester) async {
      bool updated = false;
      var config = ModelConfig(
        id: 'text1',
        name: 'Text',
        description: '',
        type: ConfigType.text,
        value: ConfigTextValue(value: 'initial'),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AIConfigField(
            configuration: config,
            onConfigUpdated: (c) {
              updated = true;
            },
          ),
        ),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'new text');
      await tester.pumpAndSettle();
      expect(updated, isTrue);
      expect(config.value.value, 'new text');
    });

    testWidgets('renders numeric and updates', (tester) async {
      bool updated = false;
      var config = ModelConfig(
        id: 'num1',
        name: 'Num',
        description: '',
        type: ConfigType.numeric,
        value: ConfigNumericValue(value: 1),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AIConfigField(
            configuration: config,
            numeric: true,
            onConfigUpdated: (c) {
              updated = true;
            },
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), '5');
      await tester.pumpAndSettle();
      expect(updated, isTrue);
      expect(config.value.value, 5);
      
      // Test empty
      updated = false;
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();
      expect(updated, isTrue);
      expect(config.value.value, 0);

      // Test invalid numeric
      updated = false;
      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pumpAndSettle();
      expect(updated, isFalse);
    });

    testWidgets('readonly ignores change', (tester) async {
      bool updated = false;
      var config = ModelConfig(
        id: 'text1',
        name: 'Text',
        description: '',
        type: ConfigType.text,
        value: ConfigTextValue(value: 'initial'),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AIConfigField(
            configuration: config,
            readonly: true,
            onConfigUpdated: (c) {
              updated = true;
            },
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'new');
      await tester.pumpAndSettle();
      expect(updated, isFalse);
    });
  });

  group('AIConfigSlider', () {
    testWidgets('renders and updates', (tester) async {
      bool updated = false;
      var config = ModelConfig(
        id: 'slider1',
        name: 'Slider',
        description: '',
        type: ConfigType.slider,
        value: ConfigSliderValue(value: (0.0, 5.0, 10.0)),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AIConfigSlider(
            configuration: config,
            onSliderUpdated: (c) {
              updated = true;
            },
          ),
        ),
      ));

      expect(find.byType(Slider), findsOneWidget);
      // Drag the slider to change its value
      await tester.drag(find.byType(Slider), const Offset(20, 0));
      await tester.pumpAndSettle();
      expect(updated, isTrue);
    });

    testWidgets('readonly ignores change', (tester) async {
      bool updated = false;
      var config = ModelConfig(
        id: 'slider1',
        name: 'Slider',
        description: '',
        type: ConfigType.slider,
        value: ConfigSliderValue(value: (0.0, 5.0, 10.0)),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AIConfigSlider(
            configuration: config,
            readonly: true,
            onSliderUpdated: (c) {
              updated = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byType(Slider));
      await tester.pumpAndSettle();
      expect(updated, isFalse);
    });
  });
}
