import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/response_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Sending Widget Without Timer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Send',
        theme: kThemeDataDark,
        home: const Scaffold(
          body: SendingWidget(
            startSendingTime: null,
          ),
        ),
      ),
    );

    expect(find.byType(Lottie), findsOneWidget);
  });

  testWidgets('Testing Sending Widget With Timer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Send',
        theme: kThemeDataDark,
        home: Scaffold(
          body: SendingWidget(
            startSendingTime: DateTime.now(),
          ),
        ),
      ),
    );
    expect(find.text('Time elapsed: 0 ms'), findsOneWidget);
    expect(find.byType(Lottie), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Time elapsed: 1.00 s'), findsOneWidget);
  });

  testWidgets('Testing Not Sent Widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Not Sent',
        home: Scaffold(
          body: NotSentWidget(),
        ),
      ),
    );

    expect(find.byIcon(Icons.north_east_rounded), findsOneWidget);
    expect(find.text('Not Sent'), findsOneWidget);
  });

  testWidgets('Testing Response Pane Header', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Pane Header',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponsePaneHeader(
              responseStatus: 200,
              message: 'Hi',
              time: Duration(microseconds: 23)),
        ),
      ),
    );

    expect(find.textContaining("200", findRichText: true), findsOneWidget);
    expect(find.textContaining("Hi", findRichText: true), findsOneWidget);
    expect(find.text(humanizeDuration(const Duration(microseconds: 23))),
        findsOneWidget);
  });

  testWidgets('Testing Response Tab View', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Tab View',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponseTabView(
              selectedId: '1', children: [Text('first'), Text('second')]),
        ),
      ),
    );

    expect(find.text('Response Body'), findsOneWidget);
    expect(find.text('Headers'), findsOneWidget);

    await tester.tap(find.text('Headers'));
    await tester.pumpAndSettle();

    expect(find.text('first'), findsNothing);
    expect(find.text('second'), findsOneWidget);
    await tester.tap(find.text('Response Body'));
    await tester.pumpAndSettle();

    expect(find.text('first'), findsOneWidget);
    expect(find.text('second'), findsNothing);
  });

  testWidgets('Testing ResponseHeadersHeader', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Headers Header',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponseHeadersHeader(
              map: {'text': 'a', 'value': '1'}, name: 'xyz'),
        ),
      ),
    );

    expect(find.text('xyz (2 items)'), findsOneWidget);

    expect(find.byIcon(Icons.content_copy), findsOneWidget);
    expect(find.text(kLabelCopy), findsOneWidget);

    final textButton1 = find.byType(TextButton);
    expect(textButton1, findsOneWidget);
    await tester.tap(textButton1);
  });

  testWidgets('Testing Response Headers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Headers',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ResponseHeaders(
            responseHeaders: {
              "Content-Length": "4506",
              "Cache-Control": "private",
              "Content-Type": "application/json",
            },
            requestHeaders: {
              'Host': 'developer',
              'user-agent':
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:50.0) Gecko/20100101 Firefox/50.0',
              'accept': 'text/html',
            },
          ),
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Response Headers (3 items)'), findsOneWidget);
    expect(find.text("Content-Length"), findsOneWidget);
    expect(find.text("4506"), findsOneWidget);

    expect(find.text('Request Headers (3 items)'), findsOneWidget);
    expect(find.text("Accept"), findsOneWidget);
    expect(find.text("User-Agent"), findsOneWidget);
    expect(find.text("developer"), findsOneWidget);

    expect(find.byIcon(Icons.content_copy), findsNWidgets(2));
    expect(find.text(kLabelCopy), findsNWidgets(2));
  });

  testWidgets('Testing Response Body, no data sent', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Body',
        theme: kThemeDataLight,
        home: const Scaffold(body: ResponseBody()),
      ),
    );

    expect(
        find.text(
            'Error: Response data does not exist. $kUnexpectedRaiseIssue'),
        findsOneWidget);
  });

  int statusCode = 200;
  Map<String, String> responseHeaders = {
    "content-length": "16",
    "x-cloud-trace-context": "dad62aaf7f640300bbf629f4ae2f2f63",
    "content-type": "application/json",
    "date": "Sun, 23 Apr 2023 23:46:31 GMT",
    "server": "Google Frontend"
  };
  Map<String, String> requestHeaders = {
    "content-length": "18",
    "content-type": "application/json; charset=utf-8"
  };
  String responseBody = '{"data":"world"}';
  Uint8List bodyBytes = Uint8List.fromList([
    123,
    34,
    100,
    97,
    116,
    97,
    34,
    58,
    34,
    119,
    111,
    114,
    108,
    100,
    34,
    125
  ]);
  String formattedBody = '''{
  "data": "world"
}''';
  Duration time = const Duration(milliseconds: 516);

  RequestModel requestModel = const RequestModel(
      id: '1',
      method: HTTPVerb.post,
      url: 'api.apidash.dev/case/lower',
      name: 'foss42 api',
      requestHeaders: [
        NameValueModel(name: 'content-length', value: '18'),
        NameValueModel(
            name: 'content-type', value: 'application/json; charset=utf-8')
      ],
      requestBodyContentType: ContentType.json,
      requestBody: '''{
"text":"WORLD"
}''',
      responseStatus: 200);

  testWidgets('Testing Response Body, no body', (tester) async {
    ResponseModel responseModelNoBody = ResponseModel(
        statusCode: statusCode,
        headers: responseHeaders,
        requestHeaders: requestHeaders,
        formattedBody: formattedBody,
        bodyBytes: bodyBytes,
        time: time);
    var requestModelNoResponseBody =
        requestModel.copyWith(responseModel: responseModelNoBody);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Body',
        theme: kThemeDataLight,
        home: Scaffold(
          body: ResponseBody(selectedRequestModel: requestModelNoResponseBody),
        ),
      ),
    );

    expect(find.text('Response body is missing (null). $kUnexpectedRaiseIssue'),
        findsOneWidget);
  });

  testWidgets('Testing Response Body, no mediaType', (tester) async {
    ResponseModel responseModelNoHeaders = ResponseModel(
        statusCode: statusCode,
        body: responseBody,
        requestHeaders: requestHeaders,
        formattedBody: formattedBody,
        bodyBytes: bodyBytes,
        time: time);
    var requestModelNoResponseHeaders =
        requestModel.copyWith(responseModel: responseModelNoHeaders);

    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Body',
        theme: kThemeDataLight,
        home: Scaffold(
          body:
              ResponseBody(selectedRequestModel: requestModelNoResponseHeaders),
        ),
      ),
    );

    expect(
        find.text(
            'Unknown Response Content-Type - ${responseModelNoHeaders.contentType}. $kUnexpectedRaiseIssue'),
        findsOneWidget);
  });

  testWidgets('Testing Response Body for No body view', (tester) async {
    String expected =
        "We encountered an error rendering this Content-Type application/octet-stream.\nPlease raise an issue in API Dash GitHub repo so that we can look into this issue.";
    ResponseModel responseModelOctet = ResponseModel(
        statusCode: statusCode,
        body: responseBody,
        headers: const {"content-type": "application/octet-stream"},
        requestHeaders: requestHeaders,
        formattedBody: formattedBody,
        bodyBytes: bodyBytes,
        time: time);
    var requestModelNoResponseHeaders =
        requestModel.copyWith(responseModel: responseModelOctet);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Body',
        theme: kThemeDataLight,
        home: Scaffold(
          body:
              ResponseBody(selectedRequestModel: requestModelNoResponseHeaders),
        ),
      ),
    );
    //await Future.delayed(const Duration(seconds: 5));
    expect(find.text(expected), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets('Testing Response Body for no formatted body', (tester) async {
    ResponseModel responseModel = ResponseModel(
        statusCode: statusCode,
        body: responseBody,
        headers: responseHeaders,
        requestHeaders: requestHeaders,
        bodyBytes: bodyBytes,
        time: time);
    var requestModelNoResponseHeaders =
        requestModel.copyWith(responseModel: responseModel);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Response Body',
        theme: kThemeDataLight,
        home: Scaffold(
          body:
              ResponseBody(selectedRequestModel: requestModelNoResponseHeaders),
        ),
      ),
    );

    expect(find.text("Raw"), findsOneWidget);
  });

  testWidgets('Testing Body Success for ResponseBodyView.none', (tester) async {
    String expected =
        "Please click on 'Raw' to view the unformatted raw results as we encountered an error rendering this Content-Type application/json.\nPlease raise an issue in API Dash GitHub repo so that we can look into this issue.";

    await tester.pumpWidget(
      MaterialApp(
        title: 'Body Success',
        theme: kThemeDataDark,
        home: Scaffold(
          body: BodySuccess(
              body: 'Hello from API Dash',
              mediaType: MediaType("application", "json"),
              options: const [
                ResponseBodyView.none,
                ResponseBodyView.code,
                ResponseBodyView.raw,
              ],
              bytes: Uint8List.fromList([20, 8])),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(expected), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets('Testing Body Success for ResponseBodyView.raw', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Body Success',
        theme: kThemeDataDark,
        home: Scaffold(
          body: BodySuccess(
              body: 'Hello from API Dash',
              mediaType: MediaType("application", "json"),
              options: const [
                ResponseBodyView.raw,
              ],
              bytes: Uint8List.fromList([20, 8])),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Hello from API Dash'), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets('Testing Body Success for ResponseBodyView.code', (tester) async {
    String code = r'''import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/country/codes');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print('Status Code: ${response.statusCode}');
    print('Result: ${response.body}');
  }
  else{
    print('Error Status Code: ${response.statusCode}');
  }
}
''';
    await tester.pumpWidget(
      MaterialApp(
        title: 'Body Success',
        theme: kThemeDataLight,
        home: Scaffold(
          body: BodySuccess(
            body: 'Hello',
            formattedBody: code,
            mediaType: MediaType("application", "json"),
            options: const [
              ResponseBodyView.code,
            ],
            bytes: Uint8List.fromList([20, 8]),
            highlightLanguage: 'dart',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Copy'), findsOneWidget);
    expect(find.textContaining('Error Status Code', findRichText: true),
        findsOneWidget);
  });

  testWidgets('Testing Body Success for ResponseBodyView.preview',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Body Success',
        theme: kThemeDataDark,
        home: Scaffold(
          body: BodySuccess(
            body: 'Hello from API Dash',
            mediaType: MediaType("image", "jpeg"),
            options: const [
              ResponseBodyView.preview,
            ],
            bytes: kBodyBytesJpeg,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets(
      'Testing Body Success tap segment. formattedBody is always shown in Raw',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Body Success',
        theme: kThemeDataLight,
        home: Scaffold(
          body: BodySuccess(
            body: 'Raw Hello from API Dash',
            formattedBody: 'Formatted Hello from API Dash',
            mediaType: MediaType("application", "json"),
            options: const [
              ResponseBodyView.code,
              ResponseBodyView.raw,
            ],
            bytes: kBodyBytesJpeg,
            highlightLanguage: 'json',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Formatted Hello from API Dash'), findsOneWidget);
    expect(find.text('Raw Hello from API Dash'), findsNothing);

    await tester.tap(find.text('Raw'));
    await tester.pumpAndSettle();
    expect(find.text('Formatted Hello from API Dash'), findsOneWidget);
    expect(find.text('Raw Hello from API Dash'), findsNothing);
  });

  testWidgets('Testing Body Success tap segment for formattedBody null',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Body Success',
        theme: kThemeDataLight,
        home: Scaffold(
          body: BodySuccess(
            body: 'Raw Hello from API Dash',
            formattedBody: null,
            mediaType: MediaType("text", "csv"),
            options: const [
              ResponseBodyView.code,
              ResponseBodyView.raw,
            ],
            bytes: kBodyBytesJpeg,
            highlightLanguage: 'txt',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Raw Hello from API Dash'), findsOneWidget);

    await tester.tap(find.text('Raw'));
    await tester.pumpAndSettle();
    expect(find.text('Raw Hello from API Dash'), findsOneWidget);
  });
}
