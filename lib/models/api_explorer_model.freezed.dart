// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_explorer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiExplorerModel _$ApiExplorerModelFromJson(Map<String, dynamic> json) {
  return _ApiExplorerModel.fromJson(json);
}

/// @nodoc
mixin _$ApiExplorerModel {
  /// Core identification
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Endpoint configuration
  String get path => throw _privateConstructorUsedError;
  HTTPVerb get method => throw _privateConstructorUsedError;
  String get baseUrl => throw _privateConstructorUsedError;
  String get operationId => throw _privateConstructorUsedError;

  /// Request components
  List<NameValueModel> get parameters => throw _privateConstructorUsedError;
  List<NameValueModel> get headers => throw _privateConstructorUsedError;
  Map<String, dynamic>? get requestBody => throw _privateConstructorUsedError;
  Map<String, dynamic>? get responses => throw _privateConstructorUsedError;

  /// Parameter metadata
  Map<String, dynamic> get parameterSchemas =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get headerSchemas => throw _privateConstructorUsedError;

  /// Serializes this ApiExplorerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiExplorerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiExplorerModelCopyWith<ApiExplorerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiExplorerModelCopyWith<$Res> {
  factory $ApiExplorerModelCopyWith(
          ApiExplorerModel value, $Res Function(ApiExplorerModel) then) =
      _$ApiExplorerModelCopyWithImpl<$Res, ApiExplorerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String source,
      String description,
      DateTime updatedAt,
      String path,
      HTTPVerb method,
      String baseUrl,
      String operationId,
      List<NameValueModel> parameters,
      List<NameValueModel> headers,
      Map<String, dynamic>? requestBody,
      Map<String, dynamic>? responses,
      Map<String, dynamic> parameterSchemas,
      Map<String, dynamic> headerSchemas});
}

/// @nodoc
class _$ApiExplorerModelCopyWithImpl<$Res, $Val extends ApiExplorerModel>
    implements $ApiExplorerModelCopyWith<$Res> {
  _$ApiExplorerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiExplorerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? source = null,
    Object? description = null,
    Object? updatedAt = null,
    Object? path = null,
    Object? method = null,
    Object? baseUrl = null,
    Object? operationId = null,
    Object? parameters = null,
    Object? headers = null,
    Object? requestBody = freezed,
    Object? responses = freezed,
    Object? parameterSchemas = null,
    Object? headerSchemas = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      operationId: null == operationId
          ? _value.operationId
          : operationId // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      headers: null == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      requestBody: freezed == requestBody
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      responses: freezed == responses
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      parameterSchemas: null == parameterSchemas
          ? _value.parameterSchemas
          : parameterSchemas // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      headerSchemas: null == headerSchemas
          ? _value.headerSchemas
          : headerSchemas // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiExplorerModelImplCopyWith<$Res>
    implements $ApiExplorerModelCopyWith<$Res> {
  factory _$$ApiExplorerModelImplCopyWith(_$ApiExplorerModelImpl value,
          $Res Function(_$ApiExplorerModelImpl) then) =
      __$$ApiExplorerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String source,
      String description,
      DateTime updatedAt,
      String path,
      HTTPVerb method,
      String baseUrl,
      String operationId,
      List<NameValueModel> parameters,
      List<NameValueModel> headers,
      Map<String, dynamic>? requestBody,
      Map<String, dynamic>? responses,
      Map<String, dynamic> parameterSchemas,
      Map<String, dynamic> headerSchemas});
}

