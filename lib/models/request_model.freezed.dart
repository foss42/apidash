// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestModel {
  String get id;
  APIType get apiType;
  String get name;
  String get description;
  @JsonKey(includeToJson: false)
  dynamic get requestTabIndex;
  HttpRequestModel? get httpRequestModel;
  int? get responseStatus;
  String? get message;
  HttpResponseModel? get httpResponseModel;
  @JsonKey(includeToJson: false)
  bool get isWorking;
  @JsonKey(includeToJson: false)
  DateTime? get sendingTime;
  @JsonKey(includeToJson: false)
  bool get isStreaming;
  String? get preRequestScript;
  String? get postRequestScript;
  AIRequestModel? get aiRequestModel;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RequestModelCopyWith<RequestModel> get copyWith =>
      _$RequestModelCopyWithImpl<RequestModel>(
          this as RequestModel, _$identity);

  /// Serializes this RequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.apiType, apiType) || other.apiType == apiType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other.requestTabIndex, requestTabIndex) &&
            (identical(other.httpRequestModel, httpRequestModel) ||
                other.httpRequestModel == httpRequestModel) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.httpResponseModel, httpResponseModel) ||
                other.httpResponseModel == httpResponseModel) &&
            (identical(other.isWorking, isWorking) ||
                other.isWorking == isWorking) &&
            (identical(other.sendingTime, sendingTime) ||
                other.sendingTime == sendingTime) &&
            (identical(other.isStreaming, isStreaming) ||
                other.isStreaming == isStreaming) &&
            (identical(other.preRequestScript, preRequestScript) ||
                other.preRequestScript == preRequestScript) &&
            (identical(other.postRequestScript, postRequestScript) ||
                other.postRequestScript == postRequestScript) &&
            (identical(other.aiRequestModel, aiRequestModel) ||
                other.aiRequestModel == aiRequestModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      apiType,
      name,
      description,
      const DeepCollectionEquality().hash(requestTabIndex),
      httpRequestModel,
      responseStatus,
      message,
      httpResponseModel,
      isWorking,
      sendingTime,
      isStreaming,
      preRequestScript,
      postRequestScript,
      aiRequestModel);

  @override
  String toString() {
    return 'RequestModel(id: $id, apiType: $apiType, name: $name, description: $description, requestTabIndex: $requestTabIndex, httpRequestModel: $httpRequestModel, responseStatus: $responseStatus, message: $message, httpResponseModel: $httpResponseModel, isWorking: $isWorking, sendingTime: $sendingTime, isStreaming: $isStreaming, preRequestScript: $preRequestScript, postRequestScript: $postRequestScript, aiRequestModel: $aiRequestModel)';
  }
}

/// @nodoc
abstract mixin class $RequestModelCopyWith<$Res> {
  factory $RequestModelCopyWith(
          RequestModel value, $Res Function(RequestModel) _then) =
      _$RequestModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      APIType apiType,
      String name,
      String description,
      @JsonKey(includeToJson: false) dynamic requestTabIndex,
      HttpRequestModel? httpRequestModel,
      int? responseStatus,
      String? message,
      HttpResponseModel? httpResponseModel,
      @JsonKey(includeToJson: false) bool isWorking,
      @JsonKey(includeToJson: false) DateTime? sendingTime,
      @JsonKey(includeToJson: false) bool isStreaming,
      String? preRequestScript,
      String? postRequestScript,
      AIRequestModel? aiRequestModel});

  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel;
  $AIRequestModelCopyWith<$Res>? get aiRequestModel;
}

/// @nodoc
class _$RequestModelCopyWithImpl<$Res> implements $RequestModelCopyWith<$Res> {
  _$RequestModelCopyWithImpl(this._self, this._then);

  final RequestModel _self;
  final $Res Function(RequestModel) _then;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? apiType = null,
    Object? name = null,
    Object? description = null,
    Object? requestTabIndex = freezed,
    Object? httpRequestModel = freezed,
    Object? responseStatus = freezed,
    Object? message = freezed,
    Object? httpResponseModel = freezed,
    Object? isWorking = null,
    Object? sendingTime = freezed,
    Object? isStreaming = null,
    Object? preRequestScript = freezed,
    Object? postRequestScript = freezed,
    Object? aiRequestModel = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _self.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requestTabIndex: freezed == requestTabIndex
          ? _self.requestTabIndex
          : requestTabIndex // ignore: cast_nullable_to_non_nullable
              as dynamic,
      httpRequestModel: freezed == httpRequestModel
          ? _self.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      responseStatus: freezed == responseStatus
          ? _self.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      httpResponseModel: freezed == httpResponseModel
          ? _self.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel?,
      isWorking: null == isWorking
          ? _self.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as bool,
      sendingTime: freezed == sendingTime
          ? _self.sendingTime
          : sendingTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isStreaming: null == isStreaming
          ? _self.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      preRequestScript: freezed == preRequestScript
          ? _self.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _self.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      aiRequestModel: freezed == aiRequestModel
          ? _self.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
    ));
  }

  /// Create a copy of RequestModel
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

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel {
    if (_self.httpResponseModel == null) {
      return null;
    }

    return $HttpResponseModelCopyWith<$Res>(_self.httpResponseModel!, (value) {
      return _then(_self.copyWith(httpResponseModel: value));
    });
  }

  /// Create a copy of RequestModel
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
}

