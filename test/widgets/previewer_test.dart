import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/previewer.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/foundation.dart';
import '../test_consts.dart';

void main() {
  Uint8List bytes1 = Uint8List.fromList([20, 8]);
  testWidgets('Testing when type/subtype is application/pdf', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(type: 'application', subtype: 'pdf', bytes: bytes1),
        ),
      ),
    );

    expect(find.text("PDF viewing $kMimeTypeRaiseIssue"), findsOneWidget);
    expect(find.text("Audio playing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("Video playing $kMimeTypeRaiseIssue"), findsNothing);
  });

  testWidgets('Testing when type/subtype is audio/mpeg', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(type: 'audio', subtype: 'mpeg', bytes: bytes1),
        ),
      ),
    );

    expect(find.text("Audio playing $kMimeTypeRaiseIssue"), findsOneWidget);
    expect(find.text("PDF viewing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("Video playing $kMimeTypeRaiseIssue"), findsNothing);
  });

  testWidgets('Testing when type/subtype is video/H264', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(type: 'video', subtype: 'H264', bytes: bytes1),
        ),
      ),
    );

    expect(find.text("Audio playing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("PDF viewing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("Video playing $kMimeTypeRaiseIssue"), findsOneWidget);
  });

  testWidgets('Testing when type/subtype is model/step+xml', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(type: 'model', subtype: 'step+xml', bytes: bytes1),
        ),
      ),
    );

    expect(find.text("Audio playing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("PDF viewing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("Video playing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("model/step+xml mimetype preview $kMimeTypeRaiseIssue"),
        findsOneWidget);
  });

  testWidgets('Testing when type/subtype is image/jpeg', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body:
              Previewer(type: 'image', subtype: 'jpeg', bytes: kBodyBytesJpeg),
        ),
      ),
    );

    expect(find.text("Audio playing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("PDF viewing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("Video playing $kMimeTypeRaiseIssue"), findsNothing);
    expect(find.text("model/step+xml mimetype preview $kMimeTypeRaiseIssue"),
        findsNothing);
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Testing when type/subtype is image/jpeg corrupted',
      (tester) async {
    Uint8List bytesJpegCorrupt = Uint8List.fromList([
      255,
      216,
      255,
      225,
      0,
      222,
      69,
      120,
      105,
      102,
      0,
      0,
      173,
      170,
      245,
      235,
      191,
      255,
      217
    ]);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
              type: 'image', subtype: 'jpeg', bytes: bytesJpegCorrupt),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(kImageError), findsOneWidget);
  });
}
