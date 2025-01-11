// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cookie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cookie _$CookieFromJson(Map<String, dynamic> json) {
  return _Cookie.fromJson(json);
}

/// @nodoc
mixin _$Cookie {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this Cookie to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookieCopyWith<Cookie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookieCopyWith<$Res> {
  factory $CookieCopyWith(Cookie value, $Res Function(Cookie) then) =
      _$CookieCopyWithImpl<$Res, Cookie>;
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class _$CookieCopyWithImpl<$Res, $Val extends Cookie>
    implements $CookieCopyWith<$Res> {
  _$CookieCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookieImplCopyWith<$Res> implements $CookieCopyWith<$Res> {
  factory _$$CookieImplCopyWith(
          _$CookieImpl value, $Res Function(_$CookieImpl) then) =
      __$$CookieImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class __$$CookieImplCopyWithImpl<$Res>
    extends _$CookieCopyWithImpl<$Res, _$CookieImpl>
    implements _$$CookieImplCopyWith<$Res> {
  __$$CookieImplCopyWithImpl(
      _$CookieImpl _value, $Res Function(_$CookieImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$CookieImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CookieImpl implements _Cookie {
  const _$CookieImpl({required this.name, required this.value});

  factory _$CookieImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookieImplFromJson(json);

  @override
  final String name;
  @override
  final String value;

  @override
  String toString() {
    return 'Cookie(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CookieImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookieImplCopyWith<_$CookieImpl> get copyWith =>
      __$$CookieImplCopyWithImpl<_$CookieImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookieImplToJson(
      this,
    );
  }
}

abstract class _Cookie implements Cookie {
  const factory _Cookie(
      {required final String name, required final String value}) = _$CookieImpl;

  factory _Cookie.fromJson(Map<String, dynamic> json) = _$CookieImpl.fromJson;

  @override
  String get name;
  @override
  String get value;

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookieImplCopyWith<_$CookieImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