/// Adds pattern-matching-related methods to [RequestModel].
extension RequestModelPatterns on RequestModel {
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
    TResult Function(_RequestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestModel() when $default != null:
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
    TResult Function(_RequestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestModel():
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
    TResult? Function(_RequestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestModel() when $default != null:
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
            String id,
            APIType apiType,
            String name,
            String description,
            @JsonKey(includeToJson: false) dynamic requestTabIndex,
            HttpRequestModel? httpRequestModel,
            int? responseStatus,
            String? message,
            HttpResponseModel? httpResponseModel,
            @JsonKey(includeToJson: false) bool isWorking,
            @JsonKey(includeToJson: false) DateTime? sendingTime,
            @JsonKey(includeToJson: false) bool isStreaming,
            String? preRequestScript,
            String? postRequestScript,
            AIRequestModel? aiRequestModel)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestModel() when $default != null:
        return $default(
            _that.id,
            _that.apiType,
            _that.name,
            _that.description,
            _that.requestTabIndex,
            _that.httpRequestModel,
            _that.responseStatus,
            _that.message,
            _that.httpResponseModel,
            _that.isWorking,
            _that.sendingTime,
            _that.isStreaming,
            _that.preRequestScript,
            _that.postRequestScript,
            _that.aiRequestModel);
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
            String id,
            APIType apiType,
            String name,
            String description,
            @JsonKey(includeToJson: false) dynamic requestTabIndex,
            HttpRequestModel? httpRequestModel,
            int? responseStatus,
            String? message,
            HttpResponseModel? httpResponseModel,
            @JsonKey(includeToJson: false) bool isWorking,
            @JsonKey(includeToJson: false) DateTime? sendingTime,
            @JsonKey(includeToJson: false) bool isStreaming,
            String? preRequestScript,
            String? postRequestScript,
            AIRequestModel? aiRequestModel)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestModel():
        return $default(
            _that.id,
            _that.apiType,
            _that.name,
            _that.description,
            _that.requestTabIndex,
            _that.httpRequestModel,
            _that.responseStatus,
            _that.message,
            _that.httpResponseModel,
            _that.isWorking,
            _that.sendingTime,
            _that.isStreaming,
            _that.preRequestScript,
            _that.postRequestScript,
            _that.aiRequestModel);
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
            String id,
            APIType apiType,
            String name,
            String description,
            @JsonKey(includeToJson: false) dynamic requestTabIndex,
            HttpRequestModel? httpRequestModel,
            int? responseStatus,
            String? message,
            HttpResponseModel? httpResponseModel,
            @JsonKey(includeToJson: false) bool isWorking,
            @JsonKey(includeToJson: false) DateTime? sendingTime,
            @JsonKey(includeToJson: false) bool isStreaming,
            String? preRequestScript,
            String? postRequestScript,
            AIRequestModel? aiRequestModel)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestModel() when $default != null:
        return $default(
            _that.id,
            _that.apiType,
            _that.name,
            _that.description,
            _that.requestTabIndex,
            _that.httpRequestModel,
            _that.responseStatus,
            _that.message,
            _that.httpResponseModel,
            _that.isWorking,
            _that.sendingTime,
            _that.isStreaming,
            _that.preRequestScript,
            _that.postRequestScript,
            _that.aiRequestModel);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _RequestModel implements RequestModel {
  const _RequestModel(
      {required this.id,
      this.apiType = APIType.rest,
      this.name = "",
      this.description = "",
      @JsonKey(includeToJson: false) this.requestTabIndex = 0,
      this.httpRequestModel,
      this.responseStatus,
      this.message,
      this.httpResponseModel,
      @JsonKey(includeToJson: false) this.isWorking = false,
      @JsonKey(includeToJson: false) this.sendingTime,
      @JsonKey(includeToJson: false) this.isStreaming = false,
      this.preRequestScript,
      this.postRequestScript,
      this.aiRequestModel});
  factory _RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final APIType apiType;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(includeToJson: false)
  final dynamic requestTabIndex;
  @override
  final HttpRequestModel? httpRequestModel;
  @override
  final int? responseStatus;
  @override
  final String? message;
  @override
  final HttpResponseModel? httpResponseModel;
  @override
  @JsonKey(includeToJson: false)
  final bool isWorking;
  @override
  @JsonKey(includeToJson: false)
  final DateTime? sendingTime;
  @override
  @JsonKey(includeToJson: false)
  final bool isStreaming;
  @override
  final String? preRequestScript;
  @override
  final String? postRequestScript;
  @override
  final AIRequestModel? aiRequestModel;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RequestModelCopyWith<_RequestModel> get copyWith =>
      __$RequestModelCopyWithImpl<_RequestModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.apiType, apiType) || other.apiType == apiType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other.requestTabIndex, requestTabIndex) &&
            (identical(other.httpRequestModel, httpRequestModel) ||
                other.httpRequestModel == httpRequestModel) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.httpResponseModel, httpResponseModel) ||
                other.httpResponseModel == httpResponseModel) &&
            (identical(other.isWorking, isWorking) ||
                other.isWorking == isWorking) &&
            (identical(other.sendingTime, sendingTime) ||
                other.sendingTime == sendingTime) &&
            (identical(other.isStreaming, isStreaming) ||
                other.isStreaming == isStreaming) &&
            (identical(other.preRequestScript, preRequestScript) ||
                other.preRequestScript == preRequestScript) &&
            (identical(other.postRequestScript, postRequestScript) ||
                other.postRequestScript == postRequestScript) &&
            (identical(other.aiRequestModel, aiRequestModel) ||
                other.aiRequestModel == aiRequestModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      apiType,
      name,
      description,
      const DeepCollectionEquality().hash(requestTabIndex),
      httpRequestModel,
      responseStatus,
      message,
      httpResponseModel,
      isWorking,
      sendingTime,
      isStreaming,
      preRequestScript,
      postRequestScript,
      aiRequestModel);

  @override
  String toString() {
    return 'RequestModel(id: $id, apiType: $apiType, name: $name, description: $description, requestTabIndex: $requestTabIndex, httpRequestModel: $httpRequestModel, responseStatus: $responseStatus, message: $message, httpResponseModel: $httpResponseModel, isWorking: $isWorking, sendingTime: $sendingTime, isStreaming: $isStreaming, preRequestScript: $preRequestScript, postRequestScript: $postRequestScript, aiRequestModel: $aiRequestModel)';
  }
}

