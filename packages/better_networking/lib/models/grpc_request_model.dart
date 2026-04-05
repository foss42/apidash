import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'grpc_request_model.g.dart';

/// The four gRPC call types, derived from
/// `MethodDescriptorProto.client_streaming` + `server_streaming`.
enum GrpcCallType {
  unary("Unary"),
  serverStreaming("Server Streaming"),
  clientStreaming("Client Streaming"),
  bidirectional("Bidirectional");

  const GrpcCallType(this.label);
  final String label;
}

/// A single metadata (header) entry sent with the gRPC call.
@JsonSerializable()
class GrpcMetadataEntry {
  final String key;
  final String value;

  const GrpcMetadataEntry({
    this.key = "",
    this.value = "",
  });

  factory GrpcMetadataEntry.fromJson(Map<String, dynamic> json) =>
      _$GrpcMetadataEntryFromJson(json);
  Map<String, dynamic> toJson() => _$GrpcMetadataEntryToJson(this);

  GrpcMetadataEntry copyWith({String? key, String? value}) {
    return GrpcMetadataEntry(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrpcMetadataEntry &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  int get hashCode => Object.hash(key, value);

  @override
  String toString() => 'GrpcMetadataEntry(key: $key, value: $value)';
}

/// Persistent configuration for a single gRPC request.
///
/// Stored inside [RequestModel.grpcRequestModel]. Follows the same pattern
/// as [MqttRequestModel]: plain `@JsonSerializable` with hand-written
/// `copyWith`, `==`, and `hashCode`.
@JsonSerializable(explicitToJson: true, anyMap: true)
class GrpcRequestModel {
  final String host;
  final int port;
  final bool useTls;
  final String? selectedService;
  final String? selectedMethod;
  final String requestBody;
  final List<GrpcMetadataEntry> metadata;
  final bool useReflection;

  /// Raw bytes of a `FileDescriptorSet` (`.pb` file) imported by the user.
  /// `null` when using server reflection instead of a file.
  @JsonKey(fromJson: _uint8ListFromJson, toJson: _uint8ListToJson)
  final Uint8List? descriptorFileBytes;

  const GrpcRequestModel({
    this.host = "",
    this.port = 50051,
    this.useTls = false,
    this.selectedService,
    this.selectedMethod,
    this.requestBody = "{}",
    this.metadata = const <GrpcMetadataEntry>[],
    this.useReflection = true,
    this.descriptorFileBytes,
  });

  factory GrpcRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GrpcRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$GrpcRequestModelToJson(this);

  String get hostPort => "$host:$port";

  GrpcRequestModel copyWith({
    String? host,
    int? port,
    bool? useTls,
    Object? selectedService = _sentinel,
    Object? selectedMethod = _sentinel,
    String? requestBody,
    List<GrpcMetadataEntry>? metadata,
    bool? useReflection,
    Object? descriptorFileBytes = _sentinel,
  }) {
    return GrpcRequestModel(
      host: host ?? this.host,
      port: port ?? this.port,
      useTls: useTls ?? this.useTls,
      selectedService: identical(selectedService, _sentinel)
          ? this.selectedService
          : selectedService as String?,
      selectedMethod: identical(selectedMethod, _sentinel)
          ? this.selectedMethod
          : selectedMethod as String?,
      requestBody: requestBody ?? this.requestBody,
      metadata: metadata ?? this.metadata,
      useReflection: useReflection ?? this.useReflection,
      descriptorFileBytes: identical(descriptorFileBytes, _sentinel)
          ? this.descriptorFileBytes
          : descriptorFileBytes as Uint8List?,
    );
  }

  static const _sentinel = Object();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrpcRequestModel &&
          runtimeType == other.runtimeType &&
          host == other.host &&
          port == other.port &&
          useTls == other.useTls &&
          selectedService == other.selectedService &&
          selectedMethod == other.selectedMethod &&
          requestBody == other.requestBody &&
          useReflection == other.useReflection &&
          _listEquals(metadata, other.metadata);

  @override
  int get hashCode => Object.hash(
        host,
        port,
        useTls,
        selectedService,
        selectedMethod,
        requestBody,
        useReflection,
        Object.hashAll(metadata),
      );

  @override
  String toString() =>
      'GrpcRequestModel(host: $host, port: $port, useTls: $useTls, '
      'service: $selectedService, method: $selectedMethod)';

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// JSON helpers for [Uint8List] fields (stored as base64 strings).
Uint8List? _uint8ListFromJson(String? encoded) =>
    encoded == null ? null : base64Decode(encoded);
String? _uint8ListToJson(Uint8List? bytes) =>
    bytes == null ? null : base64Encode(bytes);
