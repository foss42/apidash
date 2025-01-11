// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predicate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Predicate _$PredicateFromJson(Map<String, dynamic> json) {
  return _Predicate.fromJson(json);
}

/// @nodoc
mixin _$Predicate {
  String get type => throw _privateConstructorUsedError;
  bool get not => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;
  String? get encoding => throw _privateConstructorUsedError;

  /// Serializes this Predicate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Predicate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredicateCopyWith<Predicate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredicateCopyWith<$Res> {
  factory $PredicateCopyWith(Predicate value, $Res Function(Predicate) then) =
      _$PredicateCopyWithImpl<$Res, Predicate>;
  @useResult
  $Res call({String type, bool not, dynamic value, String? encoding});
}

/// @nodoc
class _$PredicateCopyWithImpl<$Res, $Val extends Predicate>
    implements $PredicateCopyWith<$Res> {
  _$PredicateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Predicate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? not = null,
    Object? value = freezed,
    Object? encoding = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      not: null == not
          ? _value.not
          : not // ignore: cast_nullable_to_non_nullable
              as bool,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      encoding: freezed == encoding
          ? _value.encoding
          : encoding // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PredicateImplCopyWith<$Res>
    implements $PredicateCopyWith<$Res> {
  factory _$$PredicateImplCopyWith(
          _$PredicateImpl value, $Res Function(_$PredicateImpl) then) =
      __$$PredicateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, bool not, dynamic value, String? encoding});
}

/// @nodoc
class __$$PredicateImplCopyWithImpl<$Res>
    extends _$PredicateCopyWithImpl<$Res, _$PredicateImpl>
    implements _$$PredicateImplCopyWith<$Res> {
  __$$PredicateImplCopyWithImpl(
      _$PredicateImpl _value, $Res Function(_$PredicateImpl) _then)
      : super(_value, _then);

  /// Create a copy of Predicate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? not = null,
    Object? value = freezed,
    Object? encoding = freezed,
  }) {
    return _then(_$PredicateImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      not: null == not
          ? _value.not
          : not // ignore: cast_nullable_to_non_nullable
              as bool,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      encoding: freezed == encoding
          ? _value.encoding
          : encoding // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PredicateImpl implements _Predicate {
  const _$PredicateImpl(
      {required this.type, this.not = false, this.value, this.encoding});

  factory _$PredicateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredicateImplFromJson(json);

  @override
  final String type;
  @override
  @JsonKey()
  final bool not;
  @override
  final dynamic value;
  @override
  final String? encoding;

  @override
  String toString() {
    return 'Predicate(type: $type, not: $not, value: $value, encoding: $encoding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredicateImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.not, not) || other.not == not) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.encoding, encoding) ||
                other.encoding == encoding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, not,
      const DeepCollectionEquality().hash(value), encoding);

  /// Create a copy of Predicate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredicateImplCopyWith<_$PredicateImpl> get copyWith =>
      __$$PredicateImplCopyWithImpl<_$PredicateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredicateImplToJson(
      this,
    );
  }
}

abstract class _Predicate implements Predicate {
  const factory _Predicate(
      {required final String type,
      final bool not,
      final dynamic value,
      final String? encoding}) = _$PredicateImpl;

  factory _Predicate.fromJson(Map<String, dynamic> json) =
      _$PredicateImpl.fromJson;

  @override
  String get type;
  @override
  bool get not;
  @override
  dynamic get value;
  @override
  String? get encoding;

  /// Create a copy of Predicate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredicateImplCopyWith<_$PredicateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
