import 'dart:convert';

import 'package:better_networking/better_networking.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApplication());
}

class ExampleApplication extends StatelessWidget {
  const ExampleApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Networking ',
      home: BetterNetworkingExample(),
    );
  }
}

class BetterNetworkingExample extends StatefulWidget {
  const BetterNetworkingExample({super.key});

  @override
  State<BetterNetworkingExample> createState() =>
      _BetterNetworkingExampleState();
}

class _BetterNetworkingExampleState extends State<BetterNetworkingExample> {
  String currentRequest = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Better Networking Example')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (currentRequest.isEmpty) return;
                debugPrint('Cancelling: $currentRequest');
                cancelHttpRequest(currentRequest);
              },
              child: Text('CANCEL REQUEST'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  currentRequest = 'G1';
                });
                final (resp, duration, err) = await sendHttpRequest(
                  'G1',
                  APIType.rest,
                  HttpRequestModel(
                    url: 'https://reqres.in/api/users/2',
                    method: HTTPVerb.get,
                    authModel: AuthModel(type: APIAuthType.none),
                    headers: [
                      NameValueModel(
                        name: 'x-api-key',
                        value: 'reqres-free-v1',
                      ),
                    ],
                  ),
                );
                debugPrint('Response: ${resp?.body}');
                debugPrint('Duration: ${duration?.inMilliseconds}');
                debugPrint('Error: $err');
              },
              child: Text('GET REQUEST'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  currentRequest = 'P1';
                });
                final (resp, duration, err) = await sendHttpRequest(
                  'P1',
                  APIType.rest,
                  HttpRequestModel(
                    url: 'https://reqres.in/api/users',
                    method: HTTPVerb.post,
                    authModel: AuthModel(type: APIAuthType.none),
                    headers: [
                      NameValueModel(
                        name: 'x-api-key',
                        value: 'reqres-free-v1',
                      ),
                    ],
                    body: jsonEncode({"name": "morpheus", "job": "leader"}),
                  ),
                );
                debugPrint('Response: ${resp?.body}');
                debugPrint('Duration: ${duration?.inMilliseconds}');
                debugPrint('Error: $err');
              },
              child: Text('POST REQUEST'),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  currentRequest = 'S1';
                });
                final stream = await streamHttpRequest(
                  'S1',
                  APIType.rest,
                  HttpRequestModel(
                    method: HTTPVerb.post,
                    url: 'http://localhost:11434/v1/chat/completions',
                    authModel: null,
                    body: jsonEncode({
                      'model': 'gemma3:latest',
                      'stream': true,
                      "messages": [
                        {
                          "role": "system",
                          "content":
                              'Give me a 200 word essay about the given topic',
                        },
                        {"role": "user", "content": 'Flutter'},
                      ],
                    }),
                  ),
                );
                stream.listen(
                  (data) {
                    debugPrint('Recieved Data: $data');
                  },
                  onDone: () {
                    debugPrint('Streaming Complete');
                  },
                  onError: (e) {
                    debugPrint(e);
                  },
                );
              },
              child: Text('STREAM REQUEST'),
            ),
          ],
        ),
      ),
    );
  }
}
