import 'package:protobuf/protobuf.dart';
import 'package:apidash/models/protocols/grpc_model.dart';
import 'package:apidash/services/connection_manager.dart';

class GrpcMethodSchema {
  final String? inputType;
  final String? outputType;
  final DescriptorProto? inputDescriptor;
  final DescriptorProto? outputDescriptor;
  final Map<String, DescriptorProto> allDescriptors;

  GrpcMethodSchema({
    this.inputType,
    this.outputType,
    this.inputDescriptor,
    this.outputDescriptor,
    required this.allDescriptors,
  });
}

// Minimal Descriptor definitions to extract method names
class FileDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('FileDescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'package')
    ..pc<DescriptorProto>(4, 'messageType', PbFieldType.PM, subBuilder: DescriptorProto.create)
    ..pc<ServiceDescriptorProto>(6, 'service', PbFieldType.PM, subBuilder: ServiceDescriptorProto.create)
    ..hasRequiredFields = false;

  FileDescriptorProto() : super();
  factory FileDescriptorProto.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static FileDescriptorProto create() => FileDescriptorProto._();
  FileDescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  FileDescriptorProto clone() => FileDescriptorProto()..mergeFromMessage(this);
  @override
  FileDescriptorProto createEmptyInstance() => create();
  
  String get package => $_getS(1, '');
  List<ServiceDescriptorProto> get service => $_getList(3);
  List<DescriptorProto> get messageType => $_getList(2);
}

class ServiceDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServiceDescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pc<MethodDescriptorProto>(2, 'method', PbFieldType.PM, subBuilder: MethodDescriptorProto.create)
    ..hasRequiredFields = false;

  ServiceDescriptorProto() : super();
  static ServiceDescriptorProto create() => ServiceDescriptorProto._();
  ServiceDescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  ServiceDescriptorProto clone() => ServiceDescriptorProto()..mergeFromMessage(this);
  @override
  ServiceDescriptorProto createEmptyInstance() => create();

  String get name => $_getS(0, '');
  List<MethodDescriptorProto> get method => $_getList(1);
}

class MethodDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('MethodDescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'inputType')
    ..aOS(3, 'outputType')
    ..hasRequiredFields = false;

  MethodDescriptorProto() : super();
  static MethodDescriptorProto create() => MethodDescriptorProto._();
  MethodDescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  MethodDescriptorProto clone() => MethodDescriptorProto()..mergeFromMessage(this);
  @override
  MethodDescriptorProto createEmptyInstance() => create();

  String get name => $_getS(0, '');
  String get inputType => $_getS(1, '');
  String get outputType => $_getS(2, '');
}

class DescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('DescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pc<FieldDescriptorProto>(2, 'field', PbFieldType.PM, subBuilder: FieldDescriptorProto.create)
    ..hasRequiredFields = false;

  DescriptorProto() : super();
  static DescriptorProto create() => DescriptorProto._();
  DescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  DescriptorProto clone() => DescriptorProto()..mergeFromMessage(this);
  @override
  DescriptorProto createEmptyInstance() => create();

  String get name => $_getS(0, '');
  List<FieldDescriptorProto> get field => $_getList(1);
}

class FieldDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('FieldDescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..a<int>(3, 'number', PbFieldType.O3)
    ..e<FieldDescriptorProto_Label>(4, 'label', PbFieldType.OE, defaultOrMaker: FieldDescriptorProto_Label.LABEL_OPTIONAL, valueOf: FieldDescriptorProto_Label.valueOf, enumValues: FieldDescriptorProto_Label.values)
    ..e<FieldDescriptorProto_Type>(5, 'type', PbFieldType.OE, defaultOrMaker: FieldDescriptorProto_Type.TYPE_DOUBLE, valueOf: FieldDescriptorProto_Type.valueOf, enumValues: FieldDescriptorProto_Type.values)
    ..aOS(6, 'typeName')
    ..hasRequiredFields = false;

  FieldDescriptorProto() : super();
  static FieldDescriptorProto create() => FieldDescriptorProto._();
  FieldDescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  FieldDescriptorProto clone() => FieldDescriptorProto()..mergeFromMessage(this);
  @override
  FieldDescriptorProto createEmptyInstance() => create();

  String get name => $_getS(0, '');
  int get number => $_getIZ(1);
  String get typeName => $_getS(4, '');
  FieldDescriptorProto_Type get type => $_getN(3);
}

