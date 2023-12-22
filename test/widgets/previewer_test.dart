import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart' show PdfPreview;
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import '../test_consts.dart';

void main() {
  Uint8List bytes1 = Uint8List.fromList([20, 8]);
  testWidgets('Testing when type/subtype is application/pdf', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'application',
            subtype: 'pdf',
            bytes: bytes1,
            body: "",
          ),
        ),
      ),
    );

    expect(
        find.text(
            "${kMimeTypeRaiseIssueStart}application/pdf$kMimeTypeRaiseIssue"),
        findsNothing);
    expect(find.byType(PdfPreview), findsOneWidget);
  });

  testWidgets('Testing when type/subtype is audio/mpeg', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'audio',
            subtype: 'mpeg',
            bytes: bytes1,
            body: "",
          ),
        ),
      ),
    );

    expect(find.byType(Uint8AudioPlayer), findsOneWidget);
  });

  testWidgets('Testing when type/subtype is video/H264', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'video',
            subtype: 'H264',
            bytes: bytes1,
            body: "",
          ),
        ),
      ),
    );

    expect(
        find.text("${kMimeTypeRaiseIssueStart}video/H264$kMimeTypeRaiseIssue"),
        findsOneWidget);
  });

  testWidgets('Testing when type/subtype is model/step+xml', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'model',
            subtype: 'step+xml',
            bytes: bytes1,
            body: "",
          ),
        ),
      ),
    );

    expect(
        find.text(
            "${kMimeTypeRaiseIssueStart}model/step+xml$kMimeTypeRaiseIssue"),
        findsOneWidget);
  });

  testWidgets('Testing when type/subtype is image/jpeg', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'image',
            subtype: 'jpeg',
            bytes: kBodyBytesJpeg,
            body: "",
          ),
        ),
      ),
    );

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
            type: 'image',
            subtype: 'jpeg',
            bytes: bytesJpegCorrupt,
            body: "",
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(kImageError), findsOneWidget);
  });

  testWidgets('Testing when type/subtype is audio/mpeg corrupted',
      (tester) async {
    Uint8List bytesAudioCorrupt =
        Uint8List.fromList(List.generate(100, (index) => index));
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'audio',
            subtype: 'mpeg',
            bytes: bytesAudioCorrupt,
            body: "",
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(kAudioError), findsOneWidget);
  });

  testWidgets('Testing when type/subtype is image/svg+xml', (tester) async {
    String rawSvg =
        """<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 166 202">
    <defs>
        <linearGradient id="triangleGradient">
            <stop offset="20%" stop-color="#000000" stop-opacity=".55" />
            <stop offset="85%" stop-color="#616161" stop-opacity=".01" />
        </linearGradient>
        <linearGradient id="rectangleGradient" x1="0%" x2="0%" y1="0%" y2="100%">
            <stop offset="20%" stop-color="#000000" stop-opacity=".15" />
            <stop offset="85%" stop-color="#616161" stop-opacity=".01" />
        </linearGradient>
    </defs>
    <path fill="#42A5F5" fill-opacity=".8" d="M37.7 128.9 9.8 101 100.4 10.4 156.2 10.4"/>
    <path fill="#42A5F5" fill-opacity=".8" d="M156.2 94 100.4 94 79.5 114.9 107.4 142.8"/>
    <path fill="#0D47A1" d="M79.5 170.7 100.4 191.6 156.2 191.6 156.2 191.6 107.4 142.8"/>
    <g transform="matrix(0.7071, -0.7071, 0.7071, 0.7071, -77.667, 98.057)">
        <rect width="39.4" height="39.4" x="59.8" y="123.1" fill="#42A5F5" />
        <rect width="39.4" height="5.5" x="59.8" y="162.5" fill="url(#rectangleGradient)" />
    </g>
    <path d="M79.5 170.7 120.9 156.4 107.4 142.8" fill="url(#triangleGradient)" />
</svg>""";

    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'image',
            subtype: 'svg+xml',
            bytes: Uint8List.fromList([]),
            body: rawSvg,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(kSvgError), findsNothing);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('Testing when type/subtype is image/svg+xml corrupted',
      (tester) async {
    String rawSvg = "rwsjhdws";
    await tester.pumpWidget(
      MaterialApp(
        title: 'Previewer',
        home: Scaffold(
          body: Previewer(
            type: 'image',
            subtype: 'svg+xml',
            bytes: Uint8List.fromList([]),
            body: rawSvg,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(kSvgError), findsOneWidget);
  });
}
