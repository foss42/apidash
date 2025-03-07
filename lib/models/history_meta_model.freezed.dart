// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_meta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HistoryMetaModel _$HistoryMetaModelFromJson(Map<String, dynamic> json) {
  return _HistoryMetaModel.fromJson(json);
}

/// @nodoc
mixin _$HistoryMetaModel {
  String get historyId => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  APIType get apiType => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  HTTPVerb get method => throw _privateConstructorUsedError;
  int get responseStatus => throw _privateConstructorUsedError;
  DateTime get timeStamp => throw _privateConstructorUsedError;

  /// Serializes this HistoryMetaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryMetaModelCopyWith<HistoryMetaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryMetaModelCopyWith<$Res> {
  factory $HistoryMetaModelCopyWith(
          HistoryMetaModel value, $Res Function(HistoryMetaModel) then) =
      _$HistoryMetaModelCopyWithImpl<$Res, HistoryMetaModel>;
  @useResult
  $Res call(
      {String historyId,
      String requestId,
      APIType apiType,
      String name,
      String url,
      HTTPVerb method,
      int responseStatus,
      DateTime timeStamp});
}

/// @nodoc
class _$HistoryMetaModelCopyWithImpl<$Res, $Val extends HistoryMetaModel>
    implements $HistoryMetaModelCopyWith<$Res> {
  _$HistoryMetaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? historyId = null,
    Object? requestId = null,
    Object? apiType = null,
    Object? name = null,
    Object? url = null,
    Object? method = null,
    Object? responseStatus = null,
    Object? timeStamp = null,
  }) {
    return _then(_value.copyWith(
      historyId: null == historyId
          ? _value.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _value.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      responseStatus: null == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int,
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryMetaModelImplCopyWith<$Res>
    implements $HistoryMetaModelCopyWith<$Res> {
  factory _$$HistoryMetaModelImplCopyWith(_$HistoryMetaModelImpl value,
          $Res Function(_$HistoryMetaModelImpl) then) =
      __$$HistoryMetaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String historyId,
      String requestId,
      APIType apiType,
      String name,
      String url,
      HTTPVerb method,
      int responseStatus,
      DateTime timeStamp});
}

/// @nodoc
class __$$HistoryMetaModelImplCopyWithImpl<$Res>
    extends _$HistoryMetaModelCopyWithImpl<$Res, _$HistoryMetaModelImpl>
    implements _$$HistoryMetaModelImplCopyWith<$Res> {
  __$$HistoryMetaModelImplCopyWithImpl(_$HistoryMetaModelImpl _value,
      $Res Function(_$HistoryMetaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? historyId = null,
    Object? requestId = null,
    Object? apiType = null,
    Object? name = null,
    Object? url = null,
    Object? method = null,
    Object? responseStatus = null,
    Object? timeStamp = null,
  }) {
    return _then(_$HistoryMetaModelImpl(
      historyId: null == historyId
          ? _value.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _value.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      responseStatus: null == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int,
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryMetaModelImpl implements _HistoryMetaModel {
  const _$HistoryMetaModelImpl(
      {required this.historyId,
      required this.requestId,
      required this.apiType,
      this.name = "",
      required this.url,
      required this.method,
      required this.responseStatus,
      required this.timeStamp});

  factory _$HistoryMetaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryMetaModelImplFromJson(json);

  @override
  final String historyId;
  @override
  final String requestId;
  @override
  final APIType apiType;
  @override
  @JsonKey()
  final String name;
  @override
  final String url;
  @override
  final HTTPVerb method;
  @override
  final int responseStatus;
  @override
  final DateTime timeStamp;

  @override
  String toString() {
    return 'HistoryMetaModel(historyId: $historyId, requestId: $requestId, apiType: $apiType, name: $name, url: $url, method: $method, responseStatus: $responseStatus, timeStamp: $timeStamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryMetaModelImpl &&
            (identical(other.historyId, historyId) ||
                other.historyId == historyId) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.apiType, apiType) || other.apiType == apiType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, historyId, requestId, apiType,
      name, url, method, responseStatus, timeStamp);

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryMetaModelImplCopyWith<_$HistoryMetaModelImpl> get copyWith =>
      __$$HistoryMetaModelImplCopyWithImpl<_$HistoryMetaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryMetaModelImplToJson(
      this,
    );
  }
}

abstract class _HistoryMetaModel implements HistoryMetaModel {
  const factory _HistoryMetaModel(
      {required final String historyId,
      required final String requestId,
      required final APIType apiType,
      final String name,
      required final String url,
      required final HTTPVerb method,
      required final int responseStatus,
      required final DateTime timeStamp}) = _$HistoryMetaModelImpl;

  factory _HistoryMetaModel.fromJson(Map<String, dynamic> json) =
      _$HistoryMetaModelImpl.fromJson;

  @override
  String get historyId;
  @override
  String get requestId;
  @override
  APIType get apiType;
  @override
  String get name;
  @override
  String get url;
  @override
  HTTPVerb get method;
  @override
  int get responseStatus;
  @override
  DateTime get timeStamp;

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryMetaModelImplCopyWith<_$HistoryMetaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
