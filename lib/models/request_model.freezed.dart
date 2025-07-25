// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) {
  return _RequestModel.fromJson(json);
}

/// @nodoc
mixin _$RequestModel {
  String get id => throw _privateConstructorUsedError;
  APIType get apiType => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  dynamic get requestTabIndex => throw _privateConstructorUsedError;
  HttpRequestModel? get httpRequestModel => throw _privateConstructorUsedError;
  int? get responseStatus => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  HttpResponseModel? get httpResponseModel =>
      throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  bool get isWorking => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  DateTime? get sendingTime => throw _privateConstructorUsedError;
  String? get preRequestScript => throw _privateConstructorUsedError;
  String? get postRequestScript =>
      throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  MQTTConnectionState? get mqttConnectionState =>
      throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  MQTTRequestModel? get mqttRequestModel => throw _privateConstructorUsedError;

  /// Serializes this RequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestModelCopyWith<RequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestModelCopyWith<$Res> {
  factory $RequestModelCopyWith(
          RequestModel value, $Res Function(RequestModel) then) =
      _$RequestModelCopyWithImpl<$Res, RequestModel>;
  @useResult
  $Res call(
      {String id,
      APIType apiType,
      String name,
      String description,
      @JsonKey(includeToJson: false) dynamic requestTabIndex,
      HttpRequestModel? httpRequestModel,
      int? responseStatus,
      String? message,
      HttpResponseModel? httpResponseModel,
      @JsonKey(includeToJson: false) bool isWorking,
      @JsonKey(includeToJson: false) DateTime? sendingTime,
      String? preRequestScript,
      String? postRequestScript,
      @JsonKey(includeFromJson: false, includeToJson: false)
      MQTTConnectionState? mqttConnectionState,
      @JsonKey(includeFromJson: false, includeToJson: false)
      MQTTRequestModel? mqttRequestModel});

  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel;
  $MQTTRequestModelCopyWith<$Res>? get mqttRequestModel;
}