class FieldDescriptorProto_Type extends ProtobufEnum {
  static const FieldDescriptorProto_Type TYPE_DOUBLE = FieldDescriptorProto_Type._(1, 'TYPE_DOUBLE');
  static const FieldDescriptorProto_Type TYPE_FLOAT = FieldDescriptorProto_Type._(2, 'TYPE_FLOAT');
  static const FieldDescriptorProto_Type TYPE_INT64 = FieldDescriptorProto_Type._(3, 'TYPE_INT64');
  static const FieldDescriptorProto_Type TYPE_UINT64 = FieldDescriptorProto_Type._(4, 'TYPE_UINT64');
  static const FieldDescriptorProto_Type TYPE_INT32 = FieldDescriptorProto_Type._(5, 'TYPE_INT32');
  static const FieldDescriptorProto_Type TYPE_FIXED64 = FieldDescriptorProto_Type._(6, 'TYPE_FIXED64');
  static const FieldDescriptorProto_Type TYPE_FIXED32 = FieldDescriptorProto_Type._(7, 'TYPE_FIXED32');
  static const FieldDescriptorProto_Type TYPE_BOOL = FieldDescriptorProto_Type._(8, 'TYPE_BOOL');
  static const FieldDescriptorProto_Type TYPE_STRING = FieldDescriptorProto_Type._(9, 'TYPE_STRING');
  static const FieldDescriptorProto_Type TYPE_GROUP = FieldDescriptorProto_Type._(10, 'TYPE_GROUP');
  static const FieldDescriptorProto_Type TYPE_MESSAGE = FieldDescriptorProto_Type._(11, 'TYPE_MESSAGE');
  static const FieldDescriptorProto_Type TYPE_BYTES = FieldDescriptorProto_Type._(12, 'TYPE_BYTES');
  static const FieldDescriptorProto_Type TYPE_UINT32 = FieldDescriptorProto_Type._(13, 'TYPE_UINT32');
  static const FieldDescriptorProto_Type TYPE_ENUM = FieldDescriptorProto_Type._(14, 'TYPE_ENUM');
  static const FieldDescriptorProto_Type TYPE_SFIXED32 = FieldDescriptorProto_Type._(15, 'TYPE_SFIXED32');
  static const FieldDescriptorProto_Type TYPE_SFIXED64 = FieldDescriptorProto_Type._(16, 'TYPE_SFIXED64');
  static const FieldDescriptorProto_Type TYPE_SINT32 = FieldDescriptorProto_Type._(17, 'TYPE_SINT32');
  static const FieldDescriptorProto_Type TYPE_SINT64 = FieldDescriptorProto_Type._(18, 'TYPE_SINT64');

  static const List<FieldDescriptorProto_Type> values = <FieldDescriptorProto_Type> [
    TYPE_DOUBLE, TYPE_FLOAT, TYPE_INT64, TYPE_UINT64, TYPE_INT32, TYPE_FIXED64, TYPE_FIXED32, TYPE_BOOL, TYPE_STRING, TYPE_GROUP, TYPE_MESSAGE, TYPE_BYTES, TYPE_UINT32, TYPE_ENUM, TYPE_SFIXED32, TYPE_SFIXED64, TYPE_SINT32, TYPE_SINT64,
  ];

  static final Map<int, FieldDescriptorProto_Type> _byValue = ProtobufEnum.initByValue(values);
  static FieldDescriptorProto_Type? valueOf(int value) => _byValue[value];

  const FieldDescriptorProto_Type._(int v, String n) : super(v, n);
}

