import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/utils/har_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../request_models.dart';

void main() {
  group(
    "Testing HAR Utils",
    () {
      test('Test collectionToHAR', () async {
        Map<String, dynamic> expectedResult = {
          'log': {
            'creator': {
              'comment':
                  'For support, check out API Dash repo - https://github.com/foss42/apidash',
              'version': '1.0',
              'name': 'API Dash'
            },
            'entries': [
              {
                'startedDateTime': 'ABC',
                'comment': 'id:get6',
                'serverIPAddress': '',
                'time': 0,
                'timings': {
                  'connect': -1,
                  'comment': '',
                  'blocked': -1,
                  'dns': -1,
                  'receive': 0,
                  'send': 0,
                  'wait': 0,
                  'ssl': -1
                },
                'response': {
                  'status': 200,
                  'statusText': 'OK',
                  'httpVersion': 'HTTP/1.1',
                  'cookies': [],
                  'headers': [],
                  'content': {
                    'size': 0,
                    'mimeType': '',
                    'comment': '',
                    'text': ''
                  },
                  'redirectURL': '',
                  'headersSize': 0,
                  'bodySize': 0,
                  'comment': ''
                },
                'request': {
                  'method': 'GET',
                  'url': 'https://api.github.com/repos/foss42/apidash?raw=true',
                  'httpVersion': 'HTTP/1.1',
                  'queryString': [
                    {'name': 'raw', 'value': 'true', 'comment': ''}
                  ],
                  'headers': [
                    {'name': 'User-Agent', 'value': 'Test Agent', 'comment': ''}
                  ],
                  'comment': '',
                  'cookies': [],
                  'headersSize': -1,
                  'bodySize': 0
                },
                'cache': {}
              },
              {
                'startedDateTime': 'ABC',
                'comment': 'id:enabledRows',
                'serverIPAddress': '',
                'time': 0,
                'timings': {
                  'connect': -1,
                  'comment': '',
                  'blocked': -1,
                  'dns': -1,
                  'receive': 0,
                  'send': 0,
                  'wait': 0,
                  'ssl': -1
                },
                'response': {
                  'status': 200,
                  'statusText': 'OK',
                  'httpVersion': 'HTTP/1.1',
                  'cookies': [],
                  'headers': [],
                  'content': {
                    'size': 0,
                    'mimeType': '',
                    'comment': '',
                    'text': ''
                  },
                  'redirectURL': '',
                  'headersSize': 0,
                  'bodySize': 0,
                  'comment': ''
                },
                'request': {
                  'method': 'GET',
                  'url':
                      'https://api.foss42.com/humanize/social?num=8700000&digits=3&system=SS&add_space=true',
                  'httpVersion': 'HTTP/1.1',
                  'queryString': [
                    {'name': 'num', 'value': '8700000', 'comment': ''},
                    {'name': 'digits', 'value': '3', 'comment': ''},
                    {'name': 'system', 'value': 'SS', 'comment': ''},
                    {'name': 'add_space', 'value': 'true', 'comment': ''}
                  ],
                  'headers': [
                    {
                      'name': 'User-Agent',
                      'value': 'Test Agent',
                      'comment': ''
                    },
                    {
                      'name': 'Content-Type',
                      'value': 'application/json',
                      'comment': ''
                    }
                  ],
                  'comment': '',
                  'cookies': [],
                  'headersSize': -1,
                  'bodySize': 0
                },
                'cache': {}
              },
              {
                'startedDateTime': 'ABC',
                'comment': 'id:post3',
                'serverIPAddress': '',
                'time': 0,
                'timings': {
                  'connect': -1,
                  'comment': '',
                  'blocked': -1,
                  'dns': -1,
                  'receive': 0,
                  'send': 0,
                  'wait': 0,
                  'ssl': -1
                },
                'response': {
                  'status': 200,
                  'statusText': 'OK',
                  'httpVersion': 'HTTP/1.1',
                  'cookies': [],
                  'headers': [],
                  'content': {
                    'size': 0,
                    'mimeType': '',
                    'comment': '',
                    'text': ''
                  },
                  'redirectURL': '',
                  'headersSize': 0,
                  'bodySize': 0,
                  'comment': ''
                },
                'request': {
                  'method': 'POST',
                  'url': 'https://api.foss42.com/case/lower',
                  'httpVersion': 'HTTP/1.1',
                  'queryString': [],
                  'headers': [
                    {
                      'name': 'Content-Type',
                      'value': 'application/json',
                      'comment': ''
                    },
                    {'name': 'User-Agent', 'value': 'Test Agent', 'comment': ''}
                  ],
                  'postData': {
                    'mimeType': 'application/json',
                    'text': '{\n'
                        '"text": "I LOVE Flutter"\n'
                        '}',
                    'comment': ''
                  },
                  'comment': '',
                  'cookies': [],
                  'headersSize': -1,
                  'bodySize': 28
                },
                'cache': {}
              }
            ],
            'comment': '',
            'browser': {'version': '1.0', 'comment': '', 'name': 'API Dash'},
            'version': '1.2'
          }
        };
        PackageInfo.setMockInitialValues(
            appName: "apidash",
            packageName: "dev.apidash.apidash",
            version: "1.0",
            buildNumber: "3",
            buildSignature: "XYZ");
        var result = await collectionToHAR([
          requestModelGet6,
          requestModelGet11,
          requestModelPost3,
        ]);
        result['log']['entries'][0]['startedDateTime'] = 'ABC';
        result['log']['entries'][1]['startedDateTime'] = 'ABC';
        result['log']['entries'][2]['startedDateTime'] = 'ABC';
        expect(result, expectedResult);
      });

      test('Test requestModelToHARJsonRequest', () {
        Map<String, dynamic> expectedResult = {
          'method': 'GET',
          'url': 'https://api.github.com/repos/foss42/apidash?raw=true',
          'httpVersion': 'HTTP/1.1',
          'queryString': [
            {'name': 'raw', 'value': 'true'}
          ],
          'headers': [
            {'name': 'User-Agent', 'value': 'Test Agent'}
          ]
        };
        expect(requestModelToHARJsonRequest(requestModelGet6), expectedResult);
      });

      test('Test requestModelToHARJsonRequest exportMode=true', () {
        Map<String, dynamic> expectedResult = {
          'method': 'GET',
          'url': 'https://api.github.com/repos/foss42/apidash?raw=true',
          'httpVersion': 'HTTP/1.1',
          'queryString': [
            {'name': 'raw', 'value': 'true', 'comment': ''}
          ],
          'headers': [
            {'name': 'User-Agent', 'value': 'Test Agent', 'comment': ''}
          ],
          'comment': '',
          'cookies': [],
          'headersSize': -1,
          'bodySize': 0
        };
        expect(
            requestModelToHARJsonRequest(
              requestModelGet6,
              exportMode: true,
            ),
            expectedResult);
      });

      test('Test requestModelToHARJsonRequest exportMode=true', () {
        Map<String, dynamic> expectedResult = {
          'method': 'POST',
          'url': 'https://api.foss42.com/case/lower',
          'httpVersion': 'HTTP/1.1',
          'queryString': [],
          'headers': [
            {'name': 'Content-Type', 'value': 'application/json', 'comment': ''}
          ],
          'postData': {
            'mimeType': 'application/json',
            'text': '{\n'
                '"text": "I LOVE Flutter"\n'
                '}',
            'comment': ''
          },
          'comment': '',
          'cookies': [],
          'headersSize': -1,
          'bodySize': 28
        };
        expect(
            requestModelToHARJsonRequest(
              requestModelPost2,
              exportMode: true,
            ),
            expectedResult);
      });

      test('Test requestModelToHARJsonRequest useEnabled=false', () {
        Map<String, dynamic> expectedResult = {
          'method': 'GET',
          'url':
              'https://api.foss42.com/humanize/social?num=8700000&digits=3&system=SS&add_space=true',
          'httpVersion': 'HTTP/1.1',
          'queryString': [
            {'name': 'num', 'value': '8700000'},
            {'name': 'digits', 'value': '3'},
            {'name': 'system', 'value': 'SS'},
            {'name': 'add_space', 'value': 'true'}
          ],
          'headers': [
            {'name': 'User-Agent', 'value': 'Test Agent'},
            {'name': 'Content-Type', 'value': 'application/json'}
          ]
        };
        expect(requestModelToHARJsonRequest(requestModelGet11), expectedResult);
      });

      test('Test requestModelToHARJsonRequest useEnabled=true', () {
        Map<String, dynamic> expectedResult = {
          'method': 'GET',
          'url': 'https://api.foss42.com/humanize/social?num=8700000&digits=3',
          'httpVersion': 'HTTP/1.1',
          'queryString': [
            {'name': 'num', 'value': '8700000'},
            {'name': 'digits', 'value': '3'}
          ],
          'headers': [
            {'name': 'User-Agent', 'value': 'Test Agent'}
          ]
        };
        expect(
            requestModelToHARJsonRequest(
              requestModelGet11,
              useEnabled: true,
            ),
            expectedResult);
      });
    },
  );
}
