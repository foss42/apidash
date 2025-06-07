// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generic_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GenericRequestModel _$GenericRequestModelFromJson(Map<String, dynamic> json) {
  return _GenericRequestModel.fromJson(json);
}

/// @nodoc
mixin _$GenericRequestModel {
  AIRequestModel? get aiRequestModel => throw _privateConstructorUsedError;
  HttpRequestModel? get httpRequestModel => throw _privateConstructorUsedError;

  /// Serializes this GenericRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenericRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenericRequestModelCopyWith<GenericRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericRequestModelCopyWith<$Res> {
  factory $GenericRequestModelCopyWith(
          GenericRequestModel value, $Res Function(GenericRequestModel) then) =
      _$GenericRequestModelCopyWithImpl<$Res, GenericRequestModel>;
  @useResult
  $Res call(
      {AIRequestModel? aiRequestModel, HttpRequestModel? httpRequestModel});

  $AIRequestModelCopyWith<$Res>? get aiRequestModel;
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
}

/// @nodoc
class _$GenericRequestModelCopyWithImpl<$Res, $Val extends GenericRequestModel>
    implements $GenericRequestModelCopyWith<$Res> {
  _$GenericRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenericRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiRequestModel = freezed,
    Object? httpRequestModel = freezed,
  }) {
    return _then(_value.copyWith(
      aiRequestModel: freezed == aiRequestModel
          ? _value.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
      httpRequestModel: freezed == httpRequestModel
          ? _value.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
    ) as $Val);
  }

  /// Create a copy of GenericRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIRequestModelCopyWith<$Res>? get aiRequestModel {
    if (_value.aiRequestModel == null) {
      return null;
    }

    return $AIRequestModelCopyWith<$Res>(_value.aiRequestModel!, (value) {
      return _then(_value.copyWith(aiRequestModel: value) as $Val);
    });
  }

  /// Create a copy of GenericRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel {
    if (_value.httpRequestModel == null) {
      return null;
    }

    return $HttpRequestModelCopyWith<$Res>(_value.httpRequestModel!, (value) {
      return _then(_value.copyWith(httpRequestModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GenericRequestModelImplCopyWith<$Res>
    implements $GenericRequestModelCopyWith<$Res> {
  factory _$$GenericRequestModelImplCopyWith(_$GenericRequestModelImpl value,
          $Res Function(_$GenericRequestModelImpl) then) =
      __$$GenericRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AIRequestModel? aiRequestModel, HttpRequestModel? httpRequestModel});

  @override
  $AIRequestModelCopyWith<$Res>? get aiRequestModel;
  @override
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
}

/// @nodoc
class __$$GenericRequestModelImplCopyWithImpl<$Res>
    extends _$GenericRequestModelCopyWithImpl<$Res, _$GenericRequestModelImpl>
    implements _$$GenericRequestModelImplCopyWith<$Res> {
  __$$GenericRequestModelImplCopyWithImpl(_$GenericRequestModelImpl _value,
      $Res Function(_$GenericRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenericRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiRequestModel = freezed,
    Object? httpRequestModel = freezed,
  }) {
    return _then(_$GenericRequestModelImpl(
      aiRequestModel: freezed == aiRequestModel
          ? _value.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
      httpRequestModel: freezed == httpRequestModel
          ? _value.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$GenericRequestModelImpl extends _GenericRequestModel {
  const _$GenericRequestModelImpl(
      {required this.aiRequestModel, required this.httpRequestModel})
      : super._();

  factory _$GenericRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenericRequestModelImplFromJson(json);

  @override
  final AIRequestModel? aiRequestModel;
  @override
  final HttpRequestModel? httpRequestModel;

  @override
  String toString() {
    return 'GenericRequestModel(aiRequestModel: $aiRequestModel, httpRequestModel: $httpRequestModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericRequestModelImpl &&
            (identical(other.aiRequestModel, aiRequestModel) ||
                other.aiRequestModel == aiRequestModel) &&
            (identical(other.httpRequestModel, httpRequestModel) ||
                other.httpRequestModel == httpRequestModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, aiRequestModel, httpRequestModel);

  /// Create a copy of GenericRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericRequestModelImplCopyWith<_$GenericRequestModelImpl> get copyWith =>
      __$$GenericRequestModelImplCopyWithImpl<_$GenericRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenericRequestModelImplToJson(
      this,
    );
  }
}

abstract class _GenericRequestModel extends GenericRequestModel {
  const factory _GenericRequestModel(
          {required final AIRequestModel? aiRequestModel,
          required final HttpRequestModel? httpRequestModel}) =
      _$GenericRequestModelImpl;
  const _GenericRequestModel._() : super._();

  factory _GenericRequestModel.fromJson(Map<String, dynamic> json) =
      _$GenericRequestModelImpl.fromJson;

  @override
  AIRequestModel? get aiRequestModel;
  @override
  HttpRequestModel? get httpRequestModel;

  /// Create a copy of GenericRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenericRequestModelImplCopyWith<_$GenericRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
