// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_api_key_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthApiKeyModel _$AuthApiKeyModelFromJson(Map<String, dynamic> json) {
  return _AuthApiKeyModel.fromJson(json);
}

/// @nodoc
mixin _$AuthApiKeyModel {
  String get key => throw _privateConstructorUsedError;
  String get location =>
      throw _privateConstructorUsedError; // 'header' or 'query'
  String get name => throw _privateConstructorUsedError;

  /// Serializes this AuthApiKeyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthApiKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthApiKeyModelCopyWith<AuthApiKeyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthApiKeyModelCopyWith<$Res> {
  factory $AuthApiKeyModelCopyWith(
    AuthApiKeyModel value,
    $Res Function(AuthApiKeyModel) then,
  ) = _$AuthApiKeyModelCopyWithImpl<$Res, AuthApiKeyModel>;
  @useResult
  $Res call({String key, String location, String name});
}

/// @nodoc
class _$AuthApiKeyModelCopyWithImpl<$Res, $Val extends AuthApiKeyModel>
    implements $AuthApiKeyModelCopyWith<$Res> {
  _$AuthApiKeyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthApiKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? location = null,
    Object? name = null,
  }) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthApiKeyModelImplCopyWith<$Res>
    implements $AuthApiKeyModelCopyWith<$Res> {
  factory _$$AuthApiKeyModelImplCopyWith(
    _$AuthApiKeyModelImpl value,
    $Res Function(_$AuthApiKeyModelImpl) then,
  ) = __$$AuthApiKeyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String location, String name});
}

/// @nodoc
class __$$AuthApiKeyModelImplCopyWithImpl<$Res>
    extends _$AuthApiKeyModelCopyWithImpl<$Res, _$AuthApiKeyModelImpl>
    implements _$$AuthApiKeyModelImplCopyWith<$Res> {
  __$$AuthApiKeyModelImplCopyWithImpl(
    _$AuthApiKeyModelImpl _value,
    $Res Function(_$AuthApiKeyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthApiKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? location = null,
    Object? name = null,
  }) {
    return _then(
      _$AuthApiKeyModelImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthApiKeyModelImpl implements _AuthApiKeyModel {
  const _$AuthApiKeyModelImpl({
    required this.key,
    this.location = 'header',
    this.name = 'x-api-key',
  });

  factory _$AuthApiKeyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthApiKeyModelImplFromJson(json);

  @override
  final String key;
  @override
  @JsonKey()
  final String location;
  // 'header' or 'query'
  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'AuthApiKeyModel(key: $key, location: $location, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthApiKeyModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, location, name);

  /// Create a copy of AuthApiKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthApiKeyModelImplCopyWith<_$AuthApiKeyModelImpl> get copyWith =>
      __$$AuthApiKeyModelImplCopyWithImpl<_$AuthApiKeyModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthApiKeyModelImplToJson(this);
  }
}

abstract class _AuthApiKeyModel implements AuthApiKeyModel {
  const factory _AuthApiKeyModel({
    required final String key,
    final String location,
    final String name,
  }) = _$AuthApiKeyModelImpl;

  factory _AuthApiKeyModel.fromJson(Map<String, dynamic> json) =
      _$AuthApiKeyModelImpl.fromJson;

  @override
  String get key;
  @override
  String get location; // 'header' or 'query'
  @override
  String get name;

  /// Create a copy of AuthApiKeyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthApiKeyModelImplCopyWith<_$AuthApiKeyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
