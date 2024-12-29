// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Filter _$FilterFromJson(Map<String, dynamic> json) {
  return _Filter.fromJson(json);
}

/// @nodoc
mixin _$Filter {
  String get type => throw _privateConstructorUsedError;
  String? get expr =>
      throw _privateConstructorUsedError; // For regex, jsonpath, xpath
  String? get encoding =>
      throw _privateConstructorUsedError; // For decode filter
  String? get fmt => throw _privateConstructorUsedError; // For format filter
  int? get n => throw _privateConstructorUsedError; // For nth filter
  String? get oldValue =>
      throw _privateConstructorUsedError; // For replace filter
  String? get newValue =>
      throw _privateConstructorUsedError; // For replace filter
  String? get sep => throw _privateConstructorUsedError;

  /// Serializes this Filter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Filter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterCopyWith<Filter> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterCopyWith<$Res> {
  factory $FilterCopyWith(Filter value, $Res Function(Filter) then) =
      _$FilterCopyWithImpl<$Res, Filter>;
  @useResult
  $Res call(
      {String type,
      String? expr,
      String? encoding,
      String? fmt,
      int? n,
      String? oldValue,
      String? newValue,
      String? sep});
}

/// @nodoc
class _$FilterCopyWithImpl<$Res, $Val extends Filter>
    implements $FilterCopyWith<$Res> {
  _$FilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Filter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? expr = freezed,
    Object? encoding = freezed,
    Object? fmt = freezed,
    Object? n = freezed,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? sep = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expr: freezed == expr
          ? _value.expr
          : expr // ignore: cast_nullable_to_non_nullable
              as String?,
      encoding: freezed == encoding
          ? _value.encoding
          : encoding // ignore: cast_nullable_to_non_nullable
              as String?,
      fmt: freezed == fmt
          ? _value.fmt
          : fmt // ignore: cast_nullable_to_non_nullable
              as String?,
      n: freezed == n
          ? _value.n
          : n // ignore: cast_nullable_to_non_nullable
              as int?,
      oldValue: freezed == oldValue
          ? _value.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as String?,
      newValue: freezed == newValue
          ? _value.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as String?,
      sep: freezed == sep
          ? _value.sep
          : sep // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterImplCopyWith<$Res> implements $FilterCopyWith<$Res> {
  factory _$$FilterImplCopyWith(
          _$FilterImpl value, $Res Function(_$FilterImpl) then) =
      __$$FilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String? expr,
      String? encoding,
      String? fmt,
      int? n,
      String? oldValue,
      String? newValue,
      String? sep});
}

/// @nodoc
class __$$FilterImplCopyWithImpl<$Res>
    extends _$FilterCopyWithImpl<$Res, _$FilterImpl>
    implements _$$FilterImplCopyWith<$Res> {
  __$$FilterImplCopyWithImpl(
      _$FilterImpl _value, $Res Function(_$FilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Filter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? expr = freezed,
    Object? encoding = freezed,
    Object? fmt = freezed,
    Object? n = freezed,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? sep = freezed,
  }) {
    return _then(_$FilterImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expr: freezed == expr
          ? _value.expr
          : expr // ignore: cast_nullable_to_non_nullable
              as String?,
      encoding: freezed == encoding
          ? _value.encoding
          : encoding // ignore: cast_nullable_to_non_nullable
              as String?,
      fmt: freezed == fmt
          ? _value.fmt
          : fmt // ignore: cast_nullable_to_non_nullable
              as String?,
      n: freezed == n
          ? _value.n
          : n // ignore: cast_nullable_to_non_nullable
              as int?,
      oldValue: freezed == oldValue
          ? _value.oldValue
          : oldValue // ignore: cast_nullable_to_non_nullable
              as String?,
      newValue: freezed == newValue
          ? _value.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as String?,
      sep: freezed == sep
          ? _value.sep
          : sep // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterImpl implements _Filter {
  const _$FilterImpl(
      {required this.type,
      this.expr,
      this.encoding,
      this.fmt,
      this.n,
      this.oldValue,
      this.newValue,
      this.sep});

  factory _$FilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterImplFromJson(json);

  @override
  final String type;
  @override
  final String? expr;
// For regex, jsonpath, xpath
  @override
  final String? encoding;
// For decode filter
  @override
  final String? fmt;
// For format filter
  @override
  final int? n;
// For nth filter
  @override
  final String? oldValue;
// For replace filter
  @override
  final String? newValue;
// For replace filter
  @override
  final String? sep;

  @override
  String toString() {
    return 'Filter(type: $type, expr: $expr, encoding: $encoding, fmt: $fmt, n: $n, oldValue: $oldValue, newValue: $newValue, sep: $sep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.expr, expr) || other.expr == expr) &&
            (identical(other.encoding, encoding) ||
                other.encoding == encoding) &&
            (identical(other.fmt, fmt) || other.fmt == fmt) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.oldValue, oldValue) ||
                other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.sep, sep) || other.sep == sep));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, expr, encoding, fmt, n, oldValue, newValue, sep);

  /// Create a copy of Filter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterImplCopyWith<_$FilterImpl> get copyWith =>
      __$$FilterImplCopyWithImpl<_$FilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterImplToJson(
      this,
    );
  }
}

abstract class _Filter implements Filter {
  const factory _Filter(
      {required final String type,
      final String? expr,
      final String? encoding,
      final String? fmt,
      final int? n,
      final String? oldValue,
      final String? newValue,
      final String? sep}) = _$FilterImpl;

  factory _Filter.fromJson(Map<String, dynamic> json) = _$FilterImpl.fromJson;

  @override
  String get type;
  @override
  String? get expr; // For regex, jsonpath, xpath
  @override
  String? get encoding; // For decode filter
  @override
  String? get fmt; // For format filter
  @override
  int? get n; // For nth filter
  @override
  String? get oldValue; // For replace filter
  @override
  String? get newValue; // For replace filter
  @override
  String? get sep;

  /// Create a copy of Filter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterImplCopyWith<_$FilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
