// This is a generated file - do not edit.
//
// Generated from grpc/reflection/v1alpha/reflection.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ServerReflectionRequest_MessageRequest {
  fileByFilename,
  fileContainingSymbol,
  fileContainingExtension,
  allExtensionNumbersOfType,
  listServices,
  notSet
}

/// The message sent by the client when calling ServerReflectionInfo method.
class ServerReflectionRequest extends $pb.GeneratedMessage {
  factory ServerReflectionRequest({
    $core.String? host,
    $core.String? fileByFilename,
    $core.String? fileContainingSymbol,
    ExtensionRequest? fileContainingExtension,
    $core.String? allExtensionNumbersOfType,
    $core.String? listServices,
  }) {
    final result = create();
    if (host != null) result.host = host;
    if (fileByFilename != null) result.fileByFilename = fileByFilename;
    if (fileContainingSymbol != null)
      result.fileContainingSymbol = fileContainingSymbol;
    if (fileContainingExtension != null)
      result.fileContainingExtension = fileContainingExtension;
    if (allExtensionNumbersOfType != null)
      result.allExtensionNumbersOfType = allExtensionNumbersOfType;
    if (listServices != null) result.listServices = listServices;
    return result;
  }

  ServerReflectionRequest._();

  factory ServerReflectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerReflectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerReflectionRequest_MessageRequest>
      _ServerReflectionRequest_MessageRequestByTag = {
    3: ServerReflectionRequest_MessageRequest.fileByFilename,
    4: ServerReflectionRequest_MessageRequest.fileContainingSymbol,
    5: ServerReflectionRequest_MessageRequest.fileContainingExtension,
    6: ServerReflectionRequest_MessageRequest.allExtensionNumbersOfType,
    7: ServerReflectionRequest_MessageRequest.listServices,
    0: ServerReflectionRequest_MessageRequest.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerReflectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7])
    ..aOS(1, _omitFieldNames ? '' : 'host')
    ..aOS(3, _omitFieldNames ? '' : 'fileByFilename')
    ..aOS(4, _omitFieldNames ? '' : 'fileContainingSymbol')
    ..aOM<ExtensionRequest>(5, _omitFieldNames ? '' : 'fileContainingExtension',
        subBuilder: ExtensionRequest.create)
    ..aOS(6, _omitFieldNames ? '' : 'allExtensionNumbersOfType')
    ..aOS(7, _omitFieldNames ? '' : 'listServices')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerReflectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerReflectionRequest copyWith(
          void Function(ServerReflectionRequest) updates) =>
      super.copyWith((message) => updates(message as ServerReflectionRequest))
          as ServerReflectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerReflectionRequest create() => ServerReflectionRequest._();
  @$core.override
  ServerReflectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerReflectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerReflectionRequest>(create);
  static ServerReflectionRequest? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  ServerReflectionRequest_MessageRequest whichMessageRequest() =>
      _ServerReflectionRequest_MessageRequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearMessageRequest() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get host => $_getSZ(0);
  @$pb.TagNumber(1)
  set host($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHost() => $_has(0);
  @$pb.TagNumber(1)
  void clearHost() => $_clearField(1);

  /// Find a proto file by the file name.
  @$pb.TagNumber(3)
  $core.String get fileByFilename => $_getSZ(1);
  @$pb.TagNumber(3)
  set fileByFilename($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasFileByFilename() => $_has(1);
  @$pb.TagNumber(3)
  void clearFileByFilename() => $_clearField(3);

  /// Find the proto file that declares the given fully-qualified symbol name.
  /// This field should be a fully-qualified symbol name
  /// (e.g. <package>.<service>[.<method>] or <package>.<type>).
  @$pb.TagNumber(4)
  $core.String get fileContainingSymbol => $_getSZ(2);
  @$pb.TagNumber(4)
  set fileContainingSymbol($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasFileContainingSymbol() => $_has(2);
  @$pb.TagNumber(4)
  void clearFileContainingSymbol() => $_clearField(4);

  /// Find the proto file which defines an extension extending the given
  /// message type with the given field number.
  @$pb.TagNumber(5)
  ExtensionRequest get fileContainingExtension => $_getN(3);
  @$pb.TagNumber(5)
  set fileContainingExtension(ExtensionRequest value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFileContainingExtension() => $_has(3);
  @$pb.TagNumber(5)
  void clearFileContainingExtension() => $_clearField(5);
  @$pb.TagNumber(5)
  ExtensionRequest ensureFileContainingExtension() => $_ensure(3);

  /// Finds the tag numbers used by all known extensions of extendee_type, and
  /// appends them to ExtensionNumberResponse in an undefined order.
  /// Its corresponding method is best-effort: it's not guaranteed that the
  /// reflection service will implement this method, and it's not guaranteed
  /// that this method will provide all extensions. Returns
  /// StatusCode::UNIMPLEMENTED if it's not implemented.
  /// This field should be a fully-qualified type name. The format is
  /// <package>.<type>
  @$pb.TagNumber(6)
  $core.String get allExtensionNumbersOfType => $_getSZ(4);
  @$pb.TagNumber(6)
  set allExtensionNumbersOfType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasAllExtensionNumbersOfType() => $_has(4);
  @$pb.TagNumber(6)
  void clearAllExtensionNumbersOfType() => $_clearField(6);

  /// List the full names of registered services. The content will not be
  /// checked.
  @$pb.TagNumber(7)
  $core.String get listServices => $_getSZ(5);
  @$pb.TagNumber(7)
  set listServices($core.String value) => $_setString(5, value);
  @$pb.TagNumber(7)
  $core.bool hasListServices() => $_has(5);
  @$pb.TagNumber(7)
  void clearListServices() => $_clearField(7);
}

/// The type name and extension number sent by the client when requesting
/// file_containing_extension.
class ExtensionRequest extends $pb.GeneratedMessage {
  factory ExtensionRequest({
    $core.String? containingType,
    $core.int? extensionNumber,
  }) {
    final result = create();
    if (containingType != null) result.containingType = containingType;
    if (extensionNumber != null) result.extensionNumber = extensionNumber;
    return result;
  }

  ExtensionRequest._();

  factory ExtensionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExtensionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'containingType')
    ..aI(2, _omitFieldNames ? '' : 'extensionNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionRequest copyWith(void Function(ExtensionRequest) updates) =>
      super.copyWith((message) => updates(message as ExtensionRequest))
          as ExtensionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionRequest create() => ExtensionRequest._();
  @$core.override
  ExtensionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExtensionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionRequest>(create);
  static ExtensionRequest? _defaultInstance;

  /// Fully-qualified type name. The format should be <package>.<type>
  @$pb.TagNumber(1)
  $core.String get containingType => $_getSZ(0);
  @$pb.TagNumber(1)
  set containingType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContainingType() => $_has(0);
  @$pb.TagNumber(1)
  void clearContainingType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get extensionNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set extensionNumber($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExtensionNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearExtensionNumber() => $_clearField(2);
}

enum ServerReflectionResponse_MessageResponse {
  fileDescriptorResponse,
  allExtensionNumbersResponse,
  listServicesResponse,
  errorResponse,
  notSet
}

/// The message sent by the server to answer ServerReflectionInfo method.
class ServerReflectionResponse extends $pb.GeneratedMessage {
  factory ServerReflectionResponse({
    $core.String? validHost,
    ServerReflectionRequest? originalRequest,
    FileDescriptorResponse? fileDescriptorResponse,
    ExtensionNumberResponse? allExtensionNumbersResponse,
    ListServiceResponse? listServicesResponse,
    ErrorResponse? errorResponse,
  }) {
    final result = create();
    if (validHost != null) result.validHost = validHost;
    if (originalRequest != null) result.originalRequest = originalRequest;
    if (fileDescriptorResponse != null)
      result.fileDescriptorResponse = fileDescriptorResponse;
    if (allExtensionNumbersResponse != null)
      result.allExtensionNumbersResponse = allExtensionNumbersResponse;
    if (listServicesResponse != null)
      result.listServicesResponse = listServicesResponse;
    if (errorResponse != null) result.errorResponse = errorResponse;
    return result;
  }

  ServerReflectionResponse._();

  factory ServerReflectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerReflectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerReflectionResponse_MessageResponse>
      _ServerReflectionResponse_MessageResponseByTag = {
    4: ServerReflectionResponse_MessageResponse.fileDescriptorResponse,
    5: ServerReflectionResponse_MessageResponse.allExtensionNumbersResponse,
    6: ServerReflectionResponse_MessageResponse.listServicesResponse,
    7: ServerReflectionResponse_MessageResponse.errorResponse,
    0: ServerReflectionResponse_MessageResponse.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerReflectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..oo(0, [4, 5, 6, 7])
    ..aOS(1, _omitFieldNames ? '' : 'validHost')
    ..aOM<ServerReflectionRequest>(2, _omitFieldNames ? '' : 'originalRequest',
        subBuilder: ServerReflectionRequest.create)
    ..aOM<FileDescriptorResponse>(
        4, _omitFieldNames ? '' : 'fileDescriptorResponse',
        subBuilder: FileDescriptorResponse.create)
    ..aOM<ExtensionNumberResponse>(
        5, _omitFieldNames ? '' : 'allExtensionNumbersResponse',
        subBuilder: ExtensionNumberResponse.create)
    ..aOM<ListServiceResponse>(6, _omitFieldNames ? '' : 'listServicesResponse',
        subBuilder: ListServiceResponse.create)
    ..aOM<ErrorResponse>(7, _omitFieldNames ? '' : 'errorResponse',
        subBuilder: ErrorResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerReflectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerReflectionResponse copyWith(
          void Function(ServerReflectionResponse) updates) =>
      super.copyWith((message) => updates(message as ServerReflectionResponse))
          as ServerReflectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerReflectionResponse create() => ServerReflectionResponse._();
  @$core.override
  ServerReflectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerReflectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerReflectionResponse>(create);
  static ServerReflectionResponse? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  ServerReflectionResponse_MessageResponse whichMessageResponse() =>
      _ServerReflectionResponse_MessageResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearMessageResponse() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get validHost => $_getSZ(0);
  @$pb.TagNumber(1)
  set validHost($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValidHost() => $_has(0);
  @$pb.TagNumber(1)
  void clearValidHost() => $_clearField(1);

  @$pb.TagNumber(2)
  ServerReflectionRequest get originalRequest => $_getN(1);
  @$pb.TagNumber(2)
  set originalRequest(ServerReflectionRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOriginalRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearOriginalRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  ServerReflectionRequest ensureOriginalRequest() => $_ensure(1);

  /// This message is used to answer file_by_filename, file_containing_symbol,
  /// file_containing_extension requests with transitive dependencies. As
  /// the repeated label is not allowed in oneof fields, we use a
  /// FileDescriptorResponse message to encapsulate the repeated fields.
  /// The reflection service is allowed to avoid sending FileDescriptorProtos
  /// that were previously sent in response to earlier requests in the stream.
  @$pb.TagNumber(4)
  FileDescriptorResponse get fileDescriptorResponse => $_getN(2);
  @$pb.TagNumber(4)
  set fileDescriptorResponse(FileDescriptorResponse value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFileDescriptorResponse() => $_has(2);
  @$pb.TagNumber(4)
  void clearFileDescriptorResponse() => $_clearField(4);
  @$pb.TagNumber(4)
  FileDescriptorResponse ensureFileDescriptorResponse() => $_ensure(2);

  /// This message is used to answer all_extension_numbers_of_type request.
  @$pb.TagNumber(5)
  ExtensionNumberResponse get allExtensionNumbersResponse => $_getN(3);
  @$pb.TagNumber(5)
  set allExtensionNumbersResponse(ExtensionNumberResponse value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAllExtensionNumbersResponse() => $_has(3);
  @$pb.TagNumber(5)
  void clearAllExtensionNumbersResponse() => $_clearField(5);
  @$pb.TagNumber(5)
  ExtensionNumberResponse ensureAllExtensionNumbersResponse() => $_ensure(3);

  /// This message is used to answer list_services request.
  @$pb.TagNumber(6)
  ListServiceResponse get listServicesResponse => $_getN(4);
  @$pb.TagNumber(6)
  set listServicesResponse(ListServiceResponse value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasListServicesResponse() => $_has(4);
  @$pb.TagNumber(6)
  void clearListServicesResponse() => $_clearField(6);
  @$pb.TagNumber(6)
  ListServiceResponse ensureListServicesResponse() => $_ensure(4);

  /// This message is used when an error occurs.
  @$pb.TagNumber(7)
  ErrorResponse get errorResponse => $_getN(5);
  @$pb.TagNumber(7)
  set errorResponse(ErrorResponse value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasErrorResponse() => $_has(5);
  @$pb.TagNumber(7)
  void clearErrorResponse() => $_clearField(7);
  @$pb.TagNumber(7)
  ErrorResponse ensureErrorResponse() => $_ensure(5);
}

/// Serialized FileDescriptorProto messages sent by the server answering
/// a file_by_filename, file_containing_symbol, or file_containing_extension
/// request.
class FileDescriptorResponse extends $pb.GeneratedMessage {
  factory FileDescriptorResponse({
    $core.Iterable<$core.List<$core.int>>? fileDescriptorProto,
  }) {
    final result = create();
    if (fileDescriptorProto != null)
      result.fileDescriptorProto.addAll(fileDescriptorProto);
    return result;
  }

  FileDescriptorResponse._();

  factory FileDescriptorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileDescriptorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileDescriptorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..p<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'fileDescriptorProto', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileDescriptorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileDescriptorResponse copyWith(
          void Function(FileDescriptorResponse) updates) =>
      super.copyWith((message) => updates(message as FileDescriptorResponse))
          as FileDescriptorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileDescriptorResponse create() => FileDescriptorResponse._();
  @$core.override
  FileDescriptorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileDescriptorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileDescriptorResponse>(create);
  static FileDescriptorResponse? _defaultInstance;

  /// Serialized FileDescriptorProto messages. We avoid taking a dependency on
  /// descriptor.proto, which uses proto2 only features, by making them opaque
  /// bytes instead.
  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get fileDescriptorProto => $_getList(0);
}

/// A list of extension numbers sent by the server answering
/// all_extension_numbers_of_type request.
class ExtensionNumberResponse extends $pb.GeneratedMessage {
  factory ExtensionNumberResponse({
    $core.String? baseTypeName,
    $core.Iterable<$core.int>? extensionNumber,
  }) {
    final result = create();
    if (baseTypeName != null) result.baseTypeName = baseTypeName;
    if (extensionNumber != null) result.extensionNumber.addAll(extensionNumber);
    return result;
  }

  ExtensionNumberResponse._();

  factory ExtensionNumberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExtensionNumberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionNumberResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'baseTypeName')
    ..p<$core.int>(
        2, _omitFieldNames ? '' : 'extensionNumber', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionNumberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionNumberResponse copyWith(
          void Function(ExtensionNumberResponse) updates) =>
      super.copyWith((message) => updates(message as ExtensionNumberResponse))
          as ExtensionNumberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionNumberResponse create() => ExtensionNumberResponse._();
  @$core.override
  ExtensionNumberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExtensionNumberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionNumberResponse>(create);
  static ExtensionNumberResponse? _defaultInstance;

  /// Full name of the base type, including the package name. The format
  /// is <package>.<type>
  @$pb.TagNumber(1)
  $core.String get baseTypeName => $_getSZ(0);
  @$pb.TagNumber(1)
  set baseTypeName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseTypeName() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseTypeName() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get extensionNumber => $_getList(1);
}

/// A list of ServiceResponse sent by the server answering list_services request.
class ListServiceResponse extends $pb.GeneratedMessage {
  factory ListServiceResponse({
    $core.Iterable<ServiceResponse>? service,
  }) {
    final result = create();
    if (service != null) result.service.addAll(service);
    return result;
  }

  ListServiceResponse._();

  factory ListServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListServiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..pPM<ServiceResponse>(1, _omitFieldNames ? '' : 'service',
        subBuilder: ServiceResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServiceResponse copyWith(void Function(ListServiceResponse) updates) =>
      super.copyWith((message) => updates(message as ListServiceResponse))
          as ListServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListServiceResponse create() => ListServiceResponse._();
  @$core.override
  ListServiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListServiceResponse>(create);
  static ListServiceResponse? _defaultInstance;

  /// The information of each service may be expanded in the future, so we use
  /// ServiceResponse message to encapsulate it.
  @$pb.TagNumber(1)
  $pb.PbList<ServiceResponse> get service => $_getList(0);
}

/// The information of a single service used by ListServiceResponse to answer
/// list_services request.
class ServiceResponse extends $pb.GeneratedMessage {
  factory ServiceResponse({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  ServiceResponse._();

  factory ServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceResponse copyWith(void Function(ServiceResponse) updates) =>
      super.copyWith((message) => updates(message as ServiceResponse))
          as ServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceResponse create() => ServiceResponse._();
  @$core.override
  ServiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceResponse>(create);
  static ServiceResponse? _defaultInstance;

  /// Full name of a registered service, including its package name. The format
  /// is <package>.<service>
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

/// The error code and error message sent by the server when an error occurs.
class ErrorResponse extends $pb.GeneratedMessage {
  factory ErrorResponse({
    $core.int? errorCode,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  ErrorResponse._();

  factory ErrorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'errorCode')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse copyWith(void Function(ErrorResponse) updates) =>
      super.copyWith((message) => updates(message as ErrorResponse))
          as ErrorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResponse create() => ErrorResponse._();
  @$core.override
  ErrorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorResponse>(create);
  static ErrorResponse? _defaultInstance;

  /// This field uses the error codes defined in grpc::StatusCode.
  @$pb.TagNumber(1)
  $core.int get errorCode => $_getIZ(0);
  @$pb.TagNumber(1)
  set errorCode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrorCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
