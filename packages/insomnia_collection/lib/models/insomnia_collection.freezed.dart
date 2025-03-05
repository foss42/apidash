// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insomnia_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InsomniaCollection _$InsomniaCollectionFromJson(Map<String, dynamic> json) {
  return _InsomniaCollection.fromJson(json);
}

/// @nodoc
mixin _$InsomniaCollection {
  @JsonKey(name: '_type')
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: '__export_format')
  num? get exportFormat => throw _privateConstructorUsedError;
  @JsonKey(name: '__export_date')
  String? get exportDate => throw _privateConstructorUsedError;
  @JsonKey(name: '__export_source')
  String? get exportSource => throw _privateConstructorUsedError;
  List<Resource>? get resources => throw _privateConstructorUsedError;

  /// Serializes this InsomniaCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsomniaCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsomniaCollectionCopyWith<InsomniaCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsomniaCollectionCopyWith<$Res> {
  factory $InsomniaCollectionCopyWith(
          InsomniaCollection value, $Res Function(InsomniaCollection) then) =
      _$InsomniaCollectionCopyWithImpl<$Res, InsomniaCollection>;
  @useResult
  $Res call(
      {@JsonKey(name: '_type') String? type,
      @JsonKey(name: '__export_format') num? exportFormat,
      @JsonKey(name: '__export_date') String? exportDate,
      @JsonKey(name: '__export_source') String? exportSource,
      List<Resource>? resources});
}

/// @nodoc
class _$InsomniaCollectionCopyWithImpl<$Res, $Val extends InsomniaCollection>
    implements $InsomniaCollectionCopyWith<$Res> {
  _$InsomniaCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsomniaCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? exportFormat = freezed,
    Object? exportDate = freezed,
    Object? exportSource = freezed,
    Object? resources = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      exportFormat: freezed == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as num?,
      exportDate: freezed == exportDate
          ? _value.exportDate
          : exportDate // ignore: cast_nullable_to_non_nullable
              as String?,
      exportSource: freezed == exportSource
          ? _value.exportSource
          : exportSource // ignore: cast_nullable_to_non_nullable
              as String?,
      resources: freezed == resources
          ? _value.resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<Resource>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsomniaCollectionImplCopyWith<$Res>
    implements $InsomniaCollectionCopyWith<$Res> {
  factory _$$InsomniaCollectionImplCopyWith(_$InsomniaCollectionImpl value,
          $Res Function(_$InsomniaCollectionImpl) then) =
      __$$InsomniaCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_type') String? type,
      @JsonKey(name: '__export_format') num? exportFormat,
      @JsonKey(name: '__export_date') String? exportDate,
      @JsonKey(name: '__export_source') String? exportSource,
      List<Resource>? resources});
}

/// @nodoc
class __$$InsomniaCollectionImplCopyWithImpl<$Res>
    extends _$InsomniaCollectionCopyWithImpl<$Res, _$InsomniaCollectionImpl>
    implements _$$InsomniaCollectionImplCopyWith<$Res> {
  __$$InsomniaCollectionImplCopyWithImpl(_$InsomniaCollectionImpl _value,
      $Res Function(_$InsomniaCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsomniaCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? exportFormat = freezed,
    Object? exportDate = freezed,
    Object? exportSource = freezed,
    Object? resources = freezed,
  }) {
    return _then(_$InsomniaCollectionImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      exportFormat: freezed == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as num?,
      exportDate: freezed == exportDate
          ? _value.exportDate
          : exportDate // ignore: cast_nullable_to_non_nullable
              as String?,
      exportSource: freezed == exportSource
          ? _value.exportSource
          : exportSource // ignore: cast_nullable_to_non_nullable
              as String?,
      resources: freezed == resources
          ? _value._resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<Resource>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$InsomniaCollectionImpl implements _InsomniaCollection {
  const _$InsomniaCollectionImpl(
      {@JsonKey(name: '_type') this.type,
      @JsonKey(name: '__export_format') this.exportFormat,
      @JsonKey(name: '__export_date') this.exportDate,
      @JsonKey(name: '__export_source') this.exportSource,
      final List<Resource>? resources})
      : _resources = resources;

  factory _$InsomniaCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsomniaCollectionImplFromJson(json);

  @override
  @JsonKey(name: '_type')
  final String? type;
  @override
  @JsonKey(name: '__export_format')
  final num? exportFormat;
  @override
  @JsonKey(name: '__export_date')
  final String? exportDate;
  @override
  @JsonKey(name: '__export_source')
  final String? exportSource;
  final List<Resource>? _resources;
  @override
  List<Resource>? get resources {
    final value = _resources;
    if (value == null) return null;
    if (_resources is EqualUnmodifiableListView) return _resources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'InsomniaCollection(type: $type, exportFormat: $exportFormat, exportDate: $exportDate, exportSource: $exportSource, resources: $resources)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsomniaCollectionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.exportFormat, exportFormat) ||
                other.exportFormat == exportFormat) &&
            (identical(other.exportDate, exportDate) ||
                other.exportDate == exportDate) &&
            (identical(other.exportSource, exportSource) ||
                other.exportSource == exportSource) &&
            const DeepCollectionEquality()
                .equals(other._resources, _resources));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, exportFormat, exportDate,
      exportSource, const DeepCollectionEquality().hash(_resources));

  /// Create a copy of InsomniaCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsomniaCollectionImplCopyWith<_$InsomniaCollectionImpl> get copyWith =>
      __$$InsomniaCollectionImplCopyWithImpl<_$InsomniaCollectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsomniaCollectionImplToJson(
      this,
    );
  }
}

abstract class _InsomniaCollection implements InsomniaCollection {
  const factory _InsomniaCollection(
      {@JsonKey(name: '_type') final String? type,
      @JsonKey(name: '__export_format') final num? exportFormat,
      @JsonKey(name: '__export_date') final String? exportDate,
      @JsonKey(name: '__export_source') final String? exportSource,
      final List<Resource>? resources}) = _$InsomniaCollectionImpl;

  factory _InsomniaCollection.fromJson(Map<String, dynamic> json) =
      _$InsomniaCollectionImpl.fromJson;

