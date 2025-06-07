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
  dynamic get requestTabIndex =>
      throw _privateConstructorUsedError; // HttpRequestModel? httpRequestModel,
  int? get responseStatus => throw _privateConstructorUsedError;
  String? get message =>
      throw _privateConstructorUsedError; // HttpResponseModel? httpResponseModel,
  @JsonKey(includeToJson: false)
  bool get isWorking => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  DateTime? get sendingTime => throw _privateConstructorUsedError;
  GenericRequestModel? get genericRequestModel =>
      throw _privateConstructorUsedError;
  GenericResponseModel? get genericResponseModel =>
      throw _privateConstructorUsedError;

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
      int? responseStatus,
      String? message,
      @JsonKey(includeToJson: false) bool isWorking,
      @JsonKey(includeToJson: false) DateTime? sendingTime,
      GenericRequestModel? genericRequestModel,
      GenericResponseModel? genericResponseModel});

  $GenericRequestModelCopyWith<$Res>? get genericRequestModel;
  $GenericResponseModelCopyWith<$Res>? get genericResponseModel;
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
    Object? responseStatus = freezed,
    Object? message = freezed,
    Object? isWorking = null,
    Object? sendingTime = freezed,
    Object? genericRequestModel = freezed,
    Object? genericResponseModel = freezed,
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
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isWorking: null == isWorking
          ? _value.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as bool,
      sendingTime: freezed == sendingTime
          ? _value.sendingTime
          : sendingTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      genericRequestModel: freezed == genericRequestModel
          ? _value.genericRequestModel
          : genericRequestModel // ignore: cast_nullable_to_non_nullable
              as GenericRequestModel?,
      genericResponseModel: freezed == genericResponseModel
          ? _value.genericResponseModel
          : genericResponseModel // ignore: cast_nullable_to_non_nullable
              as GenericResponseModel?,
    ) as $Val);
  }

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GenericRequestModelCopyWith<$Res>? get genericRequestModel {
    if (_value.genericRequestModel == null) {
      return null;
    }

    return $GenericRequestModelCopyWith<$Res>(_value.genericRequestModel!,
        (value) {
      return _then(_value.copyWith(genericRequestModel: value) as $Val);
    });
  }

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GenericResponseModelCopyWith<$Res>? get genericResponseModel {
    if (_value.genericResponseModel == null) {
      return null;
    }

    return $GenericResponseModelCopyWith<$Res>(_value.genericResponseModel!,
        (value) {
      return _then(_value.copyWith(genericResponseModel: value) as $Val);
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
      int? responseStatus,
      String? message,
      @JsonKey(includeToJson: false) bool isWorking,
      @JsonKey(includeToJson: false) DateTime? sendingTime,
      GenericRequestModel? genericRequestModel,
      GenericResponseModel? genericResponseModel});

  @override
  $GenericRequestModelCopyWith<$Res>? get genericRequestModel;
  @override
  $GenericResponseModelCopyWith<$Res>? get genericResponseModel;
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
    Object? responseStatus = freezed,
    Object? message = freezed,
    Object? isWorking = null,
    Object? sendingTime = freezed,
    Object? genericRequestModel = freezed,
    Object? genericResponseModel = freezed,
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
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isWorking: null == isWorking
          ? _value.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as bool,
      sendingTime: freezed == sendingTime
          ? _value.sendingTime
          : sendingTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      genericRequestModel: freezed == genericRequestModel
          ? _value.genericRequestModel
          : genericRequestModel // ignore: cast_nullable_to_non_nullable
              as GenericRequestModel?,
      genericResponseModel: freezed == genericResponseModel
          ? _value.genericResponseModel
          : genericResponseModel // ignore: cast_nullable_to_non_nullable
              as GenericResponseModel?,
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
      this.responseStatus,
      this.message,
      @JsonKey(includeToJson: false) this.isWorking = false,
      @JsonKey(includeToJson: false) this.sendingTime,
      this.genericRequestModel,
      this.genericResponseModel});

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
// HttpRequestModel? httpRequestModel,
  @override
  final int? responseStatus;
  @override
  final String? message;
// HttpResponseModel? httpResponseModel,
  @override
  @JsonKey(includeToJson: false)
  final bool isWorking;
  @override
  @JsonKey(includeToJson: false)
  final DateTime? sendingTime;
  @override
  final GenericRequestModel? genericRequestModel;
  @override
  final GenericResponseModel? genericResponseModel;

  @override
  String toString() {
    return 'RequestModel(id: $id, apiType: $apiType, name: $name, description: $description, requestTabIndex: $requestTabIndex, responseStatus: $responseStatus, message: $message, isWorking: $isWorking, sendingTime: $sendingTime, genericRequestModel: $genericRequestModel, genericResponseModel: $genericResponseModel)';
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
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isWorking, isWorking) ||
                other.isWorking == isWorking) &&
            (identical(other.sendingTime, sendingTime) ||
                other.sendingTime == sendingTime) &&
            (identical(other.genericRequestModel, genericRequestModel) ||
                other.genericRequestModel == genericRequestModel) &&
            (identical(other.genericResponseModel, genericResponseModel) ||
                other.genericResponseModel == genericResponseModel));
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
      responseStatus,
      message,
      isWorking,
      sendingTime,
      genericRequestModel,
      genericResponseModel);

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
      final int? responseStatus,
      final String? message,
      @JsonKey(includeToJson: false) final bool isWorking,
      @JsonKey(includeToJson: false) final DateTime? sendingTime,
      final GenericRequestModel? genericRequestModel,
      final GenericResponseModel? genericResponseModel}) = _$RequestModelImpl;

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
  dynamic get requestTabIndex; // HttpRequestModel? httpRequestModel,
  @override
  int? get responseStatus;
  @override
  String? get message; // HttpResponseModel? httpResponseModel,
  @override
  @JsonKey(includeToJson: false)
  bool get isWorking;
  @override
  @JsonKey(includeToJson: false)
  DateTime? get sendingTime;
  @override
  GenericRequestModel? get genericRequestModel;
  @override
  GenericResponseModel? get genericResponseModel;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestModelImplCopyWith<_$RequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
