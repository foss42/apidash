# better_networking example

### Making HTTP Requests
```dart
 final (resp, duration, err) = await sendHttpRequest(
    'Request1',
    APIType.rest,
    HttpRequestModel(
        url: 'https://example.com',
        method: HTTPVerb.post,
        headers: [
            NameValueModel(
                name: 'x-api-key',
                value: 'AeAze8493ufhd9....',
            ),
        ],
        params: [NameValueModel(name: 'version', value: 'v1')],
        query: 'users',
        body: jsonEncode({"name": "morpheus", "job": "leader"}),
        formData: [
            FormDataModel(
            name: 'name',
            value: 'morpheus',
            type: FormDataType.text,
            ),
        ],
    ),
);
//Similarly, Requests can be made for all the types of requests
```

### Making Streaming Requests (SSE)
```dart
final stream = await streamHttpRequest(
    'S1',
    APIType.rest,
    HttpRequestModel(
        method: HTTPVerb.get,
        url: 'http://example.com',
        body: jsonEncode({...}),
    ),
);
stream.listen(
    (data) {
        print('Recieved Data: $data');
    },
    onDone: () {
        print('Streaming Complete');
    },
    onError: (e) {
        print(e);
    },
);
```

### Cancelling Requests
```dart
cancelHttpRequest('request-id');
```

### Make GraphQL Requsts
```dart
APIType.graphql
```