  @override
  @JsonKey(name: '_type')
  String? get type;
  @override
  @JsonKey(name: '__export_format')
  num? get exportFormat;
  @override
  @JsonKey(name: '__export_date')
  String? get exportDate;
  @override
  @JsonKey(name: '__export_source')
  String? get exportSource;
  @override
  List<Resource>? get resources;

  /// Create a copy of InsomniaCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsomniaCollectionImplCopyWith<_$InsomniaCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Resource _$ResourceFromJson(Map<String, dynamic> json) {
  return _Resource.fromJson(json);
}

/// @nodoc
mixin _$Resource {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  num? get modified => throw _privateConstructorUsedError;
  num? get created => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get method => throw _privateConstructorUsedError;
  Body? get body => throw _privateConstructorUsedError;
  String? get preRequestScript => throw _privateConstructorUsedError;
  List<Parameter>? get parameters => throw _privateConstructorUsedError;
  List<Header>? get headers => throw _privateConstructorUsedError;
  dynamic get authentication => throw _privateConstructorUsedError;
  num? get metaSortKey => throw _privateConstructorUsedError;
  bool? get isPrivate => throw _privateConstructorUsedError;
  List<dynamic>? get pathParameters => throw _privateConstructorUsedError;
  String? get afterResponseScript => throw _privateConstructorUsedError;
  bool? get settingStoreCookies => throw _privateConstructorUsedError;
  bool? get settingSendCookies => throw _privateConstructorUsedError;
  bool? get settingDisableRenderRequestBody =>
      throw _privateConstructorUsedError;
  bool? get settingEncodeUrl => throw _privateConstructorUsedError;
  bool? get settingRebuildPath => throw _privateConstructorUsedError;
  String? get settingFollowRedirects => throw _privateConstructorUsedError;
  dynamic get environment => throw _privateConstructorUsedError;
  dynamic get environmentPropertyOrder => throw _privateConstructorUsedError;
  String? get scope => throw _privateConstructorUsedError;
  dynamic get data => throw _privateConstructorUsedError;
  dynamic get dataPropertyOrder => throw _privateConstructorUsedError;
  dynamic get color => throw _privateConstructorUsedError;
  List<Cookie>? get cookies => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  String? get contents => throw _privateConstructorUsedError;
  String? get contentType => throw _privateConstructorUsedError;
  String? get environmentType => throw _privateConstructorUsedError;
  List<KVPairDatum>? get kvPairData => throw _privateConstructorUsedError;
  @JsonKey(name: '_type')
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this Resource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Resource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResourceCopyWith<Resource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResourceCopyWith<$Res> {
  factory $ResourceCopyWith(Resource value, $Res Function(Resource) then) =
      _$ResourceCopyWithImpl<$Res, Resource>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? parentId,
      num? modified,
      num? created,
      String? url,
      String? name,
      String? description,
      String? method,
      Body? body,
      String? preRequestScript,
      List<Parameter>? parameters,
      List<Header>? headers,
      dynamic authentication,
      num? metaSortKey,
      bool? isPrivate,
      List<dynamic>? pathParameters,
      String? afterResponseScript,
      bool? settingStoreCookies,
      bool? settingSendCookies,
      bool? settingDisableRenderRequestBody,
      bool? settingEncodeUrl,
      bool? settingRebuildPath,
      String? settingFollowRedirects,
      dynamic environment,
      dynamic environmentPropertyOrder,
      String? scope,
      dynamic data,
      dynamic dataPropertyOrder,
      dynamic color,
      List<Cookie>? cookies,
      String? fileName,
      String? contents,
      String? contentType,
      String? environmentType,
      List<KVPairDatum>? kvPairData,
      @JsonKey(name: '_type') String? type});

  $BodyCopyWith<$Res>? get body;
}