/// @nodoc
abstract mixin class _$RequestModelCopyWith<$Res>
    implements $RequestModelCopyWith<$Res> {
  factory _$RequestModelCopyWith(
          _RequestModel value, $Res Function(_RequestModel) _then) =
      __$RequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      APIType apiType,
      String name,
      String description,
      @JsonKey(includeToJson: false) dynamic requestTabIndex,
      HttpRequestModel? httpRequestModel,
      int? responseStatus,
      String? message,
      HttpResponseModel? httpResponseModel,
      @JsonKey(includeToJson: false) bool isWorking,
      @JsonKey(includeToJson: false) DateTime? sendingTime,
      @JsonKey(includeToJson: false) bool isStreaming,
      String? preRequestScript,
      String? postRequestScript,
      AIRequestModel? aiRequestModel});

  @override
  $HttpRequestModelCopyWith<$Res>? get httpRequestModel;
  @override
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel;
  @override
  $AIRequestModelCopyWith<$Res>? get aiRequestModel;
}

/// @nodoc
class __$RequestModelCopyWithImpl<$Res>
    implements _$RequestModelCopyWith<$Res> {
  __$RequestModelCopyWithImpl(this._self, this._then);

  final _RequestModel _self;
  final $Res Function(_RequestModel) _then;

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? apiType = null,
    Object? name = null,
    Object? description = null,
    Object? requestTabIndex = freezed,
    Object? httpRequestModel = freezed,
    Object? responseStatus = freezed,
    Object? message = freezed,
    Object? httpResponseModel = freezed,
    Object? isWorking = null,
    Object? sendingTime = freezed,
    Object? isStreaming = null,
    Object? preRequestScript = freezed,
    Object? postRequestScript = freezed,
    Object? aiRequestModel = freezed,
  }) {
    return _then(_RequestModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _self.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requestTabIndex: freezed == requestTabIndex
          ? _self.requestTabIndex
          : requestTabIndex // ignore: cast_nullable_to_non_nullable
              as dynamic,
      httpRequestModel: freezed == httpRequestModel
          ? _self.httpRequestModel
          : httpRequestModel // ignore: cast_nullable_to_non_nullable
              as HttpRequestModel?,
      responseStatus: freezed == responseStatus
          ? _self.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      httpResponseModel: freezed == httpResponseModel
          ? _self.httpResponseModel
          : httpResponseModel // ignore: cast_nullable_to_non_nullable
              as HttpResponseModel?,
      isWorking: null == isWorking
          ? _self.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as bool,
      sendingTime: freezed == sendingTime
          ? _self.sendingTime
          : sendingTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isStreaming: null == isStreaming
          ? _self.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      preRequestScript: freezed == preRequestScript
          ? _self.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      postRequestScript: freezed == postRequestScript
          ? _self.postRequestScript
          : postRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      aiRequestModel: freezed == aiRequestModel
          ? _self.aiRequestModel
          : aiRequestModel // ignore: cast_nullable_to_non_nullable
              as AIRequestModel?,
    ));
  }

  /// Create a copy of RequestModel
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

  /// Create a copy of RequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HttpResponseModelCopyWith<$Res>? get httpResponseModel {
    if (_self.httpResponseModel == null) {
      return null;
    }

    return $HttpResponseModelCopyWith<$Res>(_self.httpResponseModel!, (value) {
      return _then(_self.copyWith(httpResponseModel: value));
    });
  }

  /// Create a copy of RequestModel
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
}

// dart format on
