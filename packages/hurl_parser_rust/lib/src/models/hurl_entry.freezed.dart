// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hurl_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HurlEntry _$HurlEntryFromJson(Map<String, dynamic> json) {
  return _HurlEntry.fromJson(json);
}

/// @nodoc
mixin _$HurlEntry {
  HurlRequest get request => throw _privateConstructorUsedError;
  HurlResponse? get response => throw _privateConstructorUsedError;

  /// Serializes this HurlEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HurlEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HurlEntryCopyWith<HurlEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HurlEntryCopyWith<$Res> {
  factory $HurlEntryCopyWith(HurlEntry value, $Res Function(HurlEntry) then) =
      _$HurlEntryCopyWithImpl<$Res, HurlEntry>;
  @useResult
  $Res call({HurlRequest request, HurlResponse? response});

  $HurlRequestCopyWith<$Res> get request;
  $HurlResponseCopyWith<$Res>? get response;
}

/// @nodoc
class _$HurlEntryCopyWithImpl<$Res, $Val extends HurlEntry>
    implements $HurlEntryCopyWith<$Res> {
  _$HurlEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HurlEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? request = null,
    Object? response = freezed,
  }) {
    return _then(_value.copyWith(
      request: null == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as HurlRequest,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as HurlResponse?,
    ) as $Val);
  }

  /// Create a copy of HurlEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HurlRequestCopyWith<$Res> get request {
    return $HurlRequestCopyWith<$Res>(_value.request, (value) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }

  /// Create a copy of HurlEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HurlResponseCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $HurlResponseCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HurlEntryImplCopyWith<$Res>
    implements $HurlEntryCopyWith<$Res> {
  factory _$$HurlEntryImplCopyWith(
          _$HurlEntryImpl value, $Res Function(_$HurlEntryImpl) then) =
      __$$HurlEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HurlRequest request, HurlResponse? response});

  @override
  $HurlRequestCopyWith<$Res> get request;
  @override
  $HurlResponseCopyWith<$Res>? get response;
}

/// @nodoc
class __$$HurlEntryImplCopyWithImpl<$Res>
    extends _$HurlEntryCopyWithImpl<$Res, _$HurlEntryImpl>
    implements _$$HurlEntryImplCopyWith<$Res> {
  __$$HurlEntryImplCopyWithImpl(
      _$HurlEntryImpl _value, $Res Function(_$HurlEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of HurlEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? request = null,
    Object? response = freezed,
  }) {
    return _then(_$HurlEntryImpl(
      request: null == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as HurlRequest,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as HurlResponse?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$HurlEntryImpl implements _HurlEntry {
  const _$HurlEntryImpl({required this.request, this.response});

  factory _$HurlEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$HurlEntryImplFromJson(json);

  @override
  final HurlRequest request;
  @override
  final HurlResponse? response;

  @override
  String toString() {
    return 'HurlEntry(request: $request, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HurlEntryImpl &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, request, response);

  /// Create a copy of HurlEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HurlEntryImplCopyWith<_$HurlEntryImpl> get copyWith =>
      __$$HurlEntryImplCopyWithImpl<_$HurlEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HurlEntryImplToJson(
      this,
    );
  }
}

abstract class _HurlEntry implements HurlEntry {
  const factory _HurlEntry(
      {required final HurlRequest request,
      final HurlResponse? response}) = _$HurlEntryImpl;

  factory _HurlEntry.fromJson(Map<String, dynamic> json) =
      _$HurlEntryImpl.fromJson;

  @override
  HurlRequest get request;
  @override
  HurlResponse? get response;

  /// Create a copy of HurlEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HurlEntryImplCopyWith<_$HurlEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