/// @nodoc
class _$ResourceCopyWithImpl<$Res, $Val extends Resource>
    implements $ResourceCopyWith<$Res> {
  _$ResourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Resource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? parentId = freezed,
    Object? modified = freezed,
    Object? created = freezed,
    Object? url = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? method = freezed,
    Object? body = freezed,
    Object? preRequestScript = freezed,
    Object? parameters = freezed,
    Object? headers = freezed,
    Object? authentication = freezed,
    Object? metaSortKey = freezed,
    Object? isPrivate = freezed,
    Object? pathParameters = freezed,
    Object? afterResponseScript = freezed,
    Object? settingStoreCookies = freezed,
    Object? settingSendCookies = freezed,
    Object? settingDisableRenderRequestBody = freezed,
    Object? settingEncodeUrl = freezed,
    Object? settingRebuildPath = freezed,
    Object? settingFollowRedirects = freezed,
    Object? environment = freezed,
    Object? environmentPropertyOrder = freezed,
    Object? scope = freezed,
    Object? data = freezed,
    Object? dataPropertyOrder = freezed,
    Object? color = freezed,
    Object? cookies = freezed,
    Object? fileName = freezed,
    Object? contents = freezed,
    Object? contentType = freezed,
    Object? environmentType = freezed,
    Object? kvPairData = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      modified: freezed == modified
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as num?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as num?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as Body?,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<Parameter>?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      authentication: freezed == authentication
          ? _value.authentication
          : authentication // ignore: cast_nullable_to_non_nullable
              as dynamic,
      metaSortKey: freezed == metaSortKey
          ? _value.metaSortKey
          : metaSortKey // ignore: cast_nullable_to_non_nullable
              as num?,
      isPrivate: freezed == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool?,
      pathParameters: freezed == pathParameters
          ? _value.pathParameters
          : pathParameters // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      afterResponseScript: freezed == afterResponseScript
          ? _value.afterResponseScript
          : afterResponseScript // ignore: cast_nullable_to_non_nullable
              as String?,
      settingStoreCookies: freezed == settingStoreCookies
          ? _value.settingStoreCookies
          : settingStoreCookies // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingSendCookies: freezed == settingSendCookies
          ? _value.settingSendCookies
          : settingSendCookies // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingDisableRenderRequestBody: freezed ==
              settingDisableRenderRequestBody
          ? _value.settingDisableRenderRequestBody
          : settingDisableRenderRequestBody // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingEncodeUrl: freezed == settingEncodeUrl
          ? _value.settingEncodeUrl
          : settingEncodeUrl // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingRebuildPath: freezed == settingRebuildPath
          ? _value.settingRebuildPath
          : settingRebuildPath // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingFollowRedirects: freezed == settingFollowRedirects
          ? _value.settingFollowRedirects
          : settingFollowRedirects // ignore: cast_nullable_to_non_nullable
              as String?,
      environment: freezed == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as dynamic,
      environmentPropertyOrder: freezed == environmentPropertyOrder
          ? _value.environmentPropertyOrder
          : environmentPropertyOrder // ignore: cast_nullable_to_non_nullable
              as dynamic,
      scope: freezed == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      dataPropertyOrder: freezed == dataPropertyOrder
          ? _value.dataPropertyOrder
          : dataPropertyOrder // ignore: cast_nullable_to_non_nullable
              as dynamic,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as dynamic,
      cookies: freezed == cookies
          ? _value.cookies
          : cookies // ignore: cast_nullable_to_non_nullable
              as List<Cookie>?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      contents: freezed == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String?,
      contentType: freezed == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String?,
      environmentType: freezed == environmentType
          ? _value.environmentType
          : environmentType // ignore: cast_nullable_to_non_nullable
              as String?,
      kvPairData: freezed == kvPairData
          ? _value.kvPairData
          : kvPairData // ignore: cast_nullable_to_non_nullable
              as List<KVPairDatum>?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Resource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BodyCopyWith<$Res>? get body {
    if (_value.body == null) {
      return null;
    }

    return $BodyCopyWith<$Res>(_value.body!, (value) {
      return _then(_value.copyWith(body: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResourceImplCopyWith<$Res>
    implements $ResourceCopyWith<$Res> {
  factory _$$ResourceImplCopyWith(
          _$ResourceImpl value, $Res Function(_$ResourceImpl) then) =
      __$$ResourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? parentId,
      num? modified,
      num? created,
      String? url,
      String? name,
      String? description,
      String? method,
      Body? body,
      String? preRequestScript,
      List<Parameter>? parameters,
      List<Header>? headers,
      dynamic authentication,
      num? metaSortKey,
      bool? isPrivate,
      List<dynamic>? pathParameters,
      String? afterResponseScript,
      bool? settingStoreCookies,
      bool? settingSendCookies,
      bool? settingDisableRenderRequestBody,
      bool? settingEncodeUrl,
      bool? settingRebuildPath,
      String? settingFollowRedirects,
      dynamic environment,
      dynamic environmentPropertyOrder,
      String? scope,
      dynamic data,
      dynamic dataPropertyOrder,
      dynamic color,
      List<Cookie>? cookies,
      String? fileName,
      String? contents,
      String? contentType,
      String? environmentType,
      List<KVPairDatum>? kvPairData,
      @JsonKey(name: '_type') String? type});

  @override
  $BodyCopyWith<$Res>? get body;
}

/// @nodoc
class __$$ResourceImplCopyWithImpl<$Res>
    extends _$ResourceCopyWithImpl<$Res, _$ResourceImpl>
    implements _$$ResourceImplCopyWith<$Res> {
  __$$ResourceImplCopyWithImpl(
      _$ResourceImpl _value, $Res Function(_$ResourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Resource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? parentId = freezed,
    Object? modified = freezed,
    Object? created = freezed,
    Object? url = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? method = freezed,
    Object? body = freezed,
    Object? preRequestScript = freezed,
    Object? parameters = freezed,
    Object? headers = freezed,
    Object? authentication = freezed,
    Object? metaSortKey = freezed,
    Object? isPrivate = freezed,
    Object? pathParameters = freezed,
    Object? afterResponseScript = freezed,
    Object? settingStoreCookies = freezed,
    Object? settingSendCookies = freezed,
    Object? settingDisableRenderRequestBody = freezed,
    Object? settingEncodeUrl = freezed,
    Object? settingRebuildPath = freezed,
    Object? settingFollowRedirects = freezed,
    Object? environment = freezed,
    Object? environmentPropertyOrder = freezed,
    Object? scope = freezed,
    Object? data = freezed,
    Object? dataPropertyOrder = freezed,
    Object? color = freezed,
    Object? cookies = freezed,
    Object? fileName = freezed,
    Object? contents = freezed,
    Object? contentType = freezed,
    Object? environmentType = freezed,
    Object? kvPairData = freezed,
    Object? type = freezed,
  }) {
    return _then(_$ResourceImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      modified: freezed == modified
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as num?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as num?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as Body?,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<Parameter>?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      authentication: freezed == authentication
          ? _value.authentication
          : authentication // ignore: cast_nullable_to_non_nullable
              as dynamic,
      metaSortKey: freezed == metaSortKey
          ? _value.metaSortKey
          : metaSortKey // ignore: cast_nullable_to_non_nullable
              as num?,
      isPrivate: freezed == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool?,
      pathParameters: freezed == pathParameters
          ? _value._pathParameters
          : pathParameters // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      afterResponseScript: freezed == afterResponseScript
          ? _value.afterResponseScript
          : afterResponseScript // ignore: cast_nullable_to_non_nullable
              as String?,
      settingStoreCookies: freezed == settingStoreCookies
          ? _value.settingStoreCookies
          : settingStoreCookies // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingSendCookies: freezed == settingSendCookies
          ? _value.settingSendCookies
          : settingSendCookies // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingDisableRenderRequestBody: freezed ==
              settingDisableRenderRequestBody
          ? _value.settingDisableRenderRequestBody
          : settingDisableRenderRequestBody // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingEncodeUrl: freezed == settingEncodeUrl
          ? _value.settingEncodeUrl
          : settingEncodeUrl // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingRebuildPath: freezed == settingRebuildPath
          ? _value.settingRebuildPath
          : settingRebuildPath // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingFollowRedirects: freezed == settingFollowRedirects
          ? _value.settingFollowRedirects
          : settingFollowRedirects // ignore: cast_nullable_to_non_nullable
              as String?,
      environment: freezed == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as dynamic,
      environmentPropertyOrder: freezed == environmentPropertyOrder
          ? _value.environmentPropertyOrder
          : environmentPropertyOrder // ignore: cast_nullable_to_non_nullable
              as dynamic,
      scope: freezed == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      dataPropertyOrder: freezed == dataPropertyOrder
          ? _value.dataPropertyOrder
          : dataPropertyOrder // ignore: cast_nullable_to_non_nullable
              as dynamic,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as dynamic,
      cookies: freezed == cookies
          ? _value._cookies
          : cookies // ignore: cast_nullable_to_non_nullable
              as List<Cookie>?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      contents: freezed == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String?,
      contentType: freezed == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String?,
      environmentType: freezed == environmentType
          ? _value.environmentType
          : environmentType // ignore: cast_nullable_to_non_nullable
              as String?,
      kvPairData: freezed == kvPairData
          ? _value._kvPairData
          : kvPairData // ignore: cast_nullable_to_non_nullable
              as List<KVPairDatum>?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$ResourceImpl implements _Resource {
  const _$ResourceImpl(
      {@JsonKey(name: '_id') this.id,
      this.parentId,
      this.modified,
      this.created,
      this.url,
      this.name,
      this.description,
      this.method,
      this.body,
      this.preRequestScript,
      final List<Parameter>? parameters,
      final List<Header>? headers,
      this.authentication,
      this.metaSortKey,
      this.isPrivate,
      final List<dynamic>? pathParameters,
      this.afterResponseScript,
      this.settingStoreCookies,
      this.settingSendCookies,
      this.settingDisableRenderRequestBody,
      this.settingEncodeUrl,
      this.settingRebuildPath,
      this.settingFollowRedirects,
      this.environment,
      this.environmentPropertyOrder,
      this.scope,
      this.data,
      this.dataPropertyOrder,
      this.color,
      final List<Cookie>? cookies,
      this.fileName,
      this.contents,
      this.contentType,
      this.environmentType,
      final List<KVPairDatum>? kvPairData,
      @JsonKey(name: '_type') this.type})
      : _parameters = parameters,
        _headers = headers,
        _pathParameters = pathParameters,
        _cookies = cookies,
        _kvPairData = kvPairData;

  factory _$ResourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResourceImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? parentId;
  @override
  final num? modified;
  @override
  final num? created;
  @override
  final String? url;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? method;
  @override
  final Body? body;
  @override
  final String? preRequestScript;
  final List<Parameter>? _parameters;
  @override
  List<Parameter>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Header>? _headers;
  @override
  List<Header>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final dynamic authentication;
  @override
  final num? metaSortKey;
  @override
  final bool? isPrivate;
  final List<dynamic>? _pathParameters;
  @override
  List<dynamic>? get pathParameters {
    final value = _pathParameters;
    if (value == null) return null;
    if (_pathParameters is EqualUnmodifiableListView) return _pathParameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? afterResponseScript;
  @override
  final bool? settingStoreCookies;
  @override
  final bool? settingSendCookies;
  @override
  final bool? settingDisableRenderRequestBody;
  @override
  final bool? settingEncodeUrl;
  @override
  final bool? settingRebuildPath;
  @override
  final String? settingFollowRedirects;
  @override
  final dynamic environment;
  @override
  final dynamic environmentPropertyOrder;
  @override
  final String? scope;
  @override
  final dynamic data;
  @override
  final dynamic dataPropertyOrder;
  @override
  final dynamic color;
  final List<Cookie>? _cookies;
  @override
  List<Cookie>? get cookies {
    final value = _cookies;
    if (value == null) return null;
    if (_cookies is EqualUnmodifiableListView) return _cookies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? fileName;
  @override
  final String? contents;
  @override
  final String? contentType;
  @override
  final String? environmentType;
  final List<KVPairDatum>? _kvPairData;
  @override
  List<KVPairDatum>? get kvPairData {
    final value = _kvPairData;
    if (value == null) return null;
    if (_kvPairData is EqualUnmodifiableListView) return _kvPairData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: '_type')
  final String? type;

  @override
  String toString() {
    return 'Resource(id: $id, parentId: $parentId, modified: $modified, created: $created, url: $url, name: $name, description: $description, method: $method, body: $body, preRequestScript: $preRequestScript, parameters: $parameters, headers: $headers, authentication: $authentication, metaSortKey: $metaSortKey, isPrivate: $isPrivate, pathParameters: $pathParameters, afterResponseScript: $afterResponseScript, settingStoreCookies: $settingStoreCookies, settingSendCookies: $settingSendCookies, settingDisableRenderRequestBody: $settingDisableRenderRequestBody, settingEncodeUrl: $settingEncodeUrl, settingRebuildPath: $settingRebuildPath, settingFollowRedirects: $settingFollowRedirects, environment: $environment, environmentPropertyOrder: $environmentPropertyOrder, scope: $scope, data: $data, dataPropertyOrder: $dataPropertyOrder, color: $color, cookies: $cookies, fileName: $fileName, contents: $contents, contentType: $contentType, environmentType: $environmentType, kvPairData: $kvPairData, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.modified, modified) ||
                other.modified == modified) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.preRequestScript, preRequestScript) ||
                other.preRequestScript == preRequestScript) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other.authentication, authentication) &&
            (identical(other.metaSortKey, metaSortKey) ||
                other.metaSortKey == metaSortKey) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            const DeepCollectionEquality()
                .equals(other._pathParameters, _pathParameters) &&
            (identical(other.afterResponseScript, afterResponseScript) ||
                other.afterResponseScript == afterResponseScript) &&
            (identical(other.settingStoreCookies, settingStoreCookies) ||
                other.settingStoreCookies == settingStoreCookies) &&
            (identical(other.settingSendCookies, settingSendCookies) ||
                other.settingSendCookies == settingSendCookies) &&
            (identical(other.settingDisableRenderRequestBody,
                    settingDisableRenderRequestBody) ||
                other.settingDisableRenderRequestBody ==
                    settingDisableRenderRequestBody) &&
            (identical(other.settingEncodeUrl, settingEncodeUrl) ||
                other.settingEncodeUrl == settingEncodeUrl) &&
            (identical(other.settingRebuildPath, settingRebuildPath) ||
                other.settingRebuildPath == settingRebuildPath) &&
            (identical(other.settingFollowRedirects, settingFollowRedirects) ||
                other.settingFollowRedirects == settingFollowRedirects) &&
            const DeepCollectionEquality()
                .equals(other.environment, environment) &&
            const DeepCollectionEquality().equals(
                other.environmentPropertyOrder, environmentPropertyOrder) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality()
                .equals(other.dataPropertyOrder, dataPropertyOrder) &&
            const DeepCollectionEquality().equals(other.color, color) &&
            const DeepCollectionEquality().equals(other._cookies, _cookies) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.contents, contents) ||
                other.contents == contents) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.environmentType, environmentType) ||
                other.environmentType == environmentType) &&
            const DeepCollectionEquality()
                .equals(other._kvPairData, _kvPairData) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        parentId,
        modified,
        created,
        url,
        name,
        description,
        method,
        body,
        preRequestScript,
        const DeepCollectionEquality().hash(_parameters),
        const DeepCollectionEquality().hash(_headers),
        const DeepCollectionEquality().hash(authentication),
        metaSortKey,
        isPrivate,
        const DeepCollectionEquality().hash(_pathParameters),
        afterResponseScript,
        settingStoreCookies,
        settingSendCookies,
        settingDisableRenderRequestBody,
        settingEncodeUrl,
        settingRebuildPath,
        settingFollowRedirects,
        const DeepCollectionEquality().hash(environment),
        const DeepCollectionEquality().hash(environmentPropertyOrder),
        scope,
        const DeepCollectionEquality().hash(data),
        const DeepCollectionEquality().hash(dataPropertyOrder),
        const DeepCollectionEquality().hash(color),
        const DeepCollectionEquality().hash(_cookies),
        fileName,
        contents,
        contentType,
        environmentType,
        const DeepCollectionEquality().hash(_kvPairData),
        type
      ]);

  /// Create a copy of Resource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResourceImplCopyWith<_$ResourceImpl> get copyWith =>
      __$$ResourceImplCopyWithImpl<_$ResourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResourceImplToJson(
      this,
    );
  }
}