/// @nodoc
class _$RequestModelCopyWithImpl<$Res, $Val extends RequestModel>
    implements $RequestModelCopyWith<$Res> {
  _$RequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? apiType = null,
    Object? name = null,
    Object? description = null,
    Object? requestTabIndex = freezed,
    Object? httpRequestModel = freezed,
    Object? responseStatus = freezed,
    Object? message = freezed,
    Object? httpResponseModel = freezed,
    Object? isWorking = null,
    Object? sendingTime = freezed,
    Object? preRequestScript = freezed,
    Object? postRequestScript = freezed,
    Object? mqttConnectionState = freezed,
    Object? mqttRequestModel = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _value.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requestTabIndex: freezed == requestTabIndex
          ? _value.requestTabIndex
          : requestTabIndex // ignore: cast_nullable_to_non_nullable
              as dynamic,
      httpRequestModel: freezed == httpRequestModel
          ? _value.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      httpResponseModel: freezed == httpResponseModel
          ? _value.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel?,
      isWorking: null == isWorking
          ? _value.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as bool,
      sendingTime: freezed == sendingTime
          ? _value.sendingTime
          : sendingTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _value.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      mqttConnectionState: freezed == mqttConnectionState
          ? _value.mqttConnectionState
          : mqttConnectionState // ignore: cast_nullable_to_non_nullable
              as MQTTConnectionState?,
      mqttRequestModel: freezed == mqttRequestModel
          ? _value.mqttRequestModel
          : mqttRequestModel // ignore: cast_nullable_to_non_nullable
              as MQTTRequestModel?,
    ) as $Val);
  }

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel {
    if (_value.httpRequestModel == null) {
      return null;
    }

    return $HttpRequestModelCopyWith<$Res>(_value.httpRequestModel!, (value) {
      return _then(_value.copyWith(httpRequestModel: value) as $Val);
    });
  }

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel {
    if (_value.httpResponseModel == null) {
      return null;
    }

    return $HttpResponseModelCopyWith<$Res>(_value.httpResponseModel!, (value) {
      return _then(_value.copyWith(httpResponseModel: value) as $Val);
    });
  }

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MQTTRequestModelCopyWith<$Res>? get mqttRequestModel {
    if (_value.mqttRequestModel == null) {
      return null;
    }

    return $MQTTRequestModelCopyWith<$Res>(_value.mqttRequestModel!, (value) {
      return _then(_value.copyWith(mqttRequestModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestModelImplCopyWith<$Res>
    implements $RequestModelCopyWith<$Res> {
  factory _$$RequestModelImplCopyWith(
          _$RequestModelImpl value, $Res Function(_$RequestModelImpl) then) =
      __$$RequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      APIType apiType,
      String name,
      String description,
      @JsonKey(includeToJson: false) dynamic requestTabIndex,
      HttpRequestModel? httpRequestModel,
      int? responseStatus,
      String? message,
      HttpResponseModel? httpResponseModel,
      @JsonKey(includeToJson: false) bool isWorking,
      @JsonKey(includeToJson: false) DateTime? sendingTime,
      String? preRequestScript,
      String? postRequestScript,
      @JsonKey(includeFromJson: false, includeToJson: false)
      MQTTConnectionState? mqttConnectionState,
      @JsonKey(includeFromJson: false, includeToJson: false)
      MQTTRequestModel? mqttRequestModel});

  @override
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
  @override
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel;
  @override
  $MQTTRequestModelCopyWith<$Res>? get mqttRequestModel;
}

/// @nodoc
class __$$RequestModelImplCopyWithImpl<$Res>
    extends _$RequestModelCopyWithImpl<$Res, _$RequestModelImpl>
    implements _$$RequestModelImplCopyWith<$Res> {
  __$$RequestModelImplCopyWithImpl(
      _$RequestModelImpl _value, $Res Function(_$RequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? apiType = null,
    Object? name = null,
    Object? description = null,
    Object? requestTabIndex = freezed,
    Object? httpRequestModel = freezed,
    Object? responseStatus = freezed,
    Object? message = freezed,
    Object? httpResponseModel = freezed,
    Object? isWorking = null,
    Object? sendingTime = freezed,
    Object? preRequestScript = freezed,
    Object? postRequestScript = freezed,
    Object? mqttConnectionState = freezed,
    Object? mqttRequestModel = freezed,
  }) {
    return _then(_$RequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _value.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requestTabIndex: freezed == requestTabIndex
          ? _value.requestTabIndex!
          : requestTabIndex,
      httpRequestModel: freezed == httpRequestModel
          ? _value.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      httpResponseModel: freezed == httpResponseModel
          ? _value.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel?,
      isWorking: null == isWorking
          ? _value.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as bool,
      sendingTime: freezed == sendingTime
          ? _value.sendingTime
          : sendingTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _value.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      mqttConnectionState: freezed == mqttConnectionState
          ? _value.mqttConnectionState
          : mqttConnectionState // ignore: cast_nullable_to_non_nullable
              as MQTTConnectionState?,
      mqttRequestModel: freezed == mqttRequestModel
          ? _value.mqttRequestModel
          : mqttRequestModel // ignore: cast_nullable_to_non_nullable
              as MQTTRequestModel?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$RequestModelImpl implements _RequestModel {
  const _$RequestModelImpl(
      {required this.id,
      this.apiType = APIType.rest,
      this.name = "",
      this.description = "",
      @JsonKey(includeToJson: false) this.requestTabIndex = 0,
      this.httpRequestModel,
      this.responseStatus,
      this.message,
      this.httpResponseModel,
      @JsonKey(includeToJson: false) this.isWorking = false,
      @JsonKey(includeToJson: false) this.sendingTime,
      this.preRequestScript,
      this.postRequestScript,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.mqttConnectionState,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.mqttRequestModel});

  factory _$RequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final APIType apiType;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(includeToJson: false)
  final dynamic requestTabIndex;
  @override
  final HttpRequestModel? httpRequestModel;
  @override
  final int? responseStatus;
  @override
  final String? message;
  @override
  final HttpResponseModel? httpResponseModel;
  @override
  @JsonKey(includeToJson: false)
  final bool isWorking;
  @override
  @JsonKey(includeToJson: false)
  final DateTime? sendingTime;
  @override
  final String? preRequestScript;
  @override
  final String? postRequestScript;
// MQTT support (move to end)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MQTTConnectionState? mqttConnectionState;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MQTTRequestModel? mqttRequestModel;

  @override
  String toString() {
    return 'RequestModel(id: $id, apiType: $apiType, name: $name, description: $description, requestTabIndex: $requestTabIndex, httpRequestModel: $httpRequestModel, responseStatus: $responseStatus, message: $message, httpResponseModel: $httpResponseModel, isWorking: $isWorking, sendingTime: $sendingTime, preRequestScript: $preRequestScript, postRequestScript: $postRequestScript, mqttConnectionState: $mqttConnectionState, mqttRequestModel: $mqttRequestModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.apiType, apiType) || other.apiType == apiType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other.requestTabIndex, requestTabIndex) &&
            (identical(other.httpRequestModel, httpRequestModel) ||
                other.httpRequestModel == httpRequestModel) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.httpResponseModel, httpResponseModel) ||
                other.httpResponseModel == httpResponseModel) &&
            (identical(other.isWorking, isWorking) ||
                other.isWorking == isWorking) &&
            (identical(other.sendingTime, sendingTime) ||
                other.sendingTime == sendingTime) &&
            (identical(other.preRequestScript, preRequestScript) ||
                other.preRequestScript == preRequestScript) &&
            (identical(other.postRequestScript, postRequestScript) ||
                other.postRequestScript == postRequestScript) &&
            (identical(other.mqttConnectionState, mqttConnectionState) ||
                other.mqttConnectionState == mqttConnectionState) &&
            (identical(other.mqttRequestModel, mqttRequestModel) ||
                other.mqttRequestModel == mqttRequestModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      apiType,
      name,
      description,
      const DeepCollectionEquality().hash(requestTabIndex),
      httpRequestModel,
      responseStatus,
      message,
      httpResponseModel,
      isWorking,
      sendingTime,
      preRequestScript,
      postRequestScript,
      mqttConnectionState,
      mqttRequestModel);

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestModelImplCopyWith<_$RequestModelImpl> get copyWith =>
      __$$RequestModelImplCopyWithImpl<_$RequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestModelImplToJson(
      this,
    );
  }
}

abstract class _RequestModel implements RequestModel {
  const factory _RequestModel(
      {required final String id,
      final APIType apiType,
      final String name,
      final String description,
      @JsonKey(includeToJson: false) final dynamic requestTabIndex,
      final HttpRequestModel? httpRequestModel,
      final int? responseStatus,
      final String? message,
      final HttpResponseModel? httpResponseModel,
      @JsonKey(includeToJson: false) final bool isWorking,
      @JsonKey(includeToJson: false) final DateTime? sendingTime,
      final String? preRequestScript,
      final String? postRequestScript,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final MQTTConnectionState? mqttConnectionState,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final MQTTRequestModel? mqttRequestModel}) = _$RequestModelImpl;

  factory _RequestModel.fromJson(Map<String, dynamic> json) =
      _$RequestModelImpl.fromJson;

  @override
  String get id;
  @override
  APIType get apiType;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(includeToJson: false)
  dynamic get requestTabIndex;
  @override
  HttpRequestModel? get httpRequestModel;
  @override
  int? get responseStatus;
  @override
  String? get message;
  @override
  HttpResponseModel? get httpResponseModel;
  @override
  @JsonKey(includeToJson: false)
  bool get isWorking;
  @override
  @JsonKey(includeToJson: false)
  DateTime? get sendingTime;
  @override
  String? get preRequestScript;
  @override
  String? get postRequestScript; // MQTT support (move to end)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  MQTTConnectionState? get mqttConnectionState;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  MQTTRequestModel? get mqttRequestModel;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestModelImplCopyWith<_$RequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
