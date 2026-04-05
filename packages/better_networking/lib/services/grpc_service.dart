import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:grpc_reflection/grpc_reflection.dart';

import '../models/grpc_request_model.dart';

/// Describes a single gRPC service discovered via reflection or descriptor.
class GrpcServiceInfo {
  final String serviceName;
  final List<GrpcMethodInfo> methods;

  const GrpcServiceInfo({required this.serviceName, required this.methods});
}

/// Describes a single gRPC method.
class GrpcMethodInfo {
  final String methodName;
  final String fullServiceName;
  final bool clientStreaming;
  final bool serverStreaming;
  final String inputTypeName;
  final String outputTypeName;

  const GrpcMethodInfo({
    required this.methodName,
    required this.fullServiceName,
    required this.clientStreaming,
    required this.serverStreaming,
    required this.inputTypeName,
    required this.outputTypeName,
  });

  String get fullPath => '/$fullServiceName/$methodName';

  GrpcCallType get callType {
    if (clientStreaming && serverStreaming) return GrpcCallType.bidirectional;
    if (clientStreaming) return GrpcCallType.clientStreaming;
    if (serverStreaming) return GrpcCallType.serverStreaming;
    return GrpcCallType.unary;
  }
}

/// Holds the complete type registry for describing gRPC message fields.
class GrpcTypeRegistry {
  final Map<String, DescriptorProto> _messageTypes = {};
  final Map<String, EnumDescriptorProto> _enumTypes = {};

  void registerFile(FileDescriptorProto file) {
    final packagePrefix = file.package.isNotEmpty ? '.${file.package}' : '';
    _registerMessages(file.messageType, packagePrefix);
    _registerEnums(file.enumType, packagePrefix);
  }

  void _registerMessages(List<DescriptorProto> messages, String prefix) {
    for (final msg in messages) {
      final fullName = '$prefix.${msg.name}';
      _messageTypes[fullName] = msg;
      _registerMessages(msg.nestedType, fullName);
      _registerEnums(msg.enumType, fullName);
    }
  }

  void _registerEnums(List<EnumDescriptorProto> enums, String prefix) {
    for (final e in enums) {
      final fullName = '$prefix.${e.name}';
      _enumTypes[fullName] = e;
    }
  }

  DescriptorProto? findMessage(String fullName) => _messageTypes[fullName];
  EnumDescriptorProto? findEnum(String fullName) => _enumTypes[fullName];
}

/// Result of a gRPC call.
class GrpcCallResult {
  final int? statusCode;
  final String? statusMessage;
  final Map<String, String> responseHeaders;
  final Map<String, String> responseTrailers;
  final List<Uint8List> responseMessages;
  final Duration? duration;
  final String? error;

  const GrpcCallResult({
    this.statusCode,
    this.statusMessage,
    this.responseHeaders = const {},
    this.responseTrailers = const {},
    this.responseMessages = const [],
    this.duration,
    this.error,
  });

  bool get isError => error != null || (statusCode != null && statusCode != 0);
}

/// Identity [ClientMethod] that passes raw bytes through without
/// serialization/deserialization.
ClientMethod<List<int>, List<int>> _rawMethod(String path) {
  return ClientMethod<List<int>, List<int>>(
    path,
    (bytes) => bytes,
    (bytes) => bytes,
  );
}

/// Manages a gRPC channel and performs reflection / invocations.
class GrpcClientManager {
  GrpcClientManager._();

  static final Map<String, GrpcClientManager> _instances = {};

  static GrpcClientManager getOrCreate(String requestId) {
    return _instances.putIfAbsent(requestId, () => GrpcClientManager._());
  }

  static void remove(String requestId) {
    final manager = _instances.remove(requestId);
    manager?._dispose();
  }

  ClientChannel? _channel;
  List<GrpcServiceInfo> _services = [];
  GrpcTypeRegistry? _typeRegistry;
  bool _isConnected = false;

  bool get isConnected => _isConnected && _channel != null;
  List<GrpcServiceInfo> get services => List.unmodifiable(_services);
  GrpcTypeRegistry? get typeRegistry => _typeRegistry;

