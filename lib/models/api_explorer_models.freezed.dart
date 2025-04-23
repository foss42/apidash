// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_explorer_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiCollection _$ApiCollectionFromJson(Map<String, dynamic> json) {
  return _ApiCollection.fromJson(json);
}

/// @nodoc
mixin _$ApiCollection {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<ApiEndpoint> get endpoints => throw _privateConstructorUsedError;
  String? get sourceUrl => throw _privateConstructorUsedError;

  /// Serializes this ApiCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiCollectionCopyWith<ApiCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiCollectionCopyWith<$Res> {
  factory $ApiCollectionCopyWith(
          ApiCollection value, $Res Function(ApiCollection) then) =
      _$ApiCollectionCopyWithImpl<$Res, ApiCollection>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<ApiEndpoint> endpoints,
      String? sourceUrl});
}

/// @nodoc
class _$ApiCollectionCopyWithImpl<$Res, $Val extends ApiCollection>
    implements $ApiCollectionCopyWith<$Res> {
  _$ApiCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? endpoints = null,
    Object? sourceUrl = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      endpoints: null == endpoints
          ? _value.endpoints
          : endpoints // ignore: cast_nullable_to_non_nullable
              as List<ApiEndpoint>,
      sourceUrl: freezed == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiCollectionImplCopyWith<$Res>
    implements $ApiCollectionCopyWith<$Res> {
  factory _$$ApiCollectionImplCopyWith(
          _$ApiCollectionImpl value, $Res Function(_$ApiCollectionImpl) then) =
      __$$ApiCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<ApiEndpoint> endpoints,
      String? sourceUrl});
}

/// @nodoc
class __$$ApiCollectionImplCopyWithImpl<$Res>
    extends _$ApiCollectionCopyWithImpl<$Res, _$ApiCollectionImpl>
    implements _$$ApiCollectionImplCopyWith<$Res> {
  __$$ApiCollectionImplCopyWithImpl(
      _$ApiCollectionImpl _value, $Res Function(_$ApiCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? endpoints = null,
    Object? sourceUrl = freezed,
  }) {
    return _then(_$ApiCollectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      endpoints: null == endpoints
          ? _value._endpoints
          : endpoints // ignore: cast_nullable_to_non_nullable
              as List<ApiEndpoint>,
      sourceUrl: freezed == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiCollectionImpl implements _ApiCollection {
  const _$ApiCollectionImpl(
      {required this.id,
      required this.name,
      this.description,
      required final List<ApiEndpoint> endpoints,
      this.sourceUrl})
      : _endpoints = endpoints;

  factory _$ApiCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiCollectionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  final List<ApiEndpoint> _endpoints;
  @override
  List<ApiEndpoint> get endpoints {
    if (_endpoints is EqualUnmodifiableListView) return _endpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_endpoints);
  }

  @override
  final String? sourceUrl;

  @override
  String toString() {
    return 'ApiCollection(id: $id, name: $name, description: $description, endpoints: $endpoints, sourceUrl: $sourceUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiCollectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._endpoints, _endpoints) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      const DeepCollectionEquality().hash(_endpoints), sourceUrl);

  /// Create a copy of ApiCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiCollectionImplCopyWith<_$ApiCollectionImpl> get copyWith =>
      __$$ApiCollectionImplCopyWithImpl<_$ApiCollectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiCollectionImplToJson(
      this,
    );
  }
}

abstract class _ApiCollection implements ApiCollection {
  const factory _ApiCollection(
      {required final String id,
      required final String name,
      final String? description,
      required final List<ApiEndpoint> endpoints,
      final String? sourceUrl}) = _$ApiCollectionImpl;

  factory _ApiCollection.fromJson(Map<String, dynamic> json) =
      _$ApiCollectionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<ApiEndpoint> get endpoints;
  @override
  String? get sourceUrl;

  /// Create a copy of ApiCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiCollectionImplCopyWith<_$ApiCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiEndpoint _$ApiEndpointFromJson(Map<String, dynamic> json) {
  return _ApiEndpoint.fromJson(json);
}

/// @nodoc
mixin _$ApiEndpoint {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  HTTPVerb get method => throw _privateConstructorUsedError;
  String get baseUrl => throw _privateConstructorUsedError;
  List<ApiParameter>? get parameters => throw _privateConstructorUsedError;
  ApiRequestBody? get requestBody => throw _privateConstructorUsedError;
  Map<String, ApiHeader>? get headers => throw _privateConstructorUsedError;
  Map<String, ApiResponse>? get responses => throw _privateConstructorUsedError;

  /// Serializes this ApiEndpoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiEndpointCopyWith<ApiEndpoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiEndpointCopyWith<$Res> {
  factory $ApiEndpointCopyWith(
          ApiEndpoint value, $Res Function(ApiEndpoint) then) =
      _$ApiEndpointCopyWithImpl<$Res, ApiEndpoint>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String path,
      HTTPVerb method,
      String baseUrl,
      List<ApiParameter>? parameters,
      ApiRequestBody? requestBody,
      Map<String, ApiHeader>? headers,
      Map<String, ApiResponse>? responses});

  $ApiRequestBodyCopyWith<$Res>? get requestBody;
}

