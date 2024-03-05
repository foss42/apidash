import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<MqttServerClient> connectToMqttServer({
  required String broker,
  required String clientId,
}) async {
  final client = MqttServerClient(broker, clientId);
  client.setProtocolV311();

  try {
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  return client;
}

Future<void> publishMessage({
  required MqttServerClient client,
  required String topic,
  required String message,
  required MqttQos qos,
}) async {
  final builder = MqttClientPayloadBuilder();
  builder.addString(message);

  client.publishMessage(topic, qos, builder.payload!);
}

Future<void> subscribeToTopic(
    MqttServerClient client, String topic, MqttQos qosLevel) async {
  client.subscribe(topic, qosLevel);
}

Future<void> disconnectFromMqttServer(MqttServerClient client) async {
  client.disconnect();
}