  /// Connect to a gRPC server and discover services.
  Future<void> connect(GrpcRequestModel config) async {
    await _dispose();

    final host = config.host.trim();
    if (host.isEmpty) {
      throw const GrpcError.invalidArgument('Host cannot be empty');
    }

    final channelOptions = ChannelOptions(
      credentials: config.useTls
          ? const ChannelCredentials.secure()
          : const ChannelCredentials.insecure(),
      connectionTimeout: const Duration(seconds: 10),
    );

    // Main channel — used exclusively for actual RPC invocations.
    _channel = ClientChannel(
      host,
      port: config.port,
      options: channelOptions,
    );

    if (config.useReflection) {
      // Use a SEPARATE ephemeral channel for reflection so that stream
      // cancellations (RST_STREAM) from .first calls cannot cause the server
      // to GOAWAY the main channel before we even invoke a method.
      final reflectionChannel = ClientChannel(
        host,
        port: config.port,
        options: channelOptions,
      );
      try {
        await _discoverViaReflection(reflectionChannel);
      } finally {
        await reflectionChannel.shutdown();
      }
    } else if (config.descriptorFileBytes != null) {
      _loadFromDescriptor(config.descriptorFileBytes!);
    }

    _isConnected = true;
  }

  /// Discover services via gRPC server reflection.
  Future<void> _discoverViaReflection(ClientChannel channel) async {
    final reflectionClient = ServerReflectionClient(channel);

    // List all services
    final listRequest = ServerReflectionRequest()..listServices = '';

    final responseStream = reflectionClient.serverReflectionInfo(
      Stream.value(listRequest),
    );

    final listResponse = await responseStream.first;
    final serviceNames = listResponse.listServicesResponse.service
        .map((s) => s.name)
        .where((name) => name != 'grpc.reflection.v1alpha.ServerReflection')
        .toList();

    _typeRegistry = GrpcTypeRegistry();
    _services = [];

    // For each service, get file descriptor
    for (final serviceName in serviceNames) {
      final fileRequest = ServerReflectionRequest()
        ..fileContainingSymbol = serviceName;

      final fileStream = reflectionClient.serverReflectionInfo(
        Stream.value(fileRequest),
      );

      final fileResponse = await fileStream.first;
      final fdBytes = fileResponse.fileDescriptorResponse.fileDescriptorProto;

      for (final bytes in fdBytes) {
        final fdProto = FileDescriptorProto.fromBuffer(bytes);
        _typeRegistry!.registerFile(fdProto);

        for (final service in fdProto.service) {
          final fullServiceName = fdProto.package.isNotEmpty
              ? '${fdProto.package}.${service.name}'
              : service.name;

          if (fullServiceName != serviceName) continue;

          final methods = service.method.map((m) {
            return GrpcMethodInfo(
              methodName: m.name,
              fullServiceName: fullServiceName,
              clientStreaming: m.clientStreaming,
              serverStreaming: m.serverStreaming,
              inputTypeName: m.inputType,
              outputTypeName: m.outputType,
            );
          }).toList();

          _services.add(GrpcServiceInfo(
            serviceName: fullServiceName,
            methods: methods,
          ));
        }
      }
    }
  }

  /// Load service definitions from a FileDescriptorSet binary.
  void _loadFromDescriptor(Uint8List descriptorBytes) {
    final descriptorSet = FileDescriptorSet.fromBuffer(descriptorBytes);

    _typeRegistry = GrpcTypeRegistry();
    _services = [];

    for (final file in descriptorSet.file) {
      _typeRegistry!.registerFile(file);

      for (final service in file.service) {
        final fullServiceName = file.package.isNotEmpty
            ? '${file.package}.${service.name}'
            : service.name;

        final methods = service.method.map((m) {
          return GrpcMethodInfo(
            methodName: m.name,
            fullServiceName: fullServiceName,
            clientStreaming: m.clientStreaming,
            serverStreaming: m.serverStreaming,
            inputTypeName: m.inputType,
            outputTypeName: m.outputType,
          );
        }).toList();

        _services.add(GrpcServiceInfo(
          serviceName: fullServiceName,
          methods: methods,
        ));
      }
    }
  }

