// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generic_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GenericResponseModel _$GenericResponseModelFromJson(Map<String, dynamic> json) {
  return _GenericResponseModel.fromJson(json);
}

/// @nodoc
mixin _$GenericResponseModel {
  AIResponseModel? get aiResponseModel => throw _privateConstructorUsedError;
  HttpResponseModel? get httpResponseModel =>
      throw _privateConstructorUsedError;

  /// Serializes this GenericResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenericResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenericResponseModelCopyWith<GenericResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericResponseModelCopyWith<$Res> {
  factory $GenericResponseModelCopyWith(GenericResponseModel value,
          $Res Function(GenericResponseModel) then) =
      _$GenericResponseModelCopyWithImpl<$Res, GenericResponseModel>;
  @useResult
  $Res call(
      {AIResponseModel? aiResponseModel, HttpResponseModel? httpResponseModel});

  $AIResponseModelCopyWith<$Res>? get aiResponseModel;
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel;
}

/// @nodoc
class _$GenericResponseModelCopyWithImpl<$Res,
        $Val extends GenericResponseModel>
    implements $GenericResponseModelCopyWith<$Res> {
  _$GenericResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenericResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiResponseModel = freezed,
    Object? httpResponseModel = freezed,
  }) {
    return _then(_value.copyWith(
      aiResponseModel: freezed == aiResponseModel
          ? _value.aiResponseModel
          : aiResponseModel // ignore: cast_nullable_to_non_nullable
              as AIResponseModel?,
      httpResponseModel: freezed == httpResponseModel
          ? _value.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel?,
    ) as $Val);
  }

  /// Create a copy of GenericResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIResponseModelCopyWith<$Res>? get aiResponseModel {
    if (_value.aiResponseModel == null) {
      return null;
    }

    return $AIResponseModelCopyWith<$Res>(_value.aiResponseModel!, (value) {
      return _then(_value.copyWith(aiResponseModel: value) as $Val);
    });
  }

  /// Create a copy of GenericResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel {
    if (_value.httpResponseModel == null) {
      return null;
    }

    return $HttpResponseModelCopyWith<$Res>(_value.httpResponseModel!, (value) {
      return _then(_value.copyWith(httpResponseModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GenericResponseModelImplCopyWith<$Res>
    implements $GenericResponseModelCopyWith<$Res> {
  factory _$$GenericResponseModelImplCopyWith(_$GenericResponseModelImpl value,
          $Res Function(_$GenericResponseModelImpl) then) =
      __$$GenericResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AIResponseModel? aiResponseModel, HttpResponseModel? httpResponseModel});

  @override
  $AIResponseModelCopyWith<$Res>? get aiResponseModel;
  @override
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel;
}

/// @nodoc
class __$$GenericResponseModelImplCopyWithImpl<$Res>
    extends _$GenericResponseModelCopyWithImpl<$Res, _$GenericResponseModelImpl>
    implements _$$GenericResponseModelImplCopyWith<$Res> {
  __$$GenericResponseModelImplCopyWithImpl(_$GenericResponseModelImpl _value,
      $Res Function(_$GenericResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenericResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiResponseModel = freezed,
    Object? httpResponseModel = freezed,
  }) {
    return _then(_$GenericResponseModelImpl(
      aiResponseModel: freezed == aiResponseModel
          ? _value.aiResponseModel
          : aiResponseModel // ignore: cast_nullable_to_non_nullable
              as AIResponseModel?,
      httpResponseModel: freezed == httpResponseModel
          ? _value.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, createToJson: true)
class _$GenericResponseModelImpl extends _GenericResponseModel {
  const _$GenericResponseModelImpl(
      {required this.aiResponseModel, required this.httpResponseModel})
      : super._();

  factory _$GenericResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenericResponseModelImplFromJson(json);

  @override
  final AIResponseModel? aiResponseModel;
  @override
  final HttpResponseModel? httpResponseModel;

  @override
  String toString() {
    return 'GenericResponseModel(aiResponseModel: $aiResponseModel, httpResponseModel: $httpResponseModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericResponseModelImpl &&
            (identical(other.aiResponseModel, aiResponseModel) ||
                other.aiResponseModel == aiResponseModel) &&
            (identical(other.httpResponseModel, httpResponseModel) ||
                other.httpResponseModel == httpResponseModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, aiResponseModel, httpResponseModel);

  /// Create a copy of GenericResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericResponseModelImplCopyWith<_$GenericResponseModelImpl>
      get copyWith =>
          __$$GenericResponseModelImplCopyWithImpl<_$GenericResponseModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenericResponseModelImplToJson(
      this,
    );
  }
}

abstract class _GenericResponseModel extends GenericResponseModel {
  const factory _GenericResponseModel(
          {required final AIResponseModel? aiResponseModel,
          required final HttpResponseModel? httpResponseModel}) =
      _$GenericResponseModelImpl;
  const _GenericResponseModel._() : super._();

  factory _GenericResponseModel.fromJson(Map<String, dynamic> json) =
      _$GenericResponseModelImpl.fromJson;

  @override
  AIResponseModel? get aiResponseModel;
  @override
  HttpResponseModel? get httpResponseModel;

  /// Create a copy of GenericResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenericResponseModelImplCopyWith<_$GenericResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
