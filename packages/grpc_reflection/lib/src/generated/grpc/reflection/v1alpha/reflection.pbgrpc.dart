// This is a generated file - do not edit.
//
// Generated from grpc/reflection/v1alpha/reflection.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'reflection.pb.dart' as $0;

export 'reflection.pb.dart';

@$pb.GrpcServiceName('grpc.reflection.v1alpha.ServerReflection')
class ServerReflectionClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ServerReflectionClient(super.channel, {super.options, super.interceptors});

  /// The reflection service is structured as a bidirectional stream, ensuring
  /// all related requests go to a single server.
  $grpc.ResponseStream<$0.ServerReflectionResponse> serverReflectionInfo(
    $async.Stream<$0.ServerReflectionRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$serverReflectionInfo, request,
        options: options);
  }

  // method descriptors

  static final _$serverReflectionInfo = $grpc.ClientMethod<
          $0.ServerReflectionRequest, $0.ServerReflectionResponse>(
      '/grpc.reflection.v1alpha.ServerReflection/ServerReflectionInfo',
      ($0.ServerReflectionRequest value) => value.writeToBuffer(),
      $0.ServerReflectionResponse.fromBuffer);
}

@$pb.GrpcServiceName('grpc.reflection.v1alpha.ServerReflection')
abstract class ServerReflectionServiceBase extends $grpc.Service {
  $core.String get $name => 'grpc.reflection.v1alpha.ServerReflection';

  ServerReflectionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ServerReflectionRequest,
            $0.ServerReflectionResponse>(
        'ServerReflectionInfo',
        serverReflectionInfo,
        true,
        true,
        ($core.List<$core.int> value) =>
            $0.ServerReflectionRequest.fromBuffer(value),
        ($0.ServerReflectionResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.ServerReflectionResponse> serverReflectionInfo(
      $grpc.ServiceCall call,
      $async.Stream<$0.ServerReflectionRequest> request);
}