abstract class _Resource implements Resource {
  const factory _Resource(
      {@JsonKey(name: '_id') final String? id,
      final String? parentId,
      final num? modified,
      final num? created,
      final String? url,
      final String? name,
      final String? description,
      final String? method,
      final Body? body,
      final String? preRequestScript,
      final List<Parameter>? parameters,
      final List<Header>? headers,
      final dynamic authentication,
      final num? metaSortKey,
      final bool? isPrivate,
      final List<dynamic>? pathParameters,
      final String? afterResponseScript,
      final bool? settingStoreCookies,
      final bool? settingSendCookies,
      final bool? settingDisableRenderRequestBody,
      final bool? settingEncodeUrl,
      final bool? settingRebuildPath,
      final String? settingFollowRedirects,
      final dynamic environment,
      final dynamic environmentPropertyOrder,
      final String? scope,
      final dynamic data,
      final dynamic dataPropertyOrder,
      final dynamic color,
      final List<Cookie>? cookies,
      final String? fileName,
      final String? contents,
      final String? contentType,
      final String? environmentType,
      final List<KVPairDatum>? kvPairData,
      @JsonKey(name: '_type') final String? type}) = _$ResourceImpl;

  factory _Resource.fromJson(Map<String, dynamic> json) =
      _$ResourceImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get parentId;
  @override
  num? get modified;
  @override
  num? get created;
  @override
  String? get url;
  @override
  String? get name;
  @override
  String? get description;
  @override
  String? get method;
  @override
  Body? get body;
  @override
  String? get preRequestScript;
  @override
  List<Parameter>? get parameters;
  @override
  List<Header>? get headers;
  @override
  dynamic get authentication;
  @override
  num? get metaSortKey;
  @override
  bool? get isPrivate;
  @override
  List<dynamic>? get pathParameters;
  @override
  String? get afterResponseScript;
  @override
  bool? get settingStoreCookies;
  @override
  bool? get settingSendCookies;
  @override
  bool? get settingDisableRenderRequestBody;
  @override
  bool? get settingEncodeUrl;
  @override
  bool? get settingRebuildPath;
  @override
  String? get settingFollowRedirects;
  @override
  dynamic get environment;
  @override
  dynamic get environmentPropertyOrder;
  @override
  String? get scope;
  @override
  dynamic get data;
  @override
  dynamic get dataPropertyOrder;
  @override
  dynamic get color;
  @override
  List<Cookie>? get cookies;
  @override
  String? get fileName;
  @override
  String? get contents;
  @override
  String? get contentType;
  @override
  String? get environmentType;
  @override
  List<KVPairDatum>? get kvPairData;
  @override
  @JsonKey(name: '_type')
  String? get type;

