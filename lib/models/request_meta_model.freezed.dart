// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_meta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestMetaModel _$RequestMetaModelFromJson(Map<String, dynamic> json) {
  return _RequestMetaModel.fromJson(json);
}

/// @nodoc
mixin _$RequestMetaModel {
  String get id => throw _privateConstructorUsedError;
  APIType get apiType => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  HTTPVerb get method => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int? get responseStatus => throw _privateConstructorUsedError;

  /// Serializes this RequestMetaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestMetaModelCopyWith<RequestMetaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestMetaModelCopyWith<$Res> {
  factory $RequestMetaModelCopyWith(
          RequestMetaModel value, $Res Function(RequestMetaModel) then) =
      _$RequestMetaModelCopyWithImpl<$Res, RequestMetaModel>;
  @useResult
  $Res call(
      {String id,
      APIType apiType,
      String name,
      String description,
      HTTPVerb method,
      String url,
      int? responseStatus});
}

/// @nodoc
class _$RequestMetaModelCopyWithImpl<$Res, $Val extends RequestMetaModel>
    implements $RequestMetaModelCopyWith<$Res> {
  _$RequestMetaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? apiType = null,
    Object? name = null,
    Object? description = null,
    Object? method = null,
    Object? url = null,
    Object? responseStatus = freezed,
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
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestMetaModelImplCopyWith<$Res>
    implements $RequestMetaModelCopyWith<$Res> {
  factory _$$RequestMetaModelImplCopyWith(_$RequestMetaModelImpl value,
          $Res Function(_$RequestMetaModelImpl) then) =
      __$$RequestMetaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      APIType apiType,
      String name,
      String description,
      HTTPVerb method,
      String url,
      int? responseStatus});
}

/// @nodoc
class __$$RequestMetaModelImplCopyWithImpl<$Res>
    extends _$RequestMetaModelCopyWithImpl<$Res, _$RequestMetaModelImpl>
    implements _$$RequestMetaModelImplCopyWith<$Res> {
  __$$RequestMetaModelImplCopyWithImpl(_$RequestMetaModelImpl _value,
      $Res Function(_$RequestMetaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? apiType = null,
    Object? name = null,
    Object? description = null,
    Object? method = null,
    Object? url = null,
    Object? responseStatus = freezed,
  }) {
    return _then(_$RequestMetaModelImpl(
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
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestMetaModelImpl implements _RequestMetaModel {
  const _$RequestMetaModelImpl(
      {required this.id,
      this.apiType = APIType.rest,
      this.name = "",
      this.description = "",
      this.method = HTTPVerb.get,
      this.url = "",
      this.responseStatus});

  factory _$RequestMetaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestMetaModelImplFromJson(json);

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
  @JsonKey()
  final HTTPVerb method;
  @override
  @JsonKey()
  final String url;
  @override
  final int? responseStatus;

  @override
  String toString() {
    return 'RequestMetaModel(id: $id, apiType: $apiType, name: $name, description: $description, method: $method, url: $url, responseStatus: $responseStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestMetaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.apiType, apiType) || other.apiType == apiType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, apiType, name, description, method, url, responseStatus);

  /// Create a copy of RequestMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestMetaModelImplCopyWith<_$RequestMetaModelImpl> get copyWith =>
      __$$RequestMetaModelImplCopyWithImpl<_$RequestMetaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestMetaModelImplToJson(
      this,
    );
  }
}

abstract class _RequestMetaModel implements RequestMetaModel {
  const factory _RequestMetaModel(
      {required final String id,
      final APIType apiType,
      final String name,
      final String description,
      final HTTPVerb method,
      final String url,
      final int? responseStatus}) = _$RequestMetaModelImpl;

  factory _RequestMetaModel.fromJson(Map<String, dynamic> json) =
      _$RequestMetaModelImpl.fromJson;

  @override
  String get id;
  @override
  APIType get apiType;
  @override
  String get name;
  @override
  String get description;
  @override
  HTTPVerb get method;
  @override
  String get url;
  @override
  int? get responseStatus;

  /// Create a copy of RequestMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestMetaModelImplCopyWith<_$RequestMetaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
