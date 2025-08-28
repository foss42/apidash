// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HistoryRequestModel _$HistoryRequestModelFromJson(Map<String, dynamic> json) {
  return _HistoryRequestModel.fromJson(json);
}

/// @nodoc
mixin _$HistoryRequestModel {
  String get historyId => throw _privateConstructorUsedError;
  HistoryMetaModel get metaData => throw _privateConstructorUsedError;
  HttpRequestModel? get httpRequestModel => throw _privateConstructorUsedError;
  AIRequestModel? get aiRequestModel => throw _privateConstructorUsedError;
  HttpResponseModel get httpResponseModel => throw _privateConstructorUsedError;
  String? get preRequestScript => throw _privateConstructorUsedError;
  String? get postRequestScript => throw _privateConstructorUsedError;
  AuthModel? get authModel => throw _privateConstructorUsedError;

  /// Serializes this HistoryRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryRequestModelCopyWith<HistoryRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryRequestModelCopyWith<$Res> {
  factory $HistoryRequestModelCopyWith(
          HistoryRequestModel value, $Res Function(HistoryRequestModel) then) =
      _$HistoryRequestModelCopyWithImpl<$Res, HistoryRequestModel>;
  @useResult
  $Res call(
      {String historyId,
      HistoryMetaModel metaData,
      HttpRequestModel? httpRequestModel,
      AIRequestModel? aiRequestModel,
      HttpResponseModel httpResponseModel,
      String? preRequestScript,
      String? postRequestScript,
      AuthModel? authModel});

  $HistoryMetaModelCopyWith<$Res> get metaData;
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
  $AIRequestModelCopyWith<$Res>? get aiRequestModel;
  $HttpResponseModelCopyWith<$Res> get httpResponseModel;
  $AuthModelCopyWith<$Res>? get authModel;
}

