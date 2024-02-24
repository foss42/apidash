import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() async {
  setUp(() async => await testSetUp());

  test('Request method changes from GET to POST when body is added', () {
    // Create a ProviderContainer for this test.
    // DO NOT share ProviderContainers between tests.
    final container = createContainer();
    final ref = container.read(collectionStateNotifierProvider.notifier);

    // One API request is preloaded always
    final id = ref.state!.entries.first.key;

    // preloaded API is a GET request
    expect(ref.getRequestModel(id)!.method, HTTPVerb.get);
    expect(ref.getRequestModel(id)!.requestBody, null);

    // add request body
    ref.update(id, requestBody: 'body');

    // vertify new model is POST
    expect(ref.getRequestModel(id)!.method, HTTPVerb.post);
  });
}
