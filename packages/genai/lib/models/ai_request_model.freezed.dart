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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIRequestModel _$AIRequestModelFromJson(Map<String, dynamic> json) {
  return _AIRequestModel.fromJson(json);
}

/// @nodoc
mixin _$AIRequestModel {
  ModelAPIProvider? get modelProvider => throw _privateConstructorUsedError;
  ModelRequestData? get modelRequestData => throw _privateConstructorUsedError;

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
    AIRequestModel value,
    $Res Function(AIRequestModel) then,
  ) = _$AIRequestModelCopyWithImpl<$Res, AIRequestModel>;
  @useResult
  $Res call({
    ModelAPIProvider? modelProvider,
    ModelRequestData? modelRequestData,
  });

  $ModelRequestDataCopyWith<$Res>? get modelRequestData;
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
    Object? modelProvider = freezed,
    Object? modelRequestData = freezed,
  }) {
    return _then(
      _value.copyWith(
            modelProvider: freezed == modelProvider
                ? _value.modelProvider
                : modelProvider // ignore: cast_nullable_to_non_nullable
                      as ModelAPIProvider?,
            modelRequestData: freezed == modelRequestData
                ? _value.modelRequestData
                : modelRequestData // ignore: cast_nullable_to_non_nullable
                      as ModelRequestData?,
          )
          as $Val,
    );
  }

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModelRequestDataCopyWith<$Res>? get modelRequestData {
    if (_value.modelRequestData == null) {
      return null;
    }

    return $ModelRequestDataCopyWith<$Res>(_value.modelRequestData!, (value) {
      return _then(_value.copyWith(modelRequestData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AIRequestModelImplCopyWith<$Res>
    implements $AIRequestModelCopyWith<$Res> {
  factory _$$AIRequestModelImplCopyWith(
    _$AIRequestModelImpl value,
    $Res Function(_$AIRequestModelImpl) then,
  ) = __$$AIRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ModelAPIProvider? modelProvider,
    ModelRequestData? modelRequestData,
  });

  @override
  $ModelRequestDataCopyWith<$Res>? get modelRequestData;
}

/// @nodoc
class __$$AIRequestModelImplCopyWithImpl<$Res>
    extends _$AIRequestModelCopyWithImpl<$Res, _$AIRequestModelImpl>
    implements _$$AIRequestModelImplCopyWith<$Res> {
  __$$AIRequestModelImplCopyWithImpl(
    _$AIRequestModelImpl _value,
    $Res Function(_$AIRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelProvider = freezed,
    Object? modelRequestData = freezed,
  }) {
    return _then(
      _$AIRequestModelImpl(
        modelProvider: freezed == modelProvider
            ? _value.modelProvider
            : modelProvider // ignore: cast_nullable_to_non_nullable
                  as ModelAPIProvider?,
        modelRequestData: freezed == modelRequestData
            ? _value.modelRequestData
            : modelRequestData // ignore: cast_nullable_to_non_nullable
                  as ModelRequestData?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$AIRequestModelImpl extends _AIRequestModel {
  const _$AIRequestModelImpl({this.modelProvider, this.modelRequestData})
    : super._();

  factory _$AIRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIRequestModelImplFromJson(json);

  @override
  final ModelAPIProvider? modelProvider;
  @override
  final ModelRequestData? modelRequestData;

  @override
  String toString() {
    return 'AIRequestModel(modelProvider: $modelProvider, modelRequestData: $modelRequestData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIRequestModelImpl &&
            (identical(other.modelProvider, modelProvider) ||
                other.modelProvider == modelProvider) &&
            (identical(other.modelRequestData, modelRequestData) ||
                other.modelRequestData == modelRequestData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, modelProvider, modelRequestData);

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIRequestModelImplCopyWith<_$AIRequestModelImpl> get copyWith =>
      __$$AIRequestModelImplCopyWithImpl<_$AIRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIRequestModelImplToJson(this);
  }
}

abstract class _AIRequestModel extends AIRequestModel {
  const factory _AIRequestModel({
    final ModelAPIProvider? modelProvider,
    final ModelRequestData? modelRequestData,
  }) = _$AIRequestModelImpl;
  const _AIRequestModel._() : super._();

  factory _AIRequestModel.fromJson(Map<String, dynamic> json) =
      _$AIRequestModelImpl.fromJson;

  @override
  ModelAPIProvider? get modelProvider;
  @override
  ModelRequestData? get modelRequestData;

  /// Create a copy of AIRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIRequestModelImplCopyWith<_$AIRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
