// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIRequestModel _$AIRequestModelFromJson(Map<String, dynamic> json) {
  return _AIRequestModel.fromJson(json);
}

/// @nodoc
mixin _$AIRequestModel {
  @JsonKey(fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
  LLMInputPayload get payload => throw _privateConstructorUsedError;

  /// Serializes this AIRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIRequestModelCopyWith<AIRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIRequestModelCopyWith<$Res> {
  factory $AIRequestModelCopyWith(
          AIRequestModel value, $Res Function(AIRequestModel) then) =
      _$AIRequestModelCopyWithImpl<$Res, AIRequestModel>;
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
      LLMInputPayload payload});
}

/// @nodoc
class _$AIRequestModelCopyWithImpl<$Res, $Val extends AIRequestModel>
    implements $AIRequestModelCopyWith<$Res> {
  _$AIRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payload = null,
  }) {
    return _then(_value.copyWith(
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as LLMInputPayload,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIRequestModelImplCopyWith<$Res>
    implements $AIRequestModelCopyWith<$Res> {
  factory _$$AIRequestModelImplCopyWith(_$AIRequestModelImpl value,
          $Res Function(_$AIRequestModelImpl) then) =
      __$$AIRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
      LLMInputPayload payload});
}

/// @nodoc
class __$$AIRequestModelImplCopyWithImpl<$Res>
    extends _$AIRequestModelCopyWithImpl<$Res, _$AIRequestModelImpl>
    implements _$$AIRequestModelImplCopyWith<$Res> {
  __$$AIRequestModelImplCopyWithImpl(
      _$AIRequestModelImpl _value, $Res Function(_$AIRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payload = null,
  }) {
    return _then(_$AIRequestModelImpl(
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as LLMInputPayload,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, createToJson: true)
class _$AIRequestModelImpl extends _AIRequestModel {
  const _$AIRequestModelImpl(
      {@JsonKey(
          fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
      required this.payload})
      : super._();

  factory _$AIRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIRequestModelImplFromJson(json);

  @override
  @JsonKey(fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
  final LLMInputPayload payload;

  @override
  String toString() {
    return 'AIRequestModel(payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIRequestModelImpl &&
            (identical(other.payload, payload) || other.payload == payload));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, payload);

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIRequestModelImplCopyWith<_$AIRequestModelImpl> get copyWith =>
      __$$AIRequestModelImplCopyWithImpl<_$AIRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIRequestModelImplToJson(
      this,
    );
  }
}

abstract class _AIRequestModel extends AIRequestModel {
  const factory _AIRequestModel(
      {@JsonKey(
          fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
      required final LLMInputPayload payload}) = _$AIRequestModelImpl;
  const _AIRequestModel._() : super._();

  factory _AIRequestModel.fromJson(Map<String, dynamic> json) =
      _$AIRequestModelImpl.fromJson;

  @override
  @JsonKey(fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
  LLMInputPayload get payload;

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIRequestModelImplCopyWith<_$AIRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