  /// Create a copy of Resource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResourceImplCopyWith<_$ResourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Body _$BodyFromJson(Map<String, dynamic> json) {
  return _Body.fromJson(json);
}

/// @nodoc
mixin _$Body {
  String? get mimeType => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<Formdatum>? get params => throw _privateConstructorUsedError;

  /// Serializes this Body to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyCopyWith<Body> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyCopyWith<$Res> {
  factory $BodyCopyWith(Body value, $Res Function(Body) then) =
      _$BodyCopyWithImpl<$Res, Body>;
  @useResult
  $Res call({String? mimeType, String? text, List<Formdatum>? params});
}

/// @nodoc
class _$BodyCopyWithImpl<$Res, $Val extends Body>
    implements $BodyCopyWith<$Res> {
  _$BodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mimeType = freezed,
    Object? text = freezed,
    Object? params = freezed,
  }) {
    return _then(_value.copyWith(
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as List<Formdatum>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyImplCopyWith<$Res> implements $BodyCopyWith<$Res> {
  factory _$$BodyImplCopyWith(
          _$BodyImpl value, $Res Function(_$BodyImpl) then) =
      __$$BodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? mimeType, String? text, List<Formdatum>? params});
}

/// @nodoc
class __$$BodyImplCopyWithImpl<$Res>
    extends _$BodyCopyWithImpl<$Res, _$BodyImpl>
    implements _$$BodyImplCopyWith<$Res> {
  __$$BodyImplCopyWithImpl(_$BodyImpl _value, $Res Function(_$BodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mimeType = freezed,
    Object? text = freezed,
    Object? params = freezed,
  }) {
    return _then(_$BodyImpl(
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      params: freezed == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as List<Formdatum>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$BodyImpl implements _Body {
  const _$BodyImpl({this.mimeType, this.text, final List<Formdatum>? params})
      : _params = params;

  factory _$BodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyImplFromJson(json);

  @override
  final String? mimeType;
  @override
  final String? text;
  final List<Formdatum>? _params;
  @override
  List<Formdatum>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableListView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Body(mimeType: $mimeType, text: $text, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyImpl &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._params, _params));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mimeType, text,
      const DeepCollectionEquality().hash(_params));

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyImplCopyWith<_$BodyImpl> get copyWith =>
      __$$BodyImplCopyWithImpl<_$BodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyImplToJson(
      this,
    );
  }
}

abstract class _Body implements Body {
  const factory _Body(
      {final String? mimeType,
      final String? text,
      final List<Formdatum>? params}) = _$BodyImpl;

  factory _Body.fromJson(Map<String, dynamic> json) = _$BodyImpl.fromJson;

  @override
  String? get mimeType;
  @override
  String? get text;
  @override
  List<Formdatum>? get params;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyImplCopyWith<_$BodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Formdatum _$FormdatumFromJson(Map<String, dynamic> json) {
  return _Formdatum.fromJson(json);
}

/// @nodoc
mixin _$Formdatum {
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'fileName')
  String? get src => throw _privateConstructorUsedError;

  /// Serializes this Formdatum to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Formdatum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FormdatumCopyWith<Formdatum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormdatumCopyWith<$Res> {
  factory $FormdatumCopyWith(Formdatum value, $Res Function(Formdatum) then) =
      _$FormdatumCopyWithImpl<$Res, Formdatum>;
  @useResult
  $Res call(
      {String? name,
      String? value,
      String? type,
      @JsonKey(name: 'fileName') String? src});
}

/// @nodoc
class _$FormdatumCopyWithImpl<$Res, $Val extends Formdatum>
    implements $FormdatumCopyWith<$Res> {
  _$FormdatumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Formdatum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? src = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      src: freezed == src
          ? _value.src
          : src // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormdatumImplCopyWith<$Res>
    implements $FormdatumCopyWith<$Res> {
  factory _$$FormdatumImplCopyWith(
          _$FormdatumImpl value, $Res Function(_$FormdatumImpl) then) =
      __$$FormdatumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? value,
      String? type,
      @JsonKey(name: 'fileName') String? src});
}

/// @nodoc
class __$$FormdatumImplCopyWithImpl<$Res>
    extends _$FormdatumCopyWithImpl<$Res, _$FormdatumImpl>
    implements _$$FormdatumImplCopyWith<$Res> {
  __$$FormdatumImplCopyWithImpl(
      _$FormdatumImpl _value, $Res Function(_$FormdatumImpl) _then)
      : super(_value, _then);

  /// Create a copy of Formdatum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? src = freezed,
  }) {
    return _then(_$FormdatumImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      src: freezed == src
          ? _value.src
          : src // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$FormdatumImpl implements _Formdatum {
  const _$FormdatumImpl(
      {this.name, this.value, this.type, @JsonKey(name: 'fileName') this.src});

  factory _$FormdatumImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormdatumImplFromJson(json);

  @override
  final String? name;
  @override
  final String? value;
  @override
  final String? type;
  @override
  @JsonKey(name: 'fileName')
  final String? src;

  @override
  String toString() {
    return 'Formdatum(name: $name, value: $value, type: $type, src: $src)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormdatumImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.src, src) || other.src == src));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, type, src);

  /// Create a copy of Formdatum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormdatumImplCopyWith<_$FormdatumImpl> get copyWith =>
      __$$FormdatumImplCopyWithImpl<_$FormdatumImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormdatumImplToJson(
      this,
    );
  }
}

abstract class _Formdatum implements Formdatum {
  const factory _Formdatum(
      {final String? name,
      final String? value,
      final String? type,
      @JsonKey(name: 'fileName') final String? src}) = _$FormdatumImpl;

  factory _Formdatum.fromJson(Map<String, dynamic> json) =
      _$FormdatumImpl.fromJson;

  @override
  String? get name;
  @override
  String? get value;
  @override
  String? get type;
  @override
  @JsonKey(name: 'fileName')
  String? get src;

  /// Create a copy of Formdatum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormdatumImplCopyWith<_$FormdatumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Parameter _$ParameterFromJson(Map<String, dynamic> json) {
  return _Parameter.fromJson(json);
}

/// @nodoc
mixin _$Parameter {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;

  /// Serializes this Parameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Parameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParameterCopyWith<Parameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParameterCopyWith<$Res> {
  factory $ParameterCopyWith(Parameter value, $Res Function(Parameter) then) =
      _$ParameterCopyWithImpl<$Res, Parameter>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? value,
      String? description,
      bool? disabled});
}