/// @nodoc
class _$HistoryRequestModelCopyWithImpl<$Res, $Val extends HistoryRequestModel>
    implements $HistoryRequestModelCopyWith<$Res> {
  _$HistoryRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? historyId = null,
    Object? metaData = null,
    Object? httpRequestModel = freezed,
    Object? aiRequestModel = freezed,
    Object? httpResponseModel = null,
    Object? preRequestScript = freezed,
    Object? postRequestScript = freezed,
    Object? authModel = freezed,
  }) {
    return _then(_value.copyWith(
      historyId: null == historyId
          ? _value.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      metaData: null == metaData
          ? _value.metaData
          : metaData // ignore: cast_nullable_to_non_nullable
              as HistoryMetaModel,
      httpRequestModel: freezed == httpRequestModel
          ? _value.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      aiRequestModel: freezed == aiRequestModel
          ? _value.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
      httpResponseModel: null == httpResponseModel
          ? _value.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _value.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      authModel: freezed == authModel
          ? _value.authModel
          : authModel // ignore: cast_nullable_to_non_nullable
              as AuthModel?,
    ) as $Val);
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HistoryMetaModelCopyWith<$Res> get metaData {
    return $HistoryMetaModelCopyWith<$Res>(_value.metaData, (value) {
      return _then(_value.copyWith(metaData: value) as $Val);
    });
  }

  /// Create a copy of HistoryRequestModel
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

  /// Create a copy of HistoryRequestModel
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

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpResponseModelCopyWith<$Res> get httpResponseModel {
    return $HttpResponseModelCopyWith<$Res>(_value.httpResponseModel, (value) {
      return _then(_value.copyWith(httpResponseModel: value) as $Val);
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthModelCopyWith<$Res>? get authModel {
    if (_value.authModel == null) {
      return null;
    }

    return $AuthModelCopyWith<$Res>(_value.authModel!, (value) {
      return _then(_value.copyWith(authModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HistoryRequestModelImplCopyWith<$Res>
    implements $HistoryRequestModelCopyWith<$Res> {
  factory _$$HistoryRequestModelImplCopyWith(_$HistoryRequestModelImpl value,
          $Res Function(_$HistoryRequestModelImpl) then) =
      __$$HistoryRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String historyId,
      HistoryMetaModel metaData,
      HttpRequestModel? httpRequestModel,
      AIRequestModel? aiRequestModel,
      HttpResponseModel httpResponseModel,
      String? preRequestScript,
      String? postRequestScript,
      AuthModel? authModel});

  @override
  $HistoryMetaModelCopyWith<$Res> get metaData;
  @override
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
  @override
  $AIRequestModelCopyWith<$Res>? get aiRequestModel;
  @override
  $HttpResponseModelCopyWith<$Res> get httpResponseModel;
  @override
  $AuthModelCopyWith<$Res>? get authModel;
}

/// @nodoc
class __$$HistoryRequestModelImplCopyWithImpl<$Res>
    extends _$HistoryRequestModelCopyWithImpl<$Res, _$HistoryRequestModelImpl>
    implements _$$HistoryRequestModelImplCopyWith<$Res> {
  __$$HistoryRequestModelImplCopyWithImpl(_$HistoryRequestModelImpl _value,
      $Res Function(_$HistoryRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? historyId = null,
    Object? metaData = null,
    Object? httpRequestModel = freezed,
    Object? aiRequestModel = freezed,
    Object? httpResponseModel = null,
    Object? preRequestScript = freezed,
    Object? postRequestScript = freezed,
    Object? authModel = freezed,
  }) {
    return _then(_$HistoryRequestModelImpl(
      historyId: null == historyId
          ? _value.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      metaData: null == metaData
          ? _value.metaData
          : metaData // ignore: cast_nullable_to_non_nullable
              as HistoryMetaModel,
      httpRequestModel: freezed == httpRequestModel
          ? _value.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      aiRequestModel: freezed == aiRequestModel
          ? _value.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
      httpResponseModel: null == httpResponseModel
          ? _value.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _value.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      authModel: freezed == authModel
          ? _value.authModel
          : authModel // ignore: cast_nullable_to_non_nullable
              as AuthModel?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$HistoryRequestModelImpl implements _HistoryRequestModel {
  const _$HistoryRequestModelImpl(
      {required this.historyId,
      required this.metaData,
      this.httpRequestModel,
      this.aiRequestModel,
      required this.httpResponseModel,
      this.preRequestScript,
      this.postRequestScript,
      this.authModel});

  factory _$HistoryRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryRequestModelImplFromJson(json);

  @override
  final String historyId;
  @override
  final HistoryMetaModel metaData;
  @override
  final HttpRequestModel? httpRequestModel;
  @override
  final AIRequestModel? aiRequestModel;
  @override
  final HttpResponseModel httpResponseModel;
  @override
  final String? preRequestScript;
  @override
  final String? postRequestScript;
  @override
  final AuthModel? authModel;

  @override
  String toString() {
    return 'HistoryRequestModel(historyId: $historyId, metaData: $metaData, httpRequestModel: $httpRequestModel, aiRequestModel: $aiRequestModel, httpResponseModel: $httpResponseModel, preRequestScript: $preRequestScript, postRequestScript: $postRequestScript, authModel: $authModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryRequestModelImpl &&
            (identical(other.historyId, historyId) ||
                other.historyId == historyId) &&
            (identical(other.metaData, metaData) ||
                other.metaData == metaData) &&
            (identical(other.httpRequestModel, httpRequestModel) ||
                other.httpRequestModel == httpRequestModel) &&
            (identical(other.aiRequestModel, aiRequestModel) ||
                other.aiRequestModel == aiRequestModel) &&
            (identical(other.httpResponseModel, httpResponseModel) ||
                other.httpResponseModel == httpResponseModel) &&
            (identical(other.preRequestScript, preRequestScript) ||
                other.preRequestScript == preRequestScript) &&
            (identical(other.postRequestScript, postRequestScript) ||
                other.postRequestScript == postRequestScript) &&
            (identical(other.authModel, authModel) ||
                other.authModel == authModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      historyId,
      metaData,
      httpRequestModel,
      aiRequestModel,
      httpResponseModel,
      preRequestScript,
      postRequestScript,
      authModel);

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryRequestModelImplCopyWith<_$HistoryRequestModelImpl> get copyWith =>
      __$$HistoryRequestModelImplCopyWithImpl<_$HistoryRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryRequestModelImplToJson(
      this,
    );
  }
}

abstract class _HistoryRequestModel implements HistoryRequestModel {
  const factory _HistoryRequestModel(
      {required final String historyId,
      required final HistoryMetaModel metaData,
      final HttpRequestModel? httpRequestModel,
      final AIRequestModel? aiRequestModel,
      required final HttpResponseModel httpResponseModel,
      final String? preRequestScript,
      final String? postRequestScript,
      final AuthModel? authModel}) = _$HistoryRequestModelImpl;

  factory _HistoryRequestModel.fromJson(Map<String, dynamic> json) =
      _$HistoryRequestModelImpl.fromJson;

  @override
  String get historyId;
  @override
  HistoryMetaModel get metaData;
  @override
  HttpRequestModel? get httpRequestModel;
  @override
  AIRequestModel? get aiRequestModel;
  @override
  HttpResponseModel get httpResponseModel;
  @override
  String? get preRequestScript;
  @override
  String? get postRequestScript;
  @override
  AuthModel? get authModel;

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryRequestModelImplCopyWith<_$HistoryRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
