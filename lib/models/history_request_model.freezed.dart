// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryRequestModel {
  String get historyId;
  HistoryMetaModel get metaData;
  HttpRequestModel? get httpRequestModel;
  AIRequestModel? get aiRequestModel;
  HttpResponseModel get httpResponseModel;
  String? get preRequestScript;
  String? get postRequestScript;
  AuthModel? get authModel;

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HistoryRequestModelCopyWith<HistoryRequestModel> get copyWith =>
      _$HistoryRequestModelCopyWithImpl<HistoryRequestModel>(
          this as HistoryRequestModel, _$identity);

  /// Serializes this HistoryRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HistoryRequestModel &&
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

  @override
  String toString() {
    return 'HistoryRequestModel(historyId: $historyId, metaData: $metaData, httpRequestModel: $httpRequestModel, aiRequestModel: $aiRequestModel, httpResponseModel: $httpResponseModel, preRequestScript: $preRequestScript, postRequestScript: $postRequestScript, authModel: $authModel)';
  }
}

/// @nodoc
abstract mixin class $HistoryRequestModelCopyWith<$Res> {
  factory $HistoryRequestModelCopyWith(
          HistoryRequestModel value, $Res Function(HistoryRequestModel) _then) =
      _$HistoryRequestModelCopyWithImpl;
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
class _$HistoryRequestModelCopyWithImpl<$Res>
    implements $HistoryRequestModelCopyWith<$Res> {
  _$HistoryRequestModelCopyWithImpl(this._self, this._then);

  final HistoryRequestModel _self;
  final $Res Function(HistoryRequestModel) _then;

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
    return _then(_self.copyWith(
      historyId: null == historyId
          ? _self.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      metaData: null == metaData
          ? _self.metaData
          : metaData // ignore: cast_nullable_to_non_nullable
              as HistoryMetaModel,
      httpRequestModel: freezed == httpRequestModel
          ? _self.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      aiRequestModel: freezed == aiRequestModel
          ? _self.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
      httpResponseModel: null == httpResponseModel
          ? _self.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel,
      preRequestScript: freezed == preRequestScript
          ? _self.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _self.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      authModel: freezed == authModel
          ? _self.authModel
          : authModel // ignore: cast_nullable_to_non_nullable
              as AuthModel?,
    ));
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HistoryMetaModelCopyWith<$Res> get metaData {
    return $HistoryMetaModelCopyWith<$Res>(_self.metaData, (value) {
      return _then(_self.copyWith(metaData: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel {
    if (_self.httpRequestModel == null) {
      return null;
    }

    return $HttpRequestModelCopyWith<$Res>(_self.httpRequestModel!, (value) {
      return _then(_self.copyWith(httpRequestModel: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIRequestModelCopyWith<$Res>? get aiRequestModel {
    if (_self.aiRequestModel == null) {
      return null;
    }

    return $AIRequestModelCopyWith<$Res>(_self.aiRequestModel!, (value) {
      return _then(_self.copyWith(aiRequestModel: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpResponseModelCopyWith<$Res> get httpResponseModel {
    return $HttpResponseModelCopyWith<$Res>(_self.httpResponseModel, (value) {
      return _then(_self.copyWith(httpResponseModel: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthModelCopyWith<$Res>? get authModel {
    if (_self.authModel == null) {
      return null;
    }

    return $AuthModelCopyWith<$Res>(_self.authModel!, (value) {
      return _then(_self.copyWith(authModel: value));
    });
  }
}

/// Adds pattern-matching-related methods to [HistoryRequestModel].
extension HistoryRequestModelPatterns on HistoryRequestModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HistoryRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoryRequestModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HistoryRequestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryRequestModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HistoryRequestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryRequestModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String historyId,
            HistoryMetaModel metaData,
            HttpRequestModel? httpRequestModel,
            AIRequestModel? aiRequestModel,
            HttpResponseModel httpResponseModel,
            String? preRequestScript,
            String? postRequestScript,
            AuthModel? authModel)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoryRequestModel() when $default != null:
        return $default(
            _that.historyId,
            _that.metaData,
            _that.httpRequestModel,
            _that.aiRequestModel,
            _that.httpResponseModel,
            _that.preRequestScript,
            _that.postRequestScript,
            _that.authModel);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String historyId,
            HistoryMetaModel metaData,
            HttpRequestModel? httpRequestModel,
            AIRequestModel? aiRequestModel,
            HttpResponseModel httpResponseModel,
            String? preRequestScript,
            String? postRequestScript,
            AuthModel? authModel)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryRequestModel():
        return $default(
            _that.historyId,
            _that.metaData,
            _that.httpRequestModel,
            _that.aiRequestModel,
            _that.httpResponseModel,
            _that.preRequestScript,
            _that.postRequestScript,
            _that.authModel);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String historyId,
            HistoryMetaModel metaData,
            HttpRequestModel? httpRequestModel,
            AIRequestModel? aiRequestModel,
            HttpResponseModel httpResponseModel,
            String? preRequestScript,
            String? postRequestScript,
            AuthModel? authModel)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryRequestModel() when $default != null:
        return $default(
            _that.historyId,
            _that.metaData,
            _that.httpRequestModel,
            _that.aiRequestModel,
            _that.httpResponseModel,
            _that.preRequestScript,
            _that.postRequestScript,
            _that.authModel);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _HistoryRequestModel implements HistoryRequestModel {
  const _HistoryRequestModel(
      {required this.historyId,
      required this.metaData,
      this.httpRequestModel,
      this.aiRequestModel,
      required this.httpResponseModel,
      this.preRequestScript,
      this.postRequestScript,
      this.authModel});
  factory _HistoryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryRequestModelFromJson(json);

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

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HistoryRequestModelCopyWith<_HistoryRequestModel> get copyWith =>
      __$HistoryRequestModelCopyWithImpl<_HistoryRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HistoryRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HistoryRequestModel &&
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

  @override
  String toString() {
    return 'HistoryRequestModel(historyId: $historyId, metaData: $metaData, httpRequestModel: $httpRequestModel, aiRequestModel: $aiRequestModel, httpResponseModel: $httpResponseModel, preRequestScript: $preRequestScript, postRequestScript: $postRequestScript, authModel: $authModel)';
  }
}

/// @nodoc
abstract mixin class _$HistoryRequestModelCopyWith<$Res>
    implements $HistoryRequestModelCopyWith<$Res> {
  factory _$HistoryRequestModelCopyWith(_HistoryRequestModel value,
          $Res Function(_HistoryRequestModel) _then) =
      __$HistoryRequestModelCopyWithImpl;
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
class __$HistoryRequestModelCopyWithImpl<$Res>
    implements _$HistoryRequestModelCopyWith<$Res> {
  __$HistoryRequestModelCopyWithImpl(this._self, this._then);

  final _HistoryRequestModel _self;
  final $Res Function(_HistoryRequestModel) _then;

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_HistoryRequestModel(
      historyId: null == historyId
          ? _self.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      metaData: null == metaData
          ? _self.metaData
          : metaData // ignore: cast_nullable_to_non_nullable
              as HistoryMetaModel,
      httpRequestModel: freezed == httpRequestModel
          ? _self.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      aiRequestModel: freezed == aiRequestModel
          ? _self.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
      httpResponseModel: null == httpResponseModel
          ? _self.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel,
      preRequestScript: freezed == preRequestScript
          ? _self.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _self.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      authModel: freezed == authModel
          ? _self.authModel
          : authModel // ignore: cast_nullable_to_non_nullable
              as AuthModel?,
    ));
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HistoryMetaModelCopyWith<$Res> get metaData {
    return $HistoryMetaModelCopyWith<$Res>(_self.metaData, (value) {
      return _then(_self.copyWith(metaData: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel {
    if (_self.httpRequestModel == null) {
      return null;
    }

    return $HttpRequestModelCopyWith<$Res>(_self.httpRequestModel!, (value) {
      return _then(_self.copyWith(httpRequestModel: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIRequestModelCopyWith<$Res>? get aiRequestModel {
    if (_self.aiRequestModel == null) {
      return null;
    }

    return $AIRequestModelCopyWith<$Res>(_self.aiRequestModel!, (value) {
      return _then(_self.copyWith(aiRequestModel: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpResponseModelCopyWith<$Res> get httpResponseModel {
    return $HttpResponseModelCopyWith<$Res>(_self.httpResponseModel, (value) {
      return _then(_self.copyWith(httpResponseModel: value));
    });
  }

  /// Create a copy of HistoryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthModelCopyWith<$Res>? get authModel {
    if (_self.authModel == null) {
      return null;
    }

    return $AuthModelCopyWith<$Res>(_self.authModel!, (value) {
      return _then(_self.copyWith(authModel: value));
    });
  }
}

// dart format on