/// @nodoc
class __$$ApiExplorerModelImplCopyWithImpl<$Res>
    extends _$ApiExplorerModelCopyWithImpl<$Res, _$ApiExplorerModelImpl>
    implements _$$ApiExplorerModelImplCopyWith<$Res> {
  __$$ApiExplorerModelImplCopyWithImpl(_$ApiExplorerModelImpl _value,
      $Res Function(_$ApiExplorerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiExplorerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? source = null,
    Object? description = null,
    Object? updatedAt = null,
    Object? path = null,
    Object? method = null,
    Object? baseUrl = null,
    Object? operationId = null,
    Object? parameters = null,
    Object? headers = null,
    Object? requestBody = freezed,
    Object? responses = freezed,
    Object? parameterSchemas = null,
    Object? headerSchemas = null,
  }) {
    return _then(_$ApiExplorerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      operationId: null == operationId
          ? _value.operationId
          : operationId // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      headers: null == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      requestBody: freezed == requestBody
          ? _value._requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      responses: freezed == responses
          ? _value._responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      parameterSchemas: null == parameterSchemas
          ? _value._parameterSchemas
          : parameterSchemas // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      headerSchemas: null == headerSchemas
          ? _value._headerSchemas
          : headerSchemas // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ApiExplorerModelImpl extends _ApiExplorerModel {
  const _$ApiExplorerModelImpl(
      {required this.id,
      required this.name,
      required this.source,
      this.description = '',
      required this.updatedAt,
      required this.path,
      this.method = HTTPVerb.get,
      this.baseUrl = '',
      this.operationId = '',
      final List<NameValueModel> parameters = const [],
      final List<NameValueModel> headers = const [],
      final Map<String, dynamic>? requestBody,
      final Map<String, dynamic>? responses,
      final Map<String, dynamic> parameterSchemas = const {},
      final Map<String, dynamic> headerSchemas = const {}})
      : _parameters = parameters,
        _headers = headers,
        _requestBody = requestBody,
        _responses = responses,
        _parameterSchemas = parameterSchemas,
        _headerSchemas = headerSchemas,
        super._();

  factory _$ApiExplorerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiExplorerModelImplFromJson(json);

  /// Core identification
  @override
  final String id;
  @override
  final String name;
  @override
  final String source;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime updatedAt;

  /// Endpoint configuration
  @override
  final String path;
  @override
  @JsonKey()
  final HTTPVerb method;
  @override
  @JsonKey()
  final String baseUrl;
  @override
  @JsonKey()
  final String operationId;

  /// Request components
  final List<NameValueModel> _parameters;

  /// Request components
  @override
  @JsonKey()
  List<NameValueModel> get parameters {
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  final List<NameValueModel> _headers;
  @override
  @JsonKey()
  List<NameValueModel> get headers {
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_headers);
  }

  final Map<String, dynamic>? _requestBody;
  @override
  Map<String, dynamic>? get requestBody {
    final value = _requestBody;
    if (value == null) return null;
    if (_requestBody is EqualUnmodifiableMapView) return _requestBody;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _responses;
  @override
  Map<String, dynamic>? get responses {
    final value = _responses;
    if (value == null) return null;
    if (_responses is EqualUnmodifiableMapView) return _responses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Parameter metadata
  final Map<String, dynamic> _parameterSchemas;

  /// Parameter metadata
  @override
  @JsonKey()
  Map<String, dynamic> get parameterSchemas {
    if (_parameterSchemas is EqualUnmodifiableMapView) return _parameterSchemas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameterSchemas);
  }

  final Map<String, dynamic> _headerSchemas;
  @override
  @JsonKey()
  Map<String, dynamic> get headerSchemas {
    if (_headerSchemas is EqualUnmodifiableMapView) return _headerSchemas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_headerSchemas);
  }

  @override
  String toString() {
    return 'ApiExplorerModel(id: $id, name: $name, source: $source, description: $description, updatedAt: $updatedAt, path: $path, method: $method, baseUrl: $baseUrl, operationId: $operationId, parameters: $parameters, headers: $headers, requestBody: $requestBody, responses: $responses, parameterSchemas: $parameterSchemas, headerSchemas: $headerSchemas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiExplorerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.operationId, operationId) ||
                other.operationId == operationId) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._requestBody, _requestBody) &&
            const DeepCollectionEquality()
                .equals(other._responses, _responses) &&
            const DeepCollectionEquality()
                .equals(other._parameterSchemas, _parameterSchemas) &&
            const DeepCollectionEquality()
                .equals(other._headerSchemas, _headerSchemas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      source,
      description,
      updatedAt,
      path,
      method,
      baseUrl,
      operationId,
      const DeepCollectionEquality().hash(_parameters),
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_requestBody),
      const DeepCollectionEquality().hash(_responses),
      const DeepCollectionEquality().hash(_parameterSchemas),
      const DeepCollectionEquality().hash(_headerSchemas));

  /// Create a copy of ApiExplorerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiExplorerModelImplCopyWith<_$ApiExplorerModelImpl> get copyWith =>
      __$$ApiExplorerModelImplCopyWithImpl<_$ApiExplorerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiExplorerModelImplToJson(
      this,
    );
  }
}

abstract class _ApiExplorerModel extends ApiExplorerModel {
  const factory _ApiExplorerModel(
      {required final String id,
      required final String name,
      required final String source,
      final String description,
      required final DateTime updatedAt,
      required final String path,
      final HTTPVerb method,
      final String baseUrl,
      final String operationId,
      final List<NameValueModel> parameters,
      final List<NameValueModel> headers,
      final Map<String, dynamic>? requestBody,
      final Map<String, dynamic>? responses,
      final Map<String, dynamic> parameterSchemas,
      final Map<String, dynamic> headerSchemas}) = _$ApiExplorerModelImpl;
  const _ApiExplorerModel._() : super._();

  factory _ApiExplorerModel.fromJson(Map<String, dynamic> json) =
      _$ApiExplorerModelImpl.fromJson;

  /// Core identification
  @override
  String get id;
  @override
  String get name;
  @override
  String get source;
  @override
  String get description;
  @override
  DateTime get updatedAt;

  /// Endpoint configuration
  @override
  String get path;
  @override
  HTTPVerb get method;
  @override
  String get baseUrl;
  @override
  String get operationId;

  /// Request components
  @override
  List<NameValueModel> get parameters;
  @override
  List<NameValueModel> get headers;
  @override
  Map<String, dynamic>? get requestBody;
  @override
  Map<String, dynamic>? get responses;

  /// Parameter metadata
  @override
  Map<String, dynamic> get parameterSchemas;
  @override
  Map<String, dynamic> get headerSchemas;

  /// Create a copy of ApiExplorerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiExplorerModelImplCopyWith<_$ApiExplorerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
