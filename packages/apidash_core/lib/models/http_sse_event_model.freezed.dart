// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_sse_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SSEEventModel _$SSEEventModelFromJson(Map<String, dynamic> json) {
  return _SSEEventModel.fromJson(json);
}

/// @nodoc
mixin _$SSEEventModel {
  String get event => throw _privateConstructorUsedError; // Custom event name
  String get data =>
      throw _privateConstructorUsedError; // Event data (main payload)
  String? get id =>
      throw _privateConstructorUsedError; // Last event ID for reconnection
  int? get retry =>
      throw _privateConstructorUsedError; // Reconnect interval in milliseconds
  Map<String, String>? get customFields => throw _privateConstructorUsedError;

  /// Serializes this SSEEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SSEEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SSEEventModelCopyWith<SSEEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SSEEventModelCopyWith<$Res> {
  factory $SSEEventModelCopyWith(
          SSEEventModel value, $Res Function(SSEEventModel) then) =
      _$SSEEventModelCopyWithImpl<$Res, SSEEventModel>;
  @useResult
  $Res call(
      {String event,
      String data,
      String? id,
      int? retry,
      Map<String, String>? customFields});
}

/// @nodoc
class _$SSEEventModelCopyWithImpl<$Res, $Val extends SSEEventModel>
    implements $SSEEventModelCopyWith<$Res> {
  _$SSEEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SSEEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? data = null,
    Object? id = freezed,
    Object? retry = freezed,
    Object? customFields = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      retry: freezed == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as int?,
      customFields: freezed == customFields
          ? _value.customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SSEEventModelImplCopyWith<$Res>
    implements $SSEEventModelCopyWith<$Res> {
  factory _$$SSEEventModelImplCopyWith(
          _$SSEEventModelImpl value, $Res Function(_$SSEEventModelImpl) then) =
      __$$SSEEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event,
      String data,
      String? id,
      int? retry,
      Map<String, String>? customFields});
}

/// @nodoc
class __$$SSEEventModelImplCopyWithImpl<$Res>
    extends _$SSEEventModelCopyWithImpl<$Res, _$SSEEventModelImpl>
    implements _$$SSEEventModelImplCopyWith<$Res> {
  __$$SSEEventModelImplCopyWithImpl(
      _$SSEEventModelImpl _value, $Res Function(_$SSEEventModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SSEEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? data = null,
    Object? id = freezed,
    Object? retry = freezed,
    Object? customFields = freezed,
  }) {
    return _then(_$SSEEventModelImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      retry: freezed == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as int?,
      customFields: freezed == customFields
          ? _value._customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$SSEEventModelImpl extends _SSEEventModel {
  const _$SSEEventModelImpl(
      {this.event = "",
      this.data = "",
      this.id,
      this.retry,
      final Map<String, String>? customFields})
      : _customFields = customFields,
        super._();

  factory _$SSEEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SSEEventModelImplFromJson(json);

  @override
  @JsonKey()
  final String event;
// Custom event name
  @override
  @JsonKey()
  final String data;
// Event data (main payload)
  @override
  final String? id;
// Last event ID for reconnection
  @override
  final int? retry;
// Reconnect interval in milliseconds
  final Map<String, String>? _customFields;
// Reconnect interval in milliseconds
  @override
  Map<String, String>? get customFields {
    final value = _customFields;
    if (value == null) return null;
    if (_customFields is EqualUnmodifiableMapView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SSEEventModel(event: $event, data: $data, id: $id, retry: $retry, customFields: $customFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SSEEventModelImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.retry, retry) || other.retry == retry) &&
            const DeepCollectionEquality()
                .equals(other._customFields, _customFields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, event, data, id, retry,
      const DeepCollectionEquality().hash(_customFields));

  /// Create a copy of SSEEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SSEEventModelImplCopyWith<_$SSEEventModelImpl> get copyWith =>
      __$$SSEEventModelImplCopyWithImpl<_$SSEEventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SSEEventModelImplToJson(
      this,
    );
  }
}

abstract class _SSEEventModel extends SSEEventModel {
  const factory _SSEEventModel(
      {final String event,
      final String data,
      final String? id,
      final int? retry,
      final Map<String, String>? customFields}) = _$SSEEventModelImpl;
  const _SSEEventModel._() : super._();

  factory _SSEEventModel.fromJson(Map<String, dynamic> json) =
      _$SSEEventModelImpl.fromJson;

  @override
  String get event; // Custom event name
  @override
  String get data; // Event data (main payload)
  @override
  String? get id; // Last event ID for reconnection
  @override
  int? get retry; // Reconnect interval in milliseconds
  @override
  Map<String, String>? get customFields;

  /// Create a copy of SSEEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SSEEventModelImplCopyWith<_$SSEEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