/// @nodoc
class _$ParameterCopyWithImpl<$Res, $Val extends Parameter>
    implements $ParameterCopyWith<$Res> {
  _$ParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Parameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? description = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParameterImplCopyWith<$Res>
    implements $ParameterCopyWith<$Res> {
  factory _$$ParameterImplCopyWith(
          _$ParameterImpl value, $Res Function(_$ParameterImpl) then) =
      __$$ParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? value,
      String? description,
      bool? disabled});
}

/// @nodoc
class __$$ParameterImplCopyWithImpl<$Res>
    extends _$ParameterCopyWithImpl<$Res, _$ParameterImpl>
    implements _$$ParameterImplCopyWith<$Res> {
  __$$ParameterImplCopyWithImpl(
      _$ParameterImpl _value, $Res Function(_$ParameterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Parameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? description = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_$ParameterImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$ParameterImpl implements _Parameter {
  const _$ParameterImpl(
      {this.id, this.name, this.value, this.description, this.disabled});

  factory _$ParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParameterImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? value;
  @override
  final String? description;
  @override
  final bool? disabled;

  @override
  String toString() {
    return 'Parameter(id: $id, name: $name, value: $value, description: $description, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParameterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, value, description, disabled);

  /// Create a copy of Parameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParameterImplCopyWith<_$ParameterImpl> get copyWith =>
      __$$ParameterImplCopyWithImpl<_$ParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParameterImplToJson(
      this,
    );
  }
}

abstract class _Parameter implements Parameter {
  const factory _Parameter(
      {final String? id,
      final String? name,
      final String? value,
      final String? description,
      final bool? disabled}) = _$ParameterImpl;

  factory _Parameter.fromJson(Map<String, dynamic> json) =
      _$ParameterImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get value;
  @override
  String? get description;
  @override
  bool? get disabled;

  /// Create a copy of Parameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParameterImplCopyWith<_$ParameterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Header _$HeaderFromJson(Map<String, dynamic> json) {
  return _Header.fromJson(json);
}

/// @nodoc
mixin _$Header {
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;

  /// Serializes this Header to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeaderCopyWith<Header> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeaderCopyWith<$Res> {
  factory $HeaderCopyWith(Header value, $Res Function(Header) then) =
      _$HeaderCopyWithImpl<$Res, Header>;
  @useResult
  $Res call({String? name, String? value, bool? disabled});
}

/// @nodoc
class _$HeaderCopyWithImpl<$Res, $Val extends Header>
    implements $HeaderCopyWith<$Res> {
  _$HeaderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeaderImplCopyWith<$Res> implements $HeaderCopyWith<$Res> {
  factory _$$HeaderImplCopyWith(
          _$HeaderImpl value, $Res Function(_$HeaderImpl) then) =
      __$$HeaderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? value, bool? disabled});
}

/// @nodoc
class __$$HeaderImplCopyWithImpl<$Res>
    extends _$HeaderCopyWithImpl<$Res, _$HeaderImpl>
    implements _$$HeaderImplCopyWith<$Res> {
  __$$HeaderImplCopyWithImpl(
      _$HeaderImpl _value, $Res Function(_$HeaderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_$HeaderImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$HeaderImpl implements _Header {
  const _$HeaderImpl({this.name, this.value, this.disabled});

  factory _$HeaderImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeaderImplFromJson(json);

  @override
  final String? name;
  @override
  final String? value;
  @override
  final bool? disabled;

  @override
  String toString() {
    return 'Header(name: $name, value: $value, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeaderImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, disabled);

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeaderImplCopyWith<_$HeaderImpl> get copyWith =>
      __$$HeaderImplCopyWithImpl<_$HeaderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeaderImplToJson(
      this,
    );
  }
}

abstract class _Header implements Header {
  const factory _Header(
      {final String? name,
      final String? value,
      final bool? disabled}) = _$HeaderImpl;

  factory _Header.fromJson(Map<String, dynamic> json) = _$HeaderImpl.fromJson;

  @override
  String? get name;
  @override
  String? get value;
  @override
  bool? get disabled;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeaderImplCopyWith<_$HeaderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Cookie _$CookieFromJson(Map<String, dynamic> json) {
  return _Cookie.fromJson(json);
}

/// @nodoc
mixin _$Cookie {
  String? get key => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get domain => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;
  bool? get secure => throw _privateConstructorUsedError;
  bool? get httpOnly => throw _privateConstructorUsedError;
  bool? get hostOnly => throw _privateConstructorUsedError;
  DateTime? get creation => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;
  String? get sameSite => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this Cookie to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookieCopyWith<Cookie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookieCopyWith<$Res> {
  factory $CookieCopyWith(Cookie value, $Res Function(Cookie) then) =
      _$CookieCopyWithImpl<$Res, Cookie>;
  @useResult
  $Res call(
      {String? key,
      String? value,
      String? domain,
      String? path,
      bool? secure,
      bool? httpOnly,
      bool? hostOnly,
      DateTime? creation,
      DateTime? lastAccessed,
      String? sameSite,
      String? id});
}

/// @nodoc
class _$CookieCopyWithImpl<$Res, $Val extends Cookie>
    implements $CookieCopyWith<$Res> {
  _$CookieCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? value = freezed,
    Object? domain = freezed,
    Object? path = freezed,
    Object? secure = freezed,
    Object? httpOnly = freezed,
    Object? hostOnly = freezed,
    Object? creation = freezed,
    Object? lastAccessed = freezed,
    Object? sameSite = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      secure: freezed == secure
          ? _value.secure
          : secure // ignore: cast_nullable_to_non_nullable
              as bool?,
      httpOnly: freezed == httpOnly
          ? _value.httpOnly
          : httpOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      hostOnly: freezed == hostOnly
          ? _value.hostOnly
          : hostOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      creation: freezed == creation
          ? _value.creation
          : creation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sameSite: freezed == sameSite
          ? _value.sameSite
          : sameSite // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookieImplCopyWith<$Res> implements $CookieCopyWith<$Res> {
  factory _$$CookieImplCopyWith(
          _$CookieImpl value, $Res Function(_$CookieImpl) then) =
      __$$CookieImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? key,
      String? value,
      String? domain,
      String? path,
      bool? secure,
      bool? httpOnly,
      bool? hostOnly,
      DateTime? creation,
      DateTime? lastAccessed,
      String? sameSite,
      String? id});
}

/// @nodoc
class __$$CookieImplCopyWithImpl<$Res>
    extends _$CookieCopyWithImpl<$Res, _$CookieImpl>
    implements _$$CookieImplCopyWith<$Res> {
  __$$CookieImplCopyWithImpl(
      _$CookieImpl _value, $Res Function(_$CookieImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? value = freezed,
    Object? domain = freezed,
    Object? path = freezed,
    Object? secure = freezed,
    Object? httpOnly = freezed,
    Object? hostOnly = freezed,
    Object? creation = freezed,
    Object? lastAccessed = freezed,
    Object? sameSite = freezed,
    Object? id = freezed,
  }) {
    return _then(_$CookieImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      secure: freezed == secure
          ? _value.secure
          : secure // ignore: cast_nullable_to_non_nullable
              as bool?,
      httpOnly: freezed == httpOnly
          ? _value.httpOnly
          : httpOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      hostOnly: freezed == hostOnly
          ? _value.hostOnly
          : hostOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      creation: freezed == creation
          ? _value.creation
          : creation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sameSite: freezed == sameSite
          ? _value.sameSite
          : sameSite // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$CookieImpl implements _Cookie {
  const _$CookieImpl(
      {this.key,
      this.value,
      this.domain,
      this.path,
      this.secure,
      this.httpOnly,
      this.hostOnly,
      this.creation,
      this.lastAccessed,
      this.sameSite,
      this.id});

  factory _$CookieImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookieImplFromJson(json);

  @override
  final String? key;
  @override
  final String? value;
  @override
  final String? domain;
  @override
  final String? path;
  @override
  final bool? secure;
  @override
  final bool? httpOnly;
  @override
  final bool? hostOnly;
  @override
  final DateTime? creation;
  @override
  final DateTime? lastAccessed;
  @override
  final String? sameSite;
  @override
  final String? id;

  @override
  String toString() {
    return 'Cookie(key: $key, value: $value, domain: $domain, path: $path, secure: $secure, httpOnly: $httpOnly, hostOnly: $hostOnly, creation: $creation, lastAccessed: $lastAccessed, sameSite: $sameSite, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CookieImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.secure, secure) || other.secure == secure) &&
            (identical(other.httpOnly, httpOnly) ||
                other.httpOnly == httpOnly) &&
            (identical(other.hostOnly, hostOnly) ||
                other.hostOnly == hostOnly) &&
            (identical(other.creation, creation) ||
                other.creation == creation) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.sameSite, sameSite) ||
                other.sameSite == sameSite) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, domain, path, secure,
      httpOnly, hostOnly, creation, lastAccessed, sameSite, id);

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookieImplCopyWith<_$CookieImpl> get copyWith =>
      __$$CookieImplCopyWithImpl<_$CookieImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookieImplToJson(
      this,
    );
  }
}

abstract class _Cookie implements Cookie {
  const factory _Cookie(
      {final String? key,
      final String? value,
      final String? domain,
      final String? path,
      final bool? secure,
      final bool? httpOnly,
      final bool? hostOnly,
      final DateTime? creation,
      final DateTime? lastAccessed,
      final String? sameSite,
      final String? id}) = _$CookieImpl;

  factory _Cookie.fromJson(Map<String, dynamic> json) = _$CookieImpl.fromJson;

  @override
  String? get key;
  @override
  String? get value;
  @override
  String? get domain;
  @override
  String? get path;
  @override
  bool? get secure;
  @override
  bool? get httpOnly;
  @override
  bool? get hostOnly;
  @override
  DateTime? get creation;
  @override
  DateTime? get lastAccessed;
  @override
  String? get sameSite;
  @override
  String? get id;

  /// Create a copy of Cookie
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookieImplCopyWith<_$CookieImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KVPairDatum _$KVPairDatumFromJson(Map<String, dynamic> json) {
  return _KVPairDatum.fromJson(json);
}

/// @nodoc
mixin _$KVPairDatum {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  bool? get enabled => throw _privateConstructorUsedError;

  /// Serializes this KVPairDatum to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KVPairDatum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KVPairDatumCopyWith<KVPairDatum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KVPairDatumCopyWith<$Res> {
  factory $KVPairDatumCopyWith(
          KVPairDatum value, $Res Function(KVPairDatum) then) =
      _$KVPairDatumCopyWithImpl<$Res, KVPairDatum>;
  @useResult
  $Res call(
      {String? id, String? name, String? value, String? type, bool? enabled});
}

/// @nodoc
class _$KVPairDatumCopyWithImpl<$Res, $Val extends KVPairDatum>
    implements $KVPairDatumCopyWith<$Res> {
  _$KVPairDatumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KVPairDatum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? enabled = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: freezed == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KVPairDatumImplCopyWith<$Res>
    implements $KVPairDatumCopyWith<$Res> {
  factory _$$KVPairDatumImplCopyWith(
          _$KVPairDatumImpl value, $Res Function(_$KVPairDatumImpl) then) =
      __$$KVPairDatumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id, String? name, String? value, String? type, bool? enabled});
}

/// @nodoc
class __$$KVPairDatumImplCopyWithImpl<$Res>
    extends _$KVPairDatumCopyWithImpl<$Res, _$KVPairDatumImpl>
    implements _$$KVPairDatumImplCopyWith<$Res> {
  __$$KVPairDatumImplCopyWithImpl(
      _$KVPairDatumImpl _value, $Res Function(_$KVPairDatumImpl) _then)
      : super(_value, _then);

  /// Create a copy of KVPairDatum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? enabled = freezed,
  }) {
    return _then(_$KVPairDatumImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: freezed == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$KVPairDatumImpl implements _KVPairDatum {
  const _$KVPairDatumImpl(
      {this.id, this.name, this.value, this.type, this.enabled});

  factory _$KVPairDatumImpl.fromJson(Map<String, dynamic> json) =>
      _$$KVPairDatumImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? value;
  @override
  final String? type;
  @override
  final bool? enabled;

  @override
  String toString() {
    return 'KVPairDatum(id: $id, name: $name, value: $value, type: $type, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KVPairDatumImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, value, type, enabled);

  /// Create a copy of KVPairDatum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KVPairDatumImplCopyWith<_$KVPairDatumImpl> get copyWith =>
      __$$KVPairDatumImplCopyWithImpl<_$KVPairDatumImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KVPairDatumImplToJson(
      this,
    );
  }
}

abstract class _KVPairDatum implements KVPairDatum {
  const factory _KVPairDatum(
      {final String? id,
      final String? name,
      final String? value,
      final String? type,
      final bool? enabled}) = _$KVPairDatumImpl;

  factory _KVPairDatum.fromJson(Map<String, dynamic> json) =
      _$KVPairDatumImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get value;
  @override
  String? get type;
  @override
  bool? get enabled;

  /// Create a copy of KVPairDatum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KVPairDatumImplCopyWith<_$KVPairDatumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