class FieldDescriptorProto_Label extends ProtobufEnum {
  static const FieldDescriptorProto_Label LABEL_OPTIONAL = FieldDescriptorProto_Label._(1, 'LABEL_OPTIONAL');
  static const FieldDescriptorProto_Label LABEL_REQUIRED = FieldDescriptorProto_Label._(2, 'LABEL_REQUIRED');
  static const FieldDescriptorProto_Label LABEL_REPEATED = FieldDescriptorProto_Label._(3, 'LABEL_REPEATED');

  static const List<FieldDescriptorProto_Label> values = <FieldDescriptorProto_Label> [
    LABEL_OPTIONAL, LABEL_REQUIRED, LABEL_REPEATED,
  ];

  static final Map<int, FieldDescriptorProto_Label> _byValue = ProtobufEnum.initByValue(values);
  static FieldDescriptorProto_Label? valueOf(int value) => _byValue[value];

  const FieldDescriptorProto_Label._(int v, String n) : super(v, n);
}

class ServerReflectionRequest extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServerReflectionRequest',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, 'host')
    ..aOS(3, 'fileByFilename')
    ..aOS(4, 'fileBySymbol')
    ..aOS(7, 'listServices')
    ..hasRequiredFields = false;

  ServerReflectionRequest() : super();
  factory ServerReflectionRequest.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static ServerReflectionRequest create() => ServerReflectionRequest._();
  ServerReflectionRequest._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ServerReflectionRequest clone() => ServerReflectionRequest()..mergeFromMessage(this);
  @override
  ServerReflectionRequest createEmptyInstance() => create();

  String get host => $_getS(0, '');
  set host(String v) => $_setString(0, v);

  String get fileByFilename => $_getS(1, '');
  set fileByFilename(String v) => $_setString(1, v);

  String get fileBySymbol => $_getS(2, '');
  set fileBySymbol(String v) => $_setString(2, v);

  String get listServices => $_getS(3, '');
  set listServices(String v) => $_setString(3, v);
}

class ListServiceResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ListServiceResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..pc<ServiceResponse>(1, 'service', PbFieldType.PM, subBuilder: ServiceResponse.create)
    ..hasRequiredFields = false;

  ListServiceResponse() : super();
  static ListServiceResponse create() => ListServiceResponse._();
  ListServiceResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ListServiceResponse clone() => ListServiceResponse()..mergeFromMessage(this);
  @override
  ListServiceResponse createEmptyInstance() => create();

  List<ServiceResponse> get service => $_getList(0);
}

class ServiceResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServiceResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, 'name')
    ..hasRequiredFields = false;

  ServiceResponse() : super();
  factory ServiceResponse.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static ServiceResponse create() => ServiceResponse._();
  ServiceResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ServiceResponse clone() => ServiceResponse()..mergeFromMessage(this);
  @override
  ServiceResponse createEmptyInstance() => create();

  String get name => $_getS(0, '');
}

class FileDescriptorResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('FileDescriptorResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..p<List<int>>(1, 'fileDescriptorProto', PbFieldType.PY)
    ..hasRequiredFields = false;

  FileDescriptorResponse() : super();
  static FileDescriptorResponse create() => FileDescriptorResponse._();
  FileDescriptorResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  FileDescriptorResponse clone() => FileDescriptorResponse()..mergeFromMessage(this);
  @override
  FileDescriptorResponse createEmptyInstance() => create();

  List<List<int>> get fileDescriptorProto => $_getList(0);
}

class ServerReflectionResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServerReflectionResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, 'validHost')
    ..aOM<ServerReflectionRequest>(2, 'originalRequest', subBuilder: ServerReflectionRequest.create)
    ..aOM<FileDescriptorResponse>(4, 'fileDescriptorResponse', subBuilder: FileDescriptorResponse.create)
    ..aOM<ListServiceResponse>(6, 'listServicesResponse', subBuilder: ListServiceResponse.create)
    ..hasRequiredFields = false;

  ServerReflectionResponse() : super();
  factory ServerReflectionResponse.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static ServerReflectionResponse create() => ServerReflectionResponse._();
  ServerReflectionResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ServerReflectionResponse clone() => ServerReflectionResponse()..mergeFromMessage(this);
  @override
  ServerReflectionResponse createEmptyInstance() => create();

  ListServiceResponse get listServicesResponse => $_getN(3);
  FileDescriptorResponse get fileDescriptorResponse => $_getN(2);
}

class GrpcReflectionService {
  static Future<List<String>> listServices(String requestId, GrpcRequestModel model) async {
    final request = ServerReflectionRequest()..host = model.host..listServices = "";
    
    try {
      final call = ConnectionManager.instance.callGrpcMethod(
        requestId,
        "grpc.reflection.v1alpha.ServerReflection",
        "ServerReflectionInfo",
        request.writeToBuffer(),
      );

      final services = <String>[];
      await for (final responseBytes in call) {
        final response = ServerReflectionResponse.fromBuffer(responseBytes);
        if (response.hasField(6)) {
          for (final service in response.listServicesResponse.service) {
            services.add(service.name);
          }
          break; 
        }
      }
      return services;
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, List<String>>> getMethodsForService(String requestId, GrpcRequestModel model, String serviceName) async {
    final request = ServerReflectionRequest()..host = model.host..fileBySymbol = serviceName;
    
    try {
      final call = ConnectionManager.instance.callGrpcMethod(
        requestId,
        "grpc.reflection.v1alpha.ServerReflection",
        "ServerReflectionInfo",
        request.writeToBuffer(),
      );

      final Map<String, List<String>> result = {};
      
      await for (final responseBytes in call) {
        final response = ServerReflectionResponse.fromBuffer(responseBytes);
        if (response.hasField(4)) {
          for (final protoBytes in response.fileDescriptorResponse.fileDescriptorProto) {
            final fileProto = FileDescriptorProto.fromBuffer(protoBytes);
            final package = fileProto.package;
            
            for (final service in fileProto.service) {
              final fullName = package.isNotEmpty ? "$package.${service.name}" : service.name;
              if (fullName == serviceName) {
                final methods = service.method.map((m) => m.name).toList();
                result[fullName] = methods;
              }
            }
          }
          if (result.isNotEmpty) break;
        }
      }
      return result;
    } catch (e) {
      return {};
    }
  }

  static Future<GrpcMethodSchema?> getMethodSchema(String requestId, GrpcRequestModel model, String serviceName, String methodName) async {
    final request = ServerReflectionRequest()..host = model.host..fileBySymbol = serviceName;
    
    try {
      final call = ConnectionManager.instance.callGrpcMethod(
        requestId,
        "grpc.reflection.v1alpha.ServerReflection",
        "ServerReflectionInfo",
        request.writeToBuffer(),
      );

      String? inputType;
      String? outputType;
      final List<FileDescriptorProto> fileProtos = [];
      
      await for (final responseBytes in call) {
        final response = ServerReflectionResponse.fromBuffer(responseBytes);
        if (response.hasField(4)) {
          for (final protoBytes in response.fileDescriptorResponse.fileDescriptorProto) {
            final fileProto = FileDescriptorProto.fromBuffer(protoBytes);
            fileProtos.add(fileProto);
            final package = fileProto.package;
            
            for (final service in fileProto.service) {
              final fullName = package.isNotEmpty ? "$package.${service.name}" : service.name;
              if (fullName == serviceName) {
                for (final method in service.method) {
                  if (method.name == methodName) {
                    inputType = method.inputType;
                    outputType = method.outputType;
                    if (inputType.startsWith('.')) inputType = inputType.substring(1);
                    if (outputType.startsWith('.')) outputType = outputType.substring(1);
                    break;
                  }
                }
              }
            }
          }
          if (inputType != null && outputType != null) break;
        }
      }

      if (inputType == null || outputType == null) return null;

      final allDescriptors = <String, DescriptorProto>{};
      for (final fp in fileProtos) {
        final package = fp.package;
        for (final msg in fp.messageType) {
          final fullName = package.isNotEmpty ? "$package.${msg.name}" : msg.name;
          allDescriptors[fullName] = msg;
        }
      }

      for (final type in [inputType, outputType]) {
        if (!allDescriptors.containsKey(type)) {
          final requestMsg = ServerReflectionRequest()..host = model.host..fileBySymbol = type;
          final callMsg = ConnectionManager.instance.callGrpcMethod(
            requestId,
            "grpc.reflection.v1alpha.ServerReflection",
            "ServerReflectionInfo",
            requestMsg.writeToBuffer(),
          );

          await for (final responseBytes in callMsg) {
            final response = ServerReflectionResponse.fromBuffer(responseBytes);
            if (response.hasField(4)) {
              for (final protoBytes in response.fileDescriptorResponse.fileDescriptorProto) {
                final fileProto = FileDescriptorProto.fromBuffer(protoBytes);
                final package = fileProto.package;
                for (final msg in fileProto.messageType) {
                  final fullName = package.isNotEmpty ? "$package.${msg.name}" : msg.name;
                  allDescriptors[fullName] = msg;
                }
              }
            }
          }
        }
      }

      return GrpcMethodSchema(
        inputType: inputType,
        outputType: outputType,
        inputDescriptor: allDescriptors[inputType],
        outputDescriptor: allDescriptors[outputType],
        allDescriptors: allDescriptors,
      );

    } catch (e) {
      print("Error in getMethodSchema: $e");
      return null;
    }
  }

  static Future<List<GrpcParameterModel>> getParamsForMethod(String requestId, GrpcRequestModel model, String serviceName, String methodName) async {
    try {
      final schema = await getMethodSchema(requestId, model, serviceName, methodName);
      if (schema == null || schema.inputDescriptor == null) return [];

      return schema.inputDescriptor!.field.map((f) => GrpcParameterModel(
        name: f.name,
        tag: f.number,
        type: _mapTypeToString(f.type),
        enabled: true,
        value: "",
      )).toList();
    } catch (e) {
      print("Error in getParamsForMethod: $e");
      return [];
    }
  }

  static String _mapTypeToString(FieldDescriptorProto_Type type) {
    if (type == FieldDescriptorProto_Type.TYPE_DOUBLE) return 'double';
    if (type == FieldDescriptorProto_Type.TYPE_FLOAT) return 'float';
    if (type == FieldDescriptorProto_Type.TYPE_INT64) return 'int64';
    if (type == FieldDescriptorProto_Type.TYPE_UINT64) return 'uint64';
    if (type == FieldDescriptorProto_Type.TYPE_INT32) return 'int32';
    if (type == FieldDescriptorProto_Type.TYPE_FIXED64) return 'int64';
    if (type == FieldDescriptorProto_Type.TYPE_FIXED32) return 'int32';
    if (type == FieldDescriptorProto_Type.TYPE_BOOL) return 'bool';
    if (type == FieldDescriptorProto_Type.TYPE_STRING) return 'string';
    if (type == FieldDescriptorProto_Type.TYPE_MESSAGE) return 'message';
    if (type == FieldDescriptorProto_Type.TYPE_BYTES) return 'bytes';
    if (type == FieldDescriptorProto_Type.TYPE_UINT32) return 'uint32';
    if (type == FieldDescriptorProto_Type.TYPE_ENUM) return 'enum';
    if (type == FieldDescriptorProto_Type.TYPE_SFIXED32) return 'int32';
    if (type == FieldDescriptorProto_Type.TYPE_SFIXED64) return 'int64';
    if (type == FieldDescriptorProto_Type.TYPE_SINT32) return 'int32';
    if (type == FieldDescriptorProto_Type.TYPE_SINT64) return 'int64';
    return 'string';
  }
}