  /// Invoke a unary gRPC method.
  Future<GrpcCallResult> callUnary({
    required GrpcMethodInfo method,
    required Uint8List requestBytes,
    List<GrpcMetadataEntry> metadata = const [],
  }) async {
    if (_channel == null) {
      return const GrpcCallResult(error: 'Not connected');
    }

    final clientMethod = _rawMethod(method.fullPath);
    final callOptions = CallOptions(
      metadata: _buildMetadata(metadata),
      timeout: const Duration(seconds: 30),
    );

    final stopwatch = Stopwatch()..start();

    try {
      final call = _channel!.createCall(
        clientMethod,
        Stream.value(requestBytes),
        callOptions,
      );

      final responseFuture = ResponseFuture<List<int>>(call);
      final responseBytes = await responseFuture;
      stopwatch.stop();

      final headers = await call.headers;
      final trailers = await call.trailers;

      return GrpcCallResult(
        statusCode: 0,
        statusMessage: 'OK',
        responseHeaders: headers,
        responseTrailers: trailers,
        responseMessages: [Uint8List.fromList(responseBytes)],
        duration: stopwatch.elapsed,
      );
    } on GrpcError catch (e) {
      stopwatch.stop();
      return GrpcCallResult(
        statusCode: e.code,
        statusMessage: e.message,
        error: 'gRPC Error ${e.code}: ${e.message}',
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      return GrpcCallResult(
        error: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Invoke a server-streaming gRPC method.
  Stream<GrpcCallResult> callServerStreaming({
    required GrpcMethodInfo method,
    required Uint8List requestBytes,
    List<GrpcMetadataEntry> metadata = const [],
  }) async* {
    if (_channel == null) {
      yield const GrpcCallResult(error: 'Not connected');
      return;
    }

    final clientMethod = _rawMethod(method.fullPath);
    final callOptions = CallOptions(
      metadata: _buildMetadata(metadata),
    );

    final stopwatch = Stopwatch()..start();

    try {
      final call = _channel!.createCall(
        clientMethod,
        Stream.value(requestBytes),
        callOptions,
      );

      await for (final responseBytes in call.response) {
        yield GrpcCallResult(
          statusCode: 0,
          responseMessages: [Uint8List.fromList(responseBytes)],
          duration: stopwatch.elapsed,
        );
      }

      stopwatch.stop();
      final trailers = await call.trailers;
      yield GrpcCallResult(
        statusCode: 0,
        statusMessage: 'Stream completed',
        responseTrailers: trailers,
        duration: stopwatch.elapsed,
      );
    } on GrpcError catch (e) {
      stopwatch.stop();
      yield GrpcCallResult(
        statusCode: e.code,
        statusMessage: e.message,
        error: 'gRPC Error ${e.code}: ${e.message}',
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      yield GrpcCallResult(
        error: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Start a client-streaming gRPC call.
  GrpcClientStreamController startClientStreaming({
    required GrpcMethodInfo method,
    List<GrpcMetadataEntry> metadata = const [],
  }) {
    if (_channel == null) {
      throw const GrpcError.unavailable('Not connected');
    }

    final clientMethod = _rawMethod(method.fullPath);
    final callOptions = CallOptions(
      metadata: _buildMetadata(metadata),
    );

    final requestController = StreamController<List<int>>();

    final call = _channel!.createCall(
      clientMethod,
      requestController.stream,
      callOptions,
    );

    return GrpcClientStreamController(
      requestSink: requestController,
      call: call,
    );
  }

  /// Start a bidirectional streaming gRPC call.
  GrpcBidiStreamController startBidiStreaming({
    required GrpcMethodInfo method,
    List<GrpcMetadataEntry> metadata = const [],
  }) {
    if (_channel == null) {
      throw const GrpcError.unavailable('Not connected');
    }

    final clientMethod = _rawMethod(method.fullPath);
    final callOptions = CallOptions(
      metadata: _buildMetadata(metadata),
    );

    final requestController = StreamController<List<int>>();

    final call = _channel!.createCall(
      clientMethod,
      requestController.stream,
      callOptions,
    );

    return GrpcBidiStreamController(
      requestSink: requestController,
      call: call,
    );
  }

  Map<String, String> _buildMetadata(List<GrpcMetadataEntry> entries) {
    final map = <String, String>{};
    for (final entry in entries) {
      if (entry.key.isNotEmpty) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }

  Future<void> disconnect() async {
    await _dispose();
  }

  Future<void> _dispose() async {
    _isConnected = false;
    _services = [];
    _typeRegistry = null;
    await _channel?.shutdown();
    _channel = null;
  }
}

/// Controller for client-streaming calls.
class GrpcClientStreamController {
  final StreamController<List<int>> requestSink;
  final ClientCall<List<int>, List<int>> call;

  GrpcClientStreamController({
    required this.requestSink,
    required this.call,
  });

  void sendMessage(Uint8List bytes) {
    requestSink.add(bytes);
  }

  Future<GrpcCallResult> closeAndReceive() async {
    final stopwatch = Stopwatch()..start();
    try {
      await requestSink.close();
      final responseFuture = ResponseFuture<List<int>>(call);
      final responseBytes = await responseFuture;
      stopwatch.stop();

      final trailers = await call.trailers;
      return GrpcCallResult(
        statusCode: 0,
        statusMessage: 'OK',
        responseMessages: [Uint8List.fromList(responseBytes)],
        responseTrailers: trailers,
        duration: stopwatch.elapsed,
      );
    } on GrpcError catch (e) {
      stopwatch.stop();
      return GrpcCallResult(
        statusCode: e.code,
        statusMessage: e.message,
        error: 'gRPC Error ${e.code}: ${e.message}',
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      return GrpcCallResult(
        error: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }

  void cancel() {
    requestSink.close();
    call.cancel();
  }
}

/// Controller for bidirectional streaming calls.
class GrpcBidiStreamController {
  final StreamController<List<int>> requestSink;
  final ClientCall<List<int>, List<int>> call;

  GrpcBidiStreamController({
    required this.requestSink,
    required this.call,
  });

  void sendMessage(Uint8List bytes) {
    requestSink.add(bytes);
  }

  Stream<List<int>> get responseStream => call.response;

  void closeSend() {
    requestSink.close();
  }

  void cancel() {
    requestSink.close();
    call.cancel();
  }
}

// ---------------------------------------------------------------------------
// Dynamic Protobuf JSON → Binary Codec
// Direct wire-format encoding — does NOT use PbFieldType or CodedBufferWriter.
// ---------------------------------------------------------------------------

// Wire types
const int _kWireVarint = 0; // int32, int64, uint32/64, sint32/64, bool, enum
const int _kWire64Bit = 1; // fixed64, sfixed64, double
const int _kWireLen = 2; // string, bytes, embedded messages
const int _kWire32Bit = 5; // fixed32, sfixed32, float

/// Minimal byte buffer used by the encoder.
class _Buf {
  final List<int> _b = [];
  void addByte(int v) => _b.add(v & 0xFF);
  void addAll(List<int> bytes) => _b.addAll(bytes);
  int get length => _b.length;
  Uint8List toBytes() => Uint8List.fromList(_b);
}

/// Write a base-128 varint (unsigned 64-bit value) to [buf].
void _writeVarint(_Buf buf, int value) {
  // Treat as unsigned via >>> 
  var v = value;
  while (v > 0x7F || v < 0) {
    buf.addByte((v & 0x7F) | 0x80);
    v = v >>> 7;
  }
  buf.addByte(v);
}

/// Write a 64-bit varint using fixnum's Int64 (handles full 64-bit range).
void _writeVarint64(_Buf buf, Int64 value) {
  var v = value;
  while (v > Int64(0x7F) || v < Int64.ZERO) {
    buf.addByte(((v & Int64(0x7F)) | Int64(0x80)).toInt());
    v = v.shiftRightUnsigned(7);
  }
  buf.addByte(v.toInt());
}

void _writeTag(_Buf buf, int fieldNumber, int wireType) {
  _writeVarint(buf, (fieldNumber << 3) | wireType);
}

void _writeLengthDelimited(_Buf buf, int fieldNumber, List<int> bytes) {
  _writeTag(buf, fieldNumber, _kWireLen);
  _writeVarint(buf, bytes.length);
  buf.addAll(bytes);
}

/// Encode a JSON map into protobuf binary using the given message descriptor.
Uint8List jsonToProtobuf(
  Map<String, dynamic> json,
  DescriptorProto descriptor,
  GrpcTypeRegistry typeRegistry,
) {
  return _encodeMessage(json, descriptor, typeRegistry);
}

Uint8List _encodeMessage(
  Map<String, dynamic> json,
  DescriptorProto descriptor,
  GrpcTypeRegistry typeRegistry,
) {
  final buf = _Buf();
  for (final field in descriptor.field) {
    final value = json[field.name] ?? json[field.jsonName];
    if (value == null) continue;

    final isRepeated =
        field.label == FieldDescriptorProto_Label.LABEL_REPEATED &&
            value is List;

    if (isRepeated) {
      for (final item in value as Iterable) {
        _encodeField(buf, field, item, typeRegistry);
      }
    } else {
      _encodeField(buf, field, value, typeRegistry);
    }
  }
  return buf.toBytes();
}

void _encodeField(
  _Buf buf,
  FieldDescriptorProto field,
  dynamic value,
  GrpcTypeRegistry typeRegistry,
) {
  final fn = field.number;
  switch (field.type) {
    // ---- Varint wire type (0) ----
    case FieldDescriptorProto_Type.TYPE_BOOL:
      _writeTag(buf, fn, _kWireVarint);
      _writeVarint(buf, (value as bool) ? 1 : 0);

    case FieldDescriptorProto_Type.TYPE_ENUM:
    case FieldDescriptorProto_Type.TYPE_INT32:
    case FieldDescriptorProto_Type.TYPE_UINT32:
      _writeTag(buf, fn, _kWireVarint);
      // Negative int32 must be sign-extended to 64-bit per proto spec.
      final v = (value as num).toInt();
      _writeVarint64(buf, Int64(v));

    case FieldDescriptorProto_Type.TYPE_SINT32:
      // ZigZag: maps signed int to unsigned: 0→0, -1→1, 1→2, -2→3, ...
      _writeTag(buf, fn, _kWireVarint);
      final v = (value as num).toInt();
      _writeVarint(buf, (v << 1) ^ (v >> 31));

    case FieldDescriptorProto_Type.TYPE_INT64:
    case FieldDescriptorProto_Type.TYPE_UINT64:
      _writeTag(buf, fn, _kWireVarint);
      _writeVarint64(buf, _parseInt64(value));

    case FieldDescriptorProto_Type.TYPE_SINT64:
      _writeTag(buf, fn, _kWireVarint);
      final v = _parseInt64(value);
      _writeVarint64(buf, (v << 1) ^ (v >> 63));

    // ---- Fixed 32-bit wire type (5) ----
    case FieldDescriptorProto_Type.TYPE_FLOAT:
      _writeTag(buf, fn, _kWire32Bit);
      final bd = ByteData(4)
        ..setFloat32(0, (value as num).toDouble(), Endian.little);
      buf.addAll(bd.buffer.asUint8List());

    case FieldDescriptorProto_Type.TYPE_FIXED32:
    case FieldDescriptorProto_Type.TYPE_SFIXED32:
      _writeTag(buf, fn, _kWire32Bit);
      final bd = ByteData(4)
        ..setUint32(0, (value as num).toInt() & 0xFFFFFFFF, Endian.little);
      buf.addAll(bd.buffer.asUint8List());

    // ---- Fixed 64-bit wire type (1) ----
    case FieldDescriptorProto_Type.TYPE_DOUBLE:
      _writeTag(buf, fn, _kWire64Bit);
      final bd = ByteData(8)
        ..setFloat64(0, (value as num).toDouble(), Endian.little);
      buf.addAll(bd.buffer.asUint8List());

    case FieldDescriptorProto_Type.TYPE_FIXED64:
    case FieldDescriptorProto_Type.TYPE_SFIXED64:
      _writeTag(buf, fn, _kWire64Bit);
      final v = _parseInt64(value);
      final bd = ByteData(8)
        ..setInt32(0, v.toUnsigned(32).toInt(), Endian.little)
        ..setInt32(4, (v >> 32).toUnsigned(32).toInt(), Endian.little);
      buf.addAll(bd.buffer.asUint8List());

    // ---- Length-delimited wire type (2) ----
    case FieldDescriptorProto_Type.TYPE_STRING:
      final bytes = utf8.encode(value as String);
      _writeLengthDelimited(buf, fn, bytes);

    case FieldDescriptorProto_Type.TYPE_BYTES:
      // Normalize base64: handle padded, unpadded, or URL-safe variants.
      final bytes = base64Decode(base64.normalize(value as String));
      _writeLengthDelimited(buf, fn, bytes);

    case FieldDescriptorProto_Type.TYPE_MESSAGE:
      final msgDescriptor = typeRegistry.findMessage(field.typeName);
      if (msgDescriptor != null && value is Map<String, dynamic>) {
        final subBytes = _encodeMessage(value, msgDescriptor, typeRegistry);
        _writeLengthDelimited(buf, fn, subBytes);
      }

    default:
      break;
  }
}

Int64 _parseInt64(dynamic value) {
  if (value is int) return Int64(value);
  if (value is String) return Int64.parseInt(value);
  return Int64.ZERO;
}

/// Decode protobuf binary into a JSON-like map using descriptor metadata.
Map<String, dynamic> protobufToJson(
  Uint8List bytes,
  DescriptorProto descriptor,
  GrpcTypeRegistry typeRegistry,
) {
  final unknownFields = UnknownFieldSet();
  final reader = CodedBufferReader(bytes);
  unknownFields.mergeFromCodedBufferReader(reader);

  final result = <String, dynamic>{};

  for (final field in descriptor.field) {
    final unknownField = unknownFields.getField(field.number);
    if (unknownField == null) continue;

    final isRepeated =
        field.label == FieldDescriptorProto_Label.LABEL_REPEATED;

    switch (field.type) {
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
        final values =
            unknownField.fixed64s.map((v) => _bitsToDouble(v)).toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_FLOAT:
        final values =
            unknownField.fixed32s.map((v) => _bitsToFloat(v)).toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_INT64:
      case FieldDescriptorProto_Type.TYPE_UINT64:
        final values =
            unknownField.varints.map((v) => v.toString()).toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_SINT64:
        // Un-zigzag
        final values = unknownField.varints
            .map((v) => (v.shiftRightUnsigned(1) ^ -(v & Int64.ONE)).toString())
            .toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_FIXED64:
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        final values =
            unknownField.fixed64s.map((v) => v.toString()).toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_INT32:
      case FieldDescriptorProto_Type.TYPE_UINT32:
      case FieldDescriptorProto_Type.TYPE_ENUM:
        final values =
            unknownField.varints.map((v) => v.toInt()).toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_SINT32:
        // Un-zigzag
        final values = unknownField.varints
            .map((v) => (v.toInt() >>> 1) ^ -(v.toInt() & 1))
            .toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_FIXED32:
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        final values =
            unknownField.fixed32s.map((v) => v).toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_BOOL:
        final values =
            unknownField.varints.map((v) => v.toInt() != 0).toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_STRING:
        final values = unknownField.lengthDelimited
            .map((v) => utf8.decode(v))
            .toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_BYTES:
        final values = unknownField.lengthDelimited
            .map((v) => base64Encode(v))
            .toList();
        result[field.name] = isRepeated ? values : values.firstOrNull;
      case FieldDescriptorProto_Type.TYPE_MESSAGE:
        final msgDescriptor = typeRegistry.findMessage(field.typeName);
        if (msgDescriptor != null) {
          final values = unknownField.lengthDelimited
              .map((v) => protobufToJson(
                  Uint8List.fromList(v), msgDescriptor, typeRegistry))
              .toList();
          result[field.name] = isRepeated ? values : values.firstOrNull;
        }
      default:
        break;
    }
  }

  return result;
}

double _bitsToDouble(Int64 bits) {
  final bd = ByteData(8);
  bd.setInt64(0, bits.toInt(), Endian.little);
  return bd.getFloat64(0, Endian.little);
}

double _bitsToFloat(int bits) {
  final bd = ByteData(4);
  bd.setInt32(0, bits, Endian.little);
  return bd.getFloat32(0, Endian.little);
}

