// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_frame_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebSocketFrameModel _$WebSocketFrameModelFromJson(Map<String, dynamic> json) {
  return _WebSocketFrameModel.fromJson(json);
}

/// @nodoc
mixin _$WebSocketFrameModel {
  String get id => throw _privateConstructorUsedError;
  String get frameType => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List? get binaryData => throw _privateConstructorUsedError;
  Map<String, String>? get metadata => throw _privateConstructorUsedError;
  bool get isFinalFrame => throw _privateConstructorUsedError;
  DateTime? get timeStamp => throw _privateConstructorUsedError;

  /// Serializes this WebSocketFrameModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WebSocketFrameModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebSocketFrameModelCopyWith<WebSocketFrameModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketFrameModelCopyWith<$Res> {
  factory $WebSocketFrameModelCopyWith(
          WebSocketFrameModel value, $Res Function(WebSocketFrameModel) then) =
      _$WebSocketFrameModelCopyWithImpl<$Res, WebSocketFrameModel>;
  @useResult
  $Res call(
      {String id,
      String frameType,
      String message,
      @Uint8ListConverter() Uint8List? binaryData,
      Map<String, String>? metadata,
      bool isFinalFrame,
      DateTime? timeStamp});
}

/// @nodoc
class _$WebSocketFrameModelCopyWithImpl<$Res, $Val extends WebSocketFrameModel>
    implements $WebSocketFrameModelCopyWith<$Res> {
  _$WebSocketFrameModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketFrameModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? frameType = null,
    Object? message = null,
    Object? binaryData = freezed,
    Object? metadata = freezed,
    Object? isFinalFrame = null,
    Object? timeStamp = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      frameType: null == frameType
          ? _value.frameType
          : frameType // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      binaryData: freezed == binaryData
          ? _value.binaryData
          : binaryData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      isFinalFrame: null == isFinalFrame
          ? _value.isFinalFrame
          : isFinalFrame // ignore: cast_nullable_to_non_nullable
              as bool,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebSocketFrameModelImplCopyWith<$Res>
    implements $WebSocketFrameModelCopyWith<$Res> {
  factory _$$WebSocketFrameModelImplCopyWith(_$WebSocketFrameModelImpl value,
          $Res Function(_$WebSocketFrameModelImpl) then) =
      __$$WebSocketFrameModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String frameType,
      String message,
      @Uint8ListConverter() Uint8List? binaryData,
      Map<String, String>? metadata,
      bool isFinalFrame,
      DateTime? timeStamp});
}

/// @nodoc
class __$$WebSocketFrameModelImplCopyWithImpl<$Res>
    extends _$WebSocketFrameModelCopyWithImpl<$Res, _$WebSocketFrameModelImpl>
    implements _$$WebSocketFrameModelImplCopyWith<$Res> {
  __$$WebSocketFrameModelImplCopyWithImpl(_$WebSocketFrameModelImpl _value,
      $Res Function(_$WebSocketFrameModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketFrameModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? frameType = null,
    Object? message = null,
    Object? binaryData = freezed,
    Object? metadata = freezed,
    Object? isFinalFrame = null,
    Object? timeStamp = freezed,
  }) {
    return _then(_$WebSocketFrameModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      frameType: null == frameType
          ? _value.frameType
          : frameType // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      binaryData: freezed == binaryData
          ? _value.binaryData
          : binaryData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      isFinalFrame: null == isFinalFrame
          ? _value.isFinalFrame
          : isFinalFrame // ignore: cast_nullable_to_non_nullable
              as bool,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$WebSocketFrameModelImpl extends _WebSocketFrameModel {
  const _$WebSocketFrameModelImpl(
      {required this.id,
      this.frameType = "",
      this.message = "",
      @Uint8ListConverter() this.binaryData,
      final Map<String, String>? metadata,
      this.isFinalFrame = false,
      this.timeStamp})
      : _metadata = metadata,
        super._();

  factory _$WebSocketFrameModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebSocketFrameModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String frameType;
  @override
  @JsonKey()
  final String message;
  @override
  @Uint8ListConverter()
  final Uint8List? binaryData;
  final Map<String, String>? _metadata;
  @override
  Map<String, String>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isFinalFrame;
  @override
  final DateTime? timeStamp;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketFrameModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.frameType, frameType) ||
                other.frameType == frameType) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.binaryData, binaryData) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isFinalFrame, isFinalFrame) ||
                other.isFinalFrame == isFinalFrame) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      frameType,
      message,
      const DeepCollectionEquality().hash(binaryData),
      const DeepCollectionEquality().hash(_metadata),
      isFinalFrame,
      timeStamp);

  /// Create a copy of WebSocketFrameModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketFrameModelImplCopyWith<_$WebSocketFrameModelImpl> get copyWith =>
      __$$WebSocketFrameModelImplCopyWithImpl<_$WebSocketFrameModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketFrameModelImplToJson(
      this,
    );
  }
}

abstract class _WebSocketFrameModel extends WebSocketFrameModel {
  const factory _WebSocketFrameModel(
      {required final String id,
      final String frameType,
      final String message,
      @Uint8ListConverter() final Uint8List? binaryData,
      final Map<String, String>? metadata,
      final bool isFinalFrame,
      final DateTime? timeStamp}) = _$WebSocketFrameModelImpl;
  const _WebSocketFrameModel._() : super._();

  factory _WebSocketFrameModel.fromJson(Map<String, dynamic> json) =
      _$WebSocketFrameModelImpl.fromJson;

  @override
  String get id;
  @override
  String get frameType;
  @override
  String get message;
  @override
  @Uint8ListConverter()
  Uint8List? get binaryData;
  @override
  Map<String, String>? get metadata;
  @override
  bool get isFinalFrame;
  @override
  DateTime? get timeStamp;

  /// Create a copy of WebSocketFrameModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketFrameModelImplCopyWith<_$WebSocketFrameModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