/// @nodoc
class _$ApiEndpointCopyWithImpl<$Res, $Val extends ApiEndpoint>
    implements $ApiEndpointCopyWith<$Res> {
  _$ApiEndpointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? path = null,
    Object? method = null,
    Object? baseUrl = null,
    Object? parameters = freezed,
    Object? requestBody = freezed,
    Object? headers = freezed,
    Object? responses = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<ApiParameter>?,
      requestBody: freezed == requestBody
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as ApiRequestBody?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiHeader>?,
      responses: freezed == responses
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiResponse>?,
    ) as $Val);
  }

  /// Create a copy of ApiEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiRequestBodyCopyWith<$Res>? get requestBody {
    if (_value.requestBody == null) {
      return null;
    }

    return $ApiRequestBodyCopyWith<$Res>(_value.requestBody!, (value) {
      return _then(_value.copyWith(requestBody: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiEndpointImplCopyWith<$Res>
    implements $ApiEndpointCopyWith<$Res> {
  factory _$$ApiEndpointImplCopyWith(
          _$ApiEndpointImpl value, $Res Function(_$ApiEndpointImpl) then) =
      __$$ApiEndpointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String path,
      HTTPVerb method,
      String baseUrl,
      List<ApiParameter>? parameters,
      ApiRequestBody? requestBody,
      Map<String, ApiHeader>? headers,
      Map<String, ApiResponse>? responses});

  @override
  $ApiRequestBodyCopyWith<$Res>? get requestBody;
}

/// @nodoc
class __$$ApiEndpointImplCopyWithImpl<$Res>
    extends _$ApiEndpointCopyWithImpl<$Res, _$ApiEndpointImpl>
    implements _$$ApiEndpointImplCopyWith<$Res> {
  __$$ApiEndpointImplCopyWithImpl(
      _$ApiEndpointImpl _value, $Res Function(_$ApiEndpointImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? path = null,
    Object? method = null,
    Object? baseUrl = null,
    Object? parameters = freezed,
    Object? requestBody = freezed,
    Object? headers = freezed,
    Object? responses = freezed,
  }) {
    return _then(_$ApiEndpointImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<ApiParameter>?,
      requestBody: freezed == requestBody
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as ApiRequestBody?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiHeader>?,
      responses: freezed == responses
          ? _value._responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiResponse>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiEndpointImpl implements _ApiEndpoint {
  const _$ApiEndpointImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.path,
      required this.method,
      required this.baseUrl,
      final List<ApiParameter>? parameters,
      this.requestBody,
      final Map<String, ApiHeader>? headers,
      final Map<String, ApiResponse>? responses})
      : _parameters = parameters,
        _headers = headers,
        _responses = responses;

  factory _$ApiEndpointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiEndpointImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String path;
  @override
  final HTTPVerb method;
  @override
  final String baseUrl;
  final List<ApiParameter>? _parameters;
  @override
  List<ApiParameter>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ApiRequestBody? requestBody;
  final Map<String, ApiHeader>? _headers;
  @override
  Map<String, ApiHeader>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, ApiResponse>? _responses;
  @override
  Map<String, ApiResponse>? get responses {
    final value = _responses;
    if (value == null) return null;
    if (_responses is EqualUnmodifiableMapView) return _responses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ApiEndpoint(id: $id, name: $name, description: $description, path: $path, method: $method, baseUrl: $baseUrl, parameters: $parameters, requestBody: $requestBody, headers: $headers, responses: $responses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiEndpointImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            (identical(other.requestBody, requestBody) ||
                other.requestBody == requestBody) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._responses, _responses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      path,
      method,
      baseUrl,
      const DeepCollectionEquality().hash(_parameters),
      requestBody,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_responses));

  /// Create a copy of ApiEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiEndpointImplCopyWith<_$ApiEndpointImpl> get copyWith =>
      __$$ApiEndpointImplCopyWithImpl<_$ApiEndpointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiEndpointImplToJson(
      this,
    );
  }
}

abstract class _ApiEndpoint implements ApiEndpoint {
  const factory _ApiEndpoint(
      {required final String id,
      required final String name,
      final String? description,
      required final String path,
      required final HTTPVerb method,
      required final String baseUrl,
      final List<ApiParameter>? parameters,
      final ApiRequestBody? requestBody,
      final Map<String, ApiHeader>? headers,
      final Map<String, ApiResponse>? responses}) = _$ApiEndpointImpl;

  factory _ApiEndpoint.fromJson(Map<String, dynamic> json) =
      _$ApiEndpointImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get path;
  @override
  HTTPVerb get method;
  @override
  String get baseUrl;
  @override
  List<ApiParameter>? get parameters;
  @override
  ApiRequestBody? get requestBody;
  @override
  Map<String, ApiHeader>? get headers;
  @override
  Map<String, ApiResponse>? get responses;

  /// Create a copy of ApiEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiEndpointImplCopyWith<_$ApiEndpointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiParameter _$ApiParameterFromJson(Map<String, dynamic> json) {
  return _ApiParameter.fromJson(json);
}

/// @nodoc
mixin _$ApiParameter {
  String get name => throw _privateConstructorUsedError;
  String get inLocation => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  ApiSchema? get schema => throw _privateConstructorUsedError;
  String? get example => throw _privateConstructorUsedError;

  /// Serializes this ApiParameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiParameterCopyWith<ApiParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiParameterCopyWith<$Res> {
  factory $ApiParameterCopyWith(
          ApiParameter value, $Res Function(ApiParameter) then) =
      _$ApiParameterCopyWithImpl<$Res, ApiParameter>;
  @useResult
  $Res call(
      {String name,
      String inLocation,
      String? description,
      bool required,
      ApiSchema? schema,
      String? example});

  $ApiSchemaCopyWith<$Res>? get schema;
}

/// @nodoc
class _$ApiParameterCopyWithImpl<$Res, $Val extends ApiParameter>
    implements $ApiParameterCopyWith<$Res> {
  _$ApiParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? inLocation = null,
    Object? description = freezed,
    Object? required = null,
    Object? schema = freezed,
    Object? example = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inLocation: null == inLocation
          ? _value.inLocation
          : inLocation // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as ApiSchema?,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ApiParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiSchemaCopyWith<$Res>? get schema {
    if (_value.schema == null) {
      return null;
    }

    return $ApiSchemaCopyWith<$Res>(_value.schema!, (value) {
      return _then(_value.copyWith(schema: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiParameterImplCopyWith<$Res>
    implements $ApiParameterCopyWith<$Res> {
  factory _$$ApiParameterImplCopyWith(
          _$ApiParameterImpl value, $Res Function(_$ApiParameterImpl) then) =
      __$$ApiParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String inLocation,
      String? description,
      bool required,
      ApiSchema? schema,
      String? example});

  @override
  $ApiSchemaCopyWith<$Res>? get schema;
}

/// @nodoc
class __$$ApiParameterImplCopyWithImpl<$Res>
    extends _$ApiParameterCopyWithImpl<$Res, _$ApiParameterImpl>
    implements _$$ApiParameterImplCopyWith<$Res> {
  __$$ApiParameterImplCopyWithImpl(
      _$ApiParameterImpl _value, $Res Function(_$ApiParameterImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? inLocation = null,
    Object? description = freezed,
    Object? required = null,
    Object? schema = freezed,
    Object? example = freezed,
  }) {
    return _then(_$ApiParameterImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inLocation: null == inLocation
          ? _value.inLocation
          : inLocation // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as ApiSchema?,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiParameterImpl implements _ApiParameter {
  const _$ApiParameterImpl(
      {required this.name,
      required this.inLocation,
      this.description,
      required this.required,
      this.schema,
      this.example});

  factory _$ApiParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiParameterImplFromJson(json);

  @override
  final String name;
  @override
  final String inLocation;
  @override
  final String? description;
  @override
  final bool required;
  @override
  final ApiSchema? schema;
  @override
  final String? example;

  @override
  String toString() {
    return 'ApiParameter(name: $name, inLocation: $inLocation, description: $description, required: $required, schema: $schema, example: $example)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiParameterImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inLocation, inLocation) ||
                other.inLocation == inLocation) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.schema, schema) || other.schema == schema) &&
            (identical(other.example, example) || other.example == example));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, inLocation, description, required, schema, example);

  /// Create a copy of ApiParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiParameterImplCopyWith<_$ApiParameterImpl> get copyWith =>
      __$$ApiParameterImplCopyWithImpl<_$ApiParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiParameterImplToJson(
      this,
    );
  }
}

abstract class _ApiParameter implements ApiParameter {
  const factory _ApiParameter(
      {required final String name,
      required final String inLocation,
      final String? description,
      required final bool required,
      final ApiSchema? schema,
      final String? example}) = _$ApiParameterImpl;

  factory _ApiParameter.fromJson(Map<String, dynamic> json) =
      _$ApiParameterImpl.fromJson;

  @override
  String get name;
  @override
  String get inLocation;
  @override
  String? get description;
  @override
  bool get required;
  @override
  ApiSchema? get schema;
  @override
  String? get example;

  /// Create a copy of ApiParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiParameterImplCopyWith<_$ApiParameterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiRequestBody _$ApiRequestBodyFromJson(Map<String, dynamic> json) {
  return _ApiRequestBody.fromJson(json);
}

/// @nodoc
mixin _$ApiRequestBody {
  String? get description => throw _privateConstructorUsedError;
  Map<String, ApiContent> get content => throw _privateConstructorUsedError;

  /// Serializes this ApiRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiRequestBodyCopyWith<ApiRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiRequestBodyCopyWith<$Res> {
  factory $ApiRequestBodyCopyWith(
          ApiRequestBody value, $Res Function(ApiRequestBody) then) =
      _$ApiRequestBodyCopyWithImpl<$Res, ApiRequestBody>;
  @useResult
  $Res call({String? description, Map<String, ApiContent> content});
}

/// @nodoc
class _$ApiRequestBodyCopyWithImpl<$Res, $Val extends ApiRequestBody>
    implements $ApiRequestBodyCopyWith<$Res> {
  _$ApiRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiContent>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiRequestBodyImplCopyWith<$Res>
    implements $ApiRequestBodyCopyWith<$Res> {
  factory _$$ApiRequestBodyImplCopyWith(_$ApiRequestBodyImpl value,
          $Res Function(_$ApiRequestBodyImpl) then) =
      __$$ApiRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? description, Map<String, ApiContent> content});
}

/// @nodoc
class __$$ApiRequestBodyImplCopyWithImpl<$Res>
    extends _$ApiRequestBodyCopyWithImpl<$Res, _$ApiRequestBodyImpl>
    implements _$$ApiRequestBodyImplCopyWith<$Res> {
  __$$ApiRequestBodyImplCopyWithImpl(
      _$ApiRequestBodyImpl _value, $Res Function(_$ApiRequestBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? content = null,
  }) {
    return _then(_$ApiRequestBodyImpl(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiContent>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiRequestBodyImpl implements _ApiRequestBody {
  const _$ApiRequestBodyImpl(
      {this.description, required final Map<String, ApiContent> content})
      : _content = content;

  factory _$ApiRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiRequestBodyImplFromJson(json);

  @override
  final String? description;
  final Map<String, ApiContent> _content;
  @override
  Map<String, ApiContent> get content {
    if (_content is EqualUnmodifiableMapView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_content);
  }

  @override
  String toString() {
    return 'ApiRequestBody(description: $description, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiRequestBodyImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._content, _content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, description, const DeepCollectionEquality().hash(_content));

  /// Create a copy of ApiRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiRequestBodyImplCopyWith<_$ApiRequestBodyImpl> get copyWith =>
      __$$ApiRequestBodyImplCopyWithImpl<_$ApiRequestBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _ApiRequestBody implements ApiRequestBody {
  const factory _ApiRequestBody(
      {final String? description,
      required final Map<String, ApiContent> content}) = _$ApiRequestBodyImpl;

  factory _ApiRequestBody.fromJson(Map<String, dynamic> json) =
      _$ApiRequestBodyImpl.fromJson;

  @override
  String? get description;
  @override
  Map<String, ApiContent> get content;

  /// Create a copy of ApiRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiRequestBodyImplCopyWith<_$ApiRequestBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiHeader _$ApiHeaderFromJson(Map<String, dynamic> json) {
  return _ApiHeader.fromJson(json);
}

/// @nodoc
mixin _$ApiHeader {
  String? get description => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  ApiSchema? get schema => throw _privateConstructorUsedError;
  String? get example => throw _privateConstructorUsedError;

  /// Serializes this ApiHeader to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiHeader
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiHeaderCopyWith<ApiHeader> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiHeaderCopyWith<$Res> {
  factory $ApiHeaderCopyWith(ApiHeader value, $Res Function(ApiHeader) then) =
      _$ApiHeaderCopyWithImpl<$Res, ApiHeader>;
  @useResult
  $Res call(
      {String? description, bool required, ApiSchema? schema, String? example});

  $ApiSchemaCopyWith<$Res>? get schema;
}

/// @nodoc
class _$ApiHeaderCopyWithImpl<$Res, $Val extends ApiHeader>
    implements $ApiHeaderCopyWith<$Res> {
  _$ApiHeaderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiHeader
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? required = null,
    Object? schema = freezed,
    Object? example = freezed,
  }) {
    return _then(_value.copyWith(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as ApiSchema?,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ApiHeader
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiSchemaCopyWith<$Res>? get schema {
    if (_value.schema == null) {
      return null;
    }

    return $ApiSchemaCopyWith<$Res>(_value.schema!, (value) {
      return _then(_value.copyWith(schema: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiHeaderImplCopyWith<$Res>
    implements $ApiHeaderCopyWith<$Res> {
  factory _$$ApiHeaderImplCopyWith(
          _$ApiHeaderImpl value, $Res Function(_$ApiHeaderImpl) then) =
      __$$ApiHeaderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? description, bool required, ApiSchema? schema, String? example});

  @override
  $ApiSchemaCopyWith<$Res>? get schema;
}

/// @nodoc
class __$$ApiHeaderImplCopyWithImpl<$Res>
    extends _$ApiHeaderCopyWithImpl<$Res, _$ApiHeaderImpl>
    implements _$$ApiHeaderImplCopyWith<$Res> {
  __$$ApiHeaderImplCopyWithImpl(
      _$ApiHeaderImpl _value, $Res Function(_$ApiHeaderImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiHeader
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? required = null,
    Object? schema = freezed,
    Object? example = freezed,
  }) {
    return _then(_$ApiHeaderImpl(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as ApiSchema?,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiHeaderImpl implements _ApiHeader {
  const _$ApiHeaderImpl(
      {this.description, required this.required, this.schema, this.example});

  factory _$ApiHeaderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiHeaderImplFromJson(json);

  @override
  final String? description;
  @override
  final bool required;
  @override
  final ApiSchema? schema;
  @override
  final String? example;

  @override
  String toString() {
    return 'ApiHeader(description: $description, required: $required, schema: $schema, example: $example)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiHeaderImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.schema, schema) || other.schema == schema) &&
            (identical(other.example, example) || other.example == example));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, description, required, schema, example);

  /// Create a copy of ApiHeader
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiHeaderImplCopyWith<_$ApiHeaderImpl> get copyWith =>
      __$$ApiHeaderImplCopyWithImpl<_$ApiHeaderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiHeaderImplToJson(
      this,
    );
  }
}

abstract class _ApiHeader implements ApiHeader {
  const factory _ApiHeader(
      {final String? description,
      required final bool required,
      final ApiSchema? schema,
      final String? example}) = _$ApiHeaderImpl;

  factory _ApiHeader.fromJson(Map<String, dynamic> json) =
      _$ApiHeaderImpl.fromJson;

  @override
  String? get description;
  @override
  bool get required;
  @override
  ApiSchema? get schema;
  @override
  String? get example;

  /// Create a copy of ApiHeader
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiHeaderImplCopyWith<_$ApiHeaderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) {
  return _ApiResponse.fromJson(json);
}

/// @nodoc
mixin _$ApiResponse {
  String? get description => throw _privateConstructorUsedError;
  Map<String, ApiContent>? get content => throw _privateConstructorUsedError;

  /// Serializes this ApiResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiResponseCopyWith<ApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseCopyWith<$Res> {
  factory $ApiResponseCopyWith(
          ApiResponse value, $Res Function(ApiResponse) then) =
      _$ApiResponseCopyWithImpl<$Res, ApiResponse>;
  @useResult
  $Res call({String? description, Map<String, ApiContent>? content});
}

/// @nodoc
class _$ApiResponseCopyWithImpl<$Res, $Val extends ApiResponse>
    implements $ApiResponseCopyWith<$Res> {
  _$ApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? content = freezed,
  }) {
    return _then(_value.copyWith(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiContent>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseImplCopyWith<$Res>
    implements $ApiResponseCopyWith<$Res> {
  factory _$$ApiResponseImplCopyWith(
          _$ApiResponseImpl value, $Res Function(_$ApiResponseImpl) then) =
      __$$ApiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? description, Map<String, ApiContent>? content});
}

/// @nodoc
class __$$ApiResponseImplCopyWithImpl<$Res>
    extends _$ApiResponseCopyWithImpl<$Res, _$ApiResponseImpl>
    implements _$$ApiResponseImplCopyWith<$Res> {
  __$$ApiResponseImplCopyWithImpl(
      _$ApiResponseImpl _value, $Res Function(_$ApiResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? content = freezed,
  }) {
    return _then(_$ApiResponseImpl(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiContent>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiResponseImpl implements _ApiResponse {
  const _$ApiResponseImpl(
      {this.description, final Map<String, ApiContent>? content})
      : _content = content;

  factory _$ApiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiResponseImplFromJson(json);

  @override
  final String? description;
  final Map<String, ApiContent>? _content;
  @override
  Map<String, ApiContent>? get content {
    final value = _content;
    if (value == null) return null;
    if (_content is EqualUnmodifiableMapView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ApiResponse(description: $description, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._content, _content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, description, const DeepCollectionEquality().hash(_content));

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      __$$ApiResponseImplCopyWithImpl<_$ApiResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiResponseImplToJson(
      this,
    );
  }
}

abstract class _ApiResponse implements ApiResponse {
  const factory _ApiResponse(
      {final String? description,
      final Map<String, ApiContent>? content}) = _$ApiResponseImpl;

  factory _ApiResponse.fromJson(Map<String, dynamic> json) =
      _$ApiResponseImpl.fromJson;

  @override
  String? get description;
  @override
  Map<String, ApiContent>? get content;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiContent _$ApiContentFromJson(Map<String, dynamic> json) {
  return _ApiContent.fromJson(json);
}

/// @nodoc
mixin _$ApiContent {
  ApiSchema get schema => throw _privateConstructorUsedError;

  /// Serializes this ApiContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiContentCopyWith<ApiContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiContentCopyWith<$Res> {
  factory $ApiContentCopyWith(
          ApiContent value, $Res Function(ApiContent) then) =
      _$ApiContentCopyWithImpl<$Res, ApiContent>;
  @useResult
  $Res call({ApiSchema schema});

  $ApiSchemaCopyWith<$Res> get schema;
}

/// @nodoc
class _$ApiContentCopyWithImpl<$Res, $Val extends ApiContent>
    implements $ApiContentCopyWith<$Res> {
  _$ApiContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schema = null,
  }) {
    return _then(_value.copyWith(
      schema: null == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as ApiSchema,
    ) as $Val);
  }

  /// Create a copy of ApiContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiSchemaCopyWith<$Res> get schema {
    return $ApiSchemaCopyWith<$Res>(_value.schema, (value) {
      return _then(_value.copyWith(schema: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiContentImplCopyWith<$Res>
    implements $ApiContentCopyWith<$Res> {
  factory _$$ApiContentImplCopyWith(
          _$ApiContentImpl value, $Res Function(_$ApiContentImpl) then) =
      __$$ApiContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ApiSchema schema});

  @override
  $ApiSchemaCopyWith<$Res> get schema;
}

/// @nodoc
class __$$ApiContentImplCopyWithImpl<$Res>
    extends _$ApiContentCopyWithImpl<$Res, _$ApiContentImpl>
    implements _$$ApiContentImplCopyWith<$Res> {
  __$$ApiContentImplCopyWithImpl(
      _$ApiContentImpl _value, $Res Function(_$ApiContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schema = null,
  }) {
    return _then(_$ApiContentImpl(
      schema: null == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as ApiSchema,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiContentImpl implements _ApiContent {
  const _$ApiContentImpl({required this.schema});

  factory _$ApiContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiContentImplFromJson(json);

  @override
  final ApiSchema schema;

  @override
  String toString() {
    return 'ApiContent(schema: $schema)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiContentImpl &&
            (identical(other.schema, schema) || other.schema == schema));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, schema);

  /// Create a copy of ApiContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiContentImplCopyWith<_$ApiContentImpl> get copyWith =>
      __$$ApiContentImplCopyWithImpl<_$ApiContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiContentImplToJson(
      this,
    );
  }
}

abstract class _ApiContent implements ApiContent {
  const factory _ApiContent({required final ApiSchema schema}) =
      _$ApiContentImpl;

  factory _ApiContent.fromJson(Map<String, dynamic> json) =
      _$ApiContentImpl.fromJson;

  @override
  ApiSchema get schema;

  /// Create a copy of ApiContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiContentImplCopyWith<_$ApiContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiSchema _$ApiSchemaFromJson(Map<String, dynamic> json) {
  return _ApiSchema.fromJson(json);
}

/// @nodoc
mixin _$ApiSchema {
  String? get type => throw _privateConstructorUsedError;
  String? get format => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get example => throw _privateConstructorUsedError;
  ApiSchema? get items => throw _privateConstructorUsedError;
  Map<String, ApiSchema>? get properties => throw _privateConstructorUsedError;

  /// Serializes this ApiSchema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiSchemaCopyWith<ApiSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiSchemaCopyWith<$Res> {
  factory $ApiSchemaCopyWith(ApiSchema value, $Res Function(ApiSchema) then) =
      _$ApiSchemaCopyWithImpl<$Res, ApiSchema>;
  @useResult
  $Res call(
      {String? type,
      String? format,
      String? description,
      String? example,
      ApiSchema? items,
      Map<String, ApiSchema>? properties});

  $ApiSchemaCopyWith<$Res>? get items;
}

/// @nodoc
class _$ApiSchemaCopyWithImpl<$Res, $Val extends ApiSchema>
    implements $ApiSchemaCopyWith<$Res> {
  _$ApiSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? format = freezed,
    Object? description = freezed,
    Object? example = freezed,
    Object? items = freezed,
    Object? properties = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as ApiSchema?,
      properties: freezed == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiSchema>?,
    ) as $Val);
  }

  /// Create a copy of ApiSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiSchemaCopyWith<$Res>? get items {
    if (_value.items == null) {
      return null;
    }

    return $ApiSchemaCopyWith<$Res>(_value.items!, (value) {
      return _then(_value.copyWith(items: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiSchemaImplCopyWith<$Res>
    implements $ApiSchemaCopyWith<$Res> {
  factory _$$ApiSchemaImplCopyWith(
          _$ApiSchemaImpl value, $Res Function(_$ApiSchemaImpl) then) =
      __$$ApiSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? type,
      String? format,
      String? description,
      String? example,
      ApiSchema? items,
      Map<String, ApiSchema>? properties});

  @override
  $ApiSchemaCopyWith<$Res>? get items;
}

/// @nodoc
class __$$ApiSchemaImplCopyWithImpl<$Res>
    extends _$ApiSchemaCopyWithImpl<$Res, _$ApiSchemaImpl>
    implements _$$ApiSchemaImplCopyWith<$Res> {
  __$$ApiSchemaImplCopyWithImpl(
      _$ApiSchemaImpl _value, $Res Function(_$ApiSchemaImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? format = freezed,
    Object? description = freezed,
    Object? example = freezed,
    Object? items = freezed,
    Object? properties = freezed,
  }) {
    return _then(_$ApiSchemaImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as ApiSchema?,
      properties: freezed == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, ApiSchema>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiSchemaImpl implements _ApiSchema {
  const _$ApiSchemaImpl(
      {this.type,
      this.format,
      this.description,
      this.example,
      this.items,
      final Map<String, ApiSchema>? properties})
      : _properties = properties;

  factory _$ApiSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiSchemaImplFromJson(json);

  @override
  final String? type;
  @override
  final String? format;
  @override
  final String? description;
  @override
  final String? example;
  @override
  final ApiSchema? items;
  final Map<String, ApiSchema>? _properties;
  @override
  Map<String, ApiSchema>? get properties {
    final value = _properties;
    if (value == null) return null;
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ApiSchema(type: $type, format: $format, description: $description, example: $example, items: $items, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiSchemaImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.example, example) || other.example == example) &&
            (identical(other.items, items) || other.items == items) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, format, description,
      example, items, const DeepCollectionEquality().hash(_properties));

  /// Create a copy of ApiSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiSchemaImplCopyWith<_$ApiSchemaImpl> get copyWith =>
      __$$ApiSchemaImplCopyWithImpl<_$ApiSchemaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiSchemaImplToJson(
      this,
    );
  }
}

abstract class _ApiSchema implements ApiSchema {
  const factory _ApiSchema(
      {final String? type,
      final String? format,
      final String? description,
      final String? example,
      final ApiSchema? items,
      final Map<String, ApiSchema>? properties}) = _$ApiSchemaImpl;

  factory _ApiSchema.fromJson(Map<String, dynamic> json) =
      _$ApiSchemaImpl.fromJson;

  @override
  String? get type;
  @override
  String? get format;
  @override
  String? get description;
  @override
  String? get example;
  @override
  ApiSchema? get items;
  @override
  Map<String, ApiSchema>? get properties;

  /// Create a copy of ApiSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiSchemaImplCopyWith<_$ApiSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
