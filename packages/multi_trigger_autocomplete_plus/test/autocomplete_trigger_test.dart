import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_trigger_autocomplete_plus/src/autocomplete_trigger.dart';

void main() {
  group('Autocomplete with trigger `@`', () {
    final trigger = AutocompleteTrigger(
        trigger: '@',
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        });

    test('should return null if `@` is not found', () {
      const text = 'Hello There';
      const value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );

      final invoked = trigger.invokingTrigger(value);

      expect(invoked, isNull);
    });

    test(
      'should return null if `@` is found but the cursor is not at the triggered word',
      () {
        const text = 'Hello there @Sahil Kumar';
        const value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );

        final invoked = trigger.invokingTrigger(value);

        expect(invoked, isNull);
      },
    );

    test(
      'should return the autocomplete query if `@` is found and the cursor is at the triggered word',
      () {
        const text = 'Hello there @Sahil Kumar';
        const value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: 18),
        );

        final invoked = trigger.invokingTrigger(value);

        expect(invoked, isNotNull);
        expect(invoked!.query, 'Sahil');
        expect(
          invoked.selection,
          const TextSelection(baseOffset: 13, extentOffset: 18),
        );
      },
    );

    test(
      'should return null if `@` is found but the cursor is not after a space',
      () {
        const text = 'Hello there@Sahil Kumar';
        const value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: 16),
        );

        final invoked = trigger.invokingTrigger(value);

        expect(invoked, isNull);
      },
    );

    test(
      'should return the autocomplete query if `@` is found and the cursor is at the triggered word containing `_` between them',
      () {
        const text = 'Hello there @Sahil_Kumar';
        const value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );

        final invoked = trigger.invokingTrigger(value);

        expect(invoked, isNotNull);
        expect(invoked!.query, 'Sahil_Kumar');
        expect(
          invoked.selection,
          const TextSelection(baseOffset: 13, extentOffset: 24),
        );
      },
    );
  });

  group('Autocomplete trigger with `triggerOnlyAtStart` true', () {
    final trigger = AutocompleteTrigger(
      trigger: '@',
      triggerOnlyAtStart: true,
      optionsViewBuilder: (
        context,
        autocompleteQuery,
        textEditingController,
      ) {
        return const SizedBox.shrink();
      },
    );

    test(
      'should return query if `@` is invoked at the start and cursor is after the word',
      () {
        final invoked = trigger.invokingTrigger(
          const TextEditingValue(
            text: '@Sahil hey',
            selection: TextSelection.collapsed(offset: 6),
          ),
        );

        expect(invoked, isNotNull);
        expect(invoked!.query, 'Sahil');
        expect(
          invoked.selection,
          const TextSelection(baseOffset: 1, extentOffset: 6),
        );
      },
    );

    test(
      "should return null if `@` is found but it's not invoked at the start",
      () {
        const text = 'Hey @Sahil';
        final invoked = trigger.invokingTrigger(
          const TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          ),
        );

        expect(invoked, isNull);
      },
    );
  });

  group('Autocomplete trigger with `minimumRequiredCharacters` 3', () {
    final trigger = AutocompleteTrigger(
      trigger: '@',
      minimumRequiredCharacters: 3,
      optionsViewBuilder: (
        context,
        autocompleteQuery,
        textEditingController,
      ) {
        return const SizedBox.shrink();
      },
    );

    test(
      'should return query if `@` is invoked cursor is after the word which is at least 3 characters long',
      () {
        const text = 'Hey @Sahil';
        final invoked = trigger.invokingTrigger(
          const TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          ),
        );

        expect(invoked, isNotNull);
        expect(invoked!.query, 'Sahil');
        expect(
          invoked.selection,
          const TextSelection(baseOffset: 5, extentOffset: 10),
        );
      },
    );

    test(
      "should return null if `@` is found but the word is less than 3 characters long",
      () {
        const text = 'Hey @Sahil';
        final invoked = trigger.invokingTrigger(
          const TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: 6),
          ),
        );

        expect(invoked, isNull);
      },
    );
  });

  group('2 Autocomplete trigger cannot be considered equal if', () {
    test('they have different `trigger`', () {
      final trigger1 = AutocompleteTrigger(
        trigger: '@',
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      final trigger2 = AutocompleteTrigger(
        trigger: '#',
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      expect(trigger1, isNot(trigger2));
    });

    test('they have different `triggerOnlyAtStart`', () {
      final trigger1 = AutocompleteTrigger(
        trigger: '@',
        triggerOnlyAtStart: true,
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      final trigger2 = AutocompleteTrigger(
        trigger: '@',
        triggerOnlyAtStart: false,
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      expect(trigger1, isNot(trigger2));
    });

    test('they have different `triggerOnlyAfterSpace`', () {
      final trigger1 = AutocompleteTrigger(
        trigger: '@',
        triggerOnlyAfterSpace: true,
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      final trigger2 = AutocompleteTrigger(
        trigger: '@',
        triggerOnlyAfterSpace: false,
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      expect(trigger1, isNot(trigger2));
    });

    test('they have different `minimumRequiredCharacters`', () {
      final trigger1 = AutocompleteTrigger(
        trigger: '@',
        minimumRequiredCharacters: 3,
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      final trigger2 = AutocompleteTrigger(
        trigger: '@',
        minimumRequiredCharacters: 4,
        optionsViewBuilder: (
          context,
          autocompleteQuery,
          textEditingController,
        ) {
          return const SizedBox.shrink();
        },
      );
      expect(trigger1, isNot(trigger2));
    });
  });
}
