import 'package:apidash_core/apidash_core.dart';
import 'ws_request_model.dart';

part 'mqtt_request_model.freezed.dart';
part 'mqtt_request_model.g.dart';

@freezed
abstract class MQTTRequestModel with _$MQTTRequestModel {
  const MQTTRequestModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory MQTTRequestModel({
    required String brokerUrl,
    @Default(1883) int port,
    String? clientId,
    String? username,
    String? password,
    @Default(MQTTVersion.v5) MQTTVersion version,
    @Default([]) List<NameValueModel> subscribedTopics,
    @Default([]) List<bool> isTopicEnabledList,
    @Default(false) bool useTLS,
    @Default(false) bool useWebSocket,
    @Default(0) int qos,
    @Default([]) List<WebSocketMessage> messageHistory,
    @Default("") String message,
    @Default("") String publishTopic,

    // ── TLS (carry-over from the TLS agent) ──────────────────────────────
    /// When true, the TLS handshake will accept self-signed / untrusted
    /// certificates (wires `onBadCertificate` in [ConnectionManager]). Lets
    /// brokers like `test.mosquitto.org:8883` (private "Mosquitto CA") connect.
    /// Default false — strict validation, the safe default.
    @Default(false) bool allowInvalidCertificates,

    // ── MQTT v5 only ─────────────────────────────────────────────────────
    /// v5 User Properties attached to the CONNECT and PUBLISH packets
    /// (key/value metadata, analogous to HTTP headers). Ignored for v3.1.1.
    @Default([]) List<NameValueModel> userProperties,
    @Default([]) List<bool> isUserPropertyEnabledList,

    /// v5 Request/Response: response topic + correlation data on PUBLISH.
    @Default("") String responseTopic,
    @Default("") String correlationData,

    /// v5 Session Expiry Interval (seconds). Replaces the v3 binary
    /// clean-session flag. 0 = session ends on disconnect (clean start).
    @Default(0) int sessionExpiryInterval,

    /// v5 per-publish Message Expiry Interval (TTL, seconds). 0 = no expiry.
    @Default(0) int messageExpiryInterval,

    // ── Keep Alive & Retain ──────────────────────────────────────────────
    @Default(60) int keepAlivePeriod,
    @Default(false) bool retainMessage,

    // ── Last Will & Testament (LWT) ──────────────────────────────────────
    @Default("") String willTopic,
    @Default("") String willMessage,
    @Default(false) bool willRetain,
    @Default(0) int willQos,
  }) = _MQTTRequestModel;

  factory MQTTRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MQTTRequestModelFromJson(json);

  List<NameValueModel> getConnectionData() {
    List<NameValueModel> connectionData = [
      NameValueModel(name: 'Broker URL', value: brokerUrl),
      NameValueModel(name: 'Port', value: port),
      NameValueModel(name: 'Version', value: version.label),
      NameValueModel(name: 'Client ID', value: clientId),

      NameValueModel(name: 'Username', value: username),
      NameValueModel(name: 'QoS', value: qos),
      NameValueModel(name: 'Keep Alive (s)', value: keepAlivePeriod),
      NameValueModel(
        name: 'Clean Session',
        value: sessionExpiryInterval == 0 ? 'true' : 'false',
      ),
      NameValueModel(
        name: 'Session Expiry (s)',
        value: '$sessionExpiryInterval',
      ),
      NameValueModel(name: 'TLS', value: useTLS ? 'Enabled' : 'Disabled'),
      NameValueModel(
        name: 'WebSocket',
        value: useWebSocket ? 'Enabled' : 'Disabled',
      ),
      NameValueModel(name: 'Retain', value: retainMessage ? 'true' : 'false'),
      NameValueModel(name: 'Will Topic', value: willTopic),
    ];
    return connectionData;
  }
}

/// Enum for MQTT version support.
enum MQTTVersion {
  v3('MQTT 3.0'),
  v3_1_1('MQTT 3.1.1'),
  v5('MQTT 5.0');

  const MQTTVersion(this.label);
  final String label;
}
