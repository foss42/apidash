import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing MediaQueryExtension', () {
    testWidgets('isCompactWindow returns true for compact window size',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(WindowWidth.compact.value - 1, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isCompactWindow, isTrue);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('isMediumWindow returns true for medium window size',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(WindowWidth.medium.value - 1, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isMediumWindow, isTrue);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('isExpandedWindow returns true for expanded window size',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(WindowWidth.expanded.value - 1, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isExpandedWindow, isTrue);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('isLargeWindow returns true for large window size',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(WindowWidth.large.value - 1, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isLargeWindow, isTrue);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('isExtraLargeWindow returns true for extra large window size',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(WindowWidth.large.value + 1, 800)),
          child: Builder(
            builder: (context) {
              expect(context.isExtraLargeWindow, isTrue);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('width returns correct width', (tester) async {
      const double testWidth = 1024;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(testWidth, 800)),
          child: Builder(
            builder: (context) {
              expect(context.width, testWidth);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('height returns correct height', (tester) async {
      const double testHeight = 768;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1024, testHeight)),
          child: Builder(
            builder: (context) {
              expect(context.height, testHeight);
              return Container();
            },
          ),
        ),
      );
    });
  });
}
