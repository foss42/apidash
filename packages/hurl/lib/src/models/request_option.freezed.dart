// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestOption _$RequestOptionFromJson(Map<String, dynamic> json) {
  return _RequestOption.fromJson(json);
}

/// @nodoc
mixin _$RequestOption {
  String get name => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;

  /// Serializes this RequestOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestOptionCopyWith<RequestOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestOptionCopyWith<$Res> {
  factory $RequestOptionCopyWith(
          RequestOption value, $Res Function(RequestOption) then) =
      _$RequestOptionCopyWithImpl<$Res, RequestOption>;
  @useResult
  $Res call({String name, dynamic value});
}

/// @nodoc
class _$RequestOptionCopyWithImpl<$Res, $Val extends RequestOption>
    implements $RequestOptionCopyWith<$Res> {
  _$RequestOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestOptionImplCopyWith<$Res>
    implements $RequestOptionCopyWith<$Res> {
  factory _$$RequestOptionImplCopyWith(
          _$RequestOptionImpl value, $Res Function(_$RequestOptionImpl) then) =
      __$$RequestOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, dynamic value});
}

/// @nodoc
class __$$RequestOptionImplCopyWithImpl<$Res>
    extends _$RequestOptionCopyWithImpl<$Res, _$RequestOptionImpl>
    implements _$$RequestOptionImplCopyWith<$Res> {
  __$$RequestOptionImplCopyWithImpl(
      _$RequestOptionImpl _value, $Res Function(_$RequestOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = freezed,
  }) {
    return _then(_$RequestOptionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$RequestOptionImpl implements _RequestOption {
  const _$RequestOptionImpl({required this.name, required this.value});

  factory _$RequestOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestOptionImplFromJson(json);

  @override
  final String name;
  @override
  final dynamic value;

  @override
  String toString() {
    return 'RequestOption(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestOptionImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(value));

  /// Create a copy of RequestOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestOptionImplCopyWith<_$RequestOptionImpl> get copyWith =>
      __$$RequestOptionImplCopyWithImpl<_$RequestOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestOptionImplToJson(
      this,
    );
  }
}

abstract class _RequestOption implements RequestOption {
  const factory _RequestOption(
      {required final String name,
      required final dynamic value}) = _$RequestOptionImpl;

  factory _RequestOption.fromJson(Map<String, dynamic> json) =
      _$RequestOptionImpl.fromJson;

  @override
  String get name;
  @override
  dynamic get value;

  /// Create a copy of RequestOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestOptionImplCopyWith<_$RequestOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
