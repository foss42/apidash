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
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;
  num? get modified => throw _privateConstructorUsedError;
  num? get created => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get method => throw _privateConstructorUsedError;
  Body? get body => throw _privateConstructorUsedError;
  List<Parameter>? get parameters => throw _privateConstructorUsedError;
  List<Header>? get headers =>
      throw _privateConstructorUsedError; // List<Authentication>? authentication,
  String? get preRequestScript => throw _privateConstructorUsedError;
  num? get metaSortKey => throw _privateConstructorUsedError;
  bool? get isPrivate => throw _privateConstructorUsedError;
  String? get afterResponseScript => throw _privateConstructorUsedError;
  bool? get settingSendCookies => throw _privateConstructorUsedError;
  bool? get settingStoreCookies => throw _privateConstructorUsedError;
  bool? get settingDisableRenderRequestBody =>
      throw _privateConstructorUsedError;
  bool? get settingEncodeUrl => throw _privateConstructorUsedError;
  bool? get settingRebuildPath => throw _privateConstructorUsedError;
  String? get settingFollowRedirects => throw _privateConstructorUsedError;
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
      @JsonKey(name: 'parentId') String? parentId,
      num? modified,
      num? created,
      String? url,
      String? name,
      String? description,
      String? method,
      Body? body,
      List<Parameter>? parameters,
      List<Header>? headers,
      String? preRequestScript,
      num? metaSortKey,
      bool? isPrivate,
      String? afterResponseScript,
      bool? settingSendCookies,
      bool? settingStoreCookies,
      bool? settingDisableRenderRequestBody,
      bool? settingEncodeUrl,
      bool? settingRebuildPath,
      String? settingFollowRedirects,
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
    Object? parameters = freezed,
    Object? headers = freezed,
    Object? preRequestScript = freezed,
    Object? metaSortKey = freezed,
    Object? isPrivate = freezed,
    Object? afterResponseScript = freezed,
    Object? settingSendCookies = freezed,
    Object? settingStoreCookies = freezed,
    Object? settingDisableRenderRequestBody = freezed,
    Object? settingEncodeUrl = freezed,
    Object? settingRebuildPath = freezed,
    Object? settingFollowRedirects = freezed,
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
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<Parameter>?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      metaSortKey: freezed == metaSortKey
          ? _value.metaSortKey
          : metaSortKey // ignore: cast_nullable_to_non_nullable
              as num?,
      isPrivate: freezed == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool?,
      afterResponseScript: freezed == afterResponseScript
          ? _value.afterResponseScript
          : afterResponseScript // ignore: cast_nullable_to_non_nullable
              as String?,
      settingSendCookies: freezed == settingSendCookies
          ? _value.settingSendCookies
          : settingSendCookies // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingStoreCookies: freezed == settingStoreCookies
          ? _value.settingStoreCookies
          : settingStoreCookies // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'parentId') String? parentId,
      num? modified,
      num? created,
      String? url,
      String? name,
      String? description,
      String? method,
      Body? body,
      List<Parameter>? parameters,
      List<Header>? headers,
      String? preRequestScript,
      num? metaSortKey,
      bool? isPrivate,
      String? afterResponseScript,
      bool? settingSendCookies,
      bool? settingStoreCookies,
      bool? settingDisableRenderRequestBody,
      bool? settingEncodeUrl,
      bool? settingRebuildPath,
      String? settingFollowRedirects,
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
    Object? parameters = freezed,
    Object? headers = freezed,
    Object? preRequestScript = freezed,
    Object? metaSortKey = freezed,
    Object? isPrivate = freezed,
    Object? afterResponseScript = freezed,
    Object? settingSendCookies = freezed,
    Object? settingStoreCookies = freezed,
    Object? settingDisableRenderRequestBody = freezed,
    Object? settingEncodeUrl = freezed,
    Object? settingRebuildPath = freezed,
    Object? settingFollowRedirects = freezed,
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
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<Parameter>?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      preRequestScript: freezed == preRequestScript
          ? _value.preRequestScript
          : preRequestScript // ignore: cast_nullable_to_non_nullable
              as String?,
      metaSortKey: freezed == metaSortKey
          ? _value.metaSortKey
          : metaSortKey // ignore: cast_nullable_to_non_nullable
              as num?,
      isPrivate: freezed == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool?,
      afterResponseScript: freezed == afterResponseScript
          ? _value.afterResponseScript
          : afterResponseScript // ignore: cast_nullable_to_non_nullable
              as String?,
      settingSendCookies: freezed == settingSendCookies
          ? _value.settingSendCookies
          : settingSendCookies // ignore: cast_nullable_to_non_nullable
              as bool?,
      settingStoreCookies: freezed == settingStoreCookies
          ? _value.settingStoreCookies
          : settingStoreCookies // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'parentId') this.parentId,
      this.modified,
      this.created,
      this.url,
      this.name,
      this.description,
      this.method,
      this.body,
      final List<Parameter>? parameters,
      final List<Header>? headers,
      this.preRequestScript,
      this.metaSortKey,
      this.isPrivate,
      this.afterResponseScript,
      this.settingSendCookies,
      this.settingStoreCookies,
      this.settingDisableRenderRequestBody,
      this.settingEncodeUrl,
      this.settingRebuildPath,
      this.settingFollowRedirects,
      @JsonKey(name: '_type') this.type})
      : _parameters = parameters,
        _headers = headers;

  factory _$ResourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResourceImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey(name: 'parentId')
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

// List<Authentication>? authentication,
  @override
  final String? preRequestScript;
  @override
  final num? metaSortKey;
  @override
  final bool? isPrivate;
  @override
  final String? afterResponseScript;
  @override
  final bool? settingSendCookies;
  @override
  final bool? settingStoreCookies;
  @override
  final bool? settingDisableRenderRequestBody;
  @override
  final bool? settingEncodeUrl;
  @override
  final bool? settingRebuildPath;
  @override
  final String? settingFollowRedirects;
  @override
  @JsonKey(name: '_type')
  final String? type;

  @override
  String toString() {
    return 'Resource(id: $id, parentId: $parentId, modified: $modified, created: $created, url: $url, name: $name, description: $description, method: $method, body: $body, parameters: $parameters, headers: $headers, preRequestScript: $preRequestScript, metaSortKey: $metaSortKey, isPrivate: $isPrivate, afterResponseScript: $afterResponseScript, settingSendCookies: $settingSendCookies, settingStoreCookies: $settingStoreCookies, settingDisableRenderRequestBody: $settingDisableRenderRequestBody, settingEncodeUrl: $settingEncodeUrl, settingRebuildPath: $settingRebuildPath, settingFollowRedirects: $settingFollowRedirects, type: $type)';
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
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.preRequestScript, preRequestScript) ||
                other.preRequestScript == preRequestScript) &&
            (identical(other.metaSortKey, metaSortKey) ||
                other.metaSortKey == metaSortKey) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.afterResponseScript, afterResponseScript) ||
                other.afterResponseScript == afterResponseScript) &&
            (identical(other.settingSendCookies, settingSendCookies) ||
                other.settingSendCookies == settingSendCookies) &&
            (identical(other.settingStoreCookies, settingStoreCookies) ||
                other.settingStoreCookies == settingStoreCookies) &&
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
        const DeepCollectionEquality().hash(_parameters),
        const DeepCollectionEquality().hash(_headers),
        preRequestScript,
        metaSortKey,
        isPrivate,
        afterResponseScript,
        settingSendCookies,
        settingStoreCookies,
        settingDisableRenderRequestBody,
        settingEncodeUrl,
        settingRebuildPath,
        settingFollowRedirects,
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
      @JsonKey(name: 'parentId') final String? parentId,
      final num? modified,
      final num? created,
      final String? url,
      final String? name,
      final String? description,
      final String? method,
      final Body? body,
      final List<Parameter>? parameters,
      final List<Header>? headers,
      final String? preRequestScript,
      final num? metaSortKey,
      final bool? isPrivate,
      final String? afterResponseScript,
      final bool? settingSendCookies,
      final bool? settingStoreCookies,
      final bool? settingDisableRenderRequestBody,
      final bool? settingEncodeUrl,
      final bool? settingRebuildPath,
      final String? settingFollowRedirects,
      @JsonKey(name: '_type') final String? type}) = _$ResourceImpl;

  factory _Resource.fromJson(Map<String, dynamic> json) =
      _$ResourceImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  @JsonKey(name: 'parentId')
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
  List<Parameter>? get parameters;
  @override
  List<Header>? get headers; // List<Authentication>? authentication,
  @override
  String? get preRequestScript;
  @override
  num? get metaSortKey;
  @override
  bool? get isPrivate;
  @override
  String? get afterResponseScript;
  @override
  bool? get settingSendCookies;
  @override
  bool? get settingStoreCookies;
  @override
  bool? get settingDisableRenderRequestBody;
  @override
  bool? get settingEncodeUrl;
  @override
  bool? get settingRebuildPath;
  @override
  String? get settingFollowRedirects;
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
  $Res call({String? mimeType, String? text});
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
  $Res call({String? mimeType, String? text});
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
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$BodyImpl implements _Body {
  const _$BodyImpl({this.mimeType, this.text});

  factory _$BodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyImplFromJson(json);

  @override
  final String? mimeType;
  @override
  final String? text;

  @override
  String toString() {
    return 'Body(mimeType: $mimeType, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyImpl &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mimeType, text);

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
  const factory _Body({final String? mimeType, final String? text}) =
      _$BodyImpl;

  factory _Body.fromJson(Map<String, dynamic> json) = _$BodyImpl.fromJson;

  @override
  String? get mimeType;
  @override
  String? get text;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyImplCopyWith<_$BodyImpl> get copyWith =>
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
  $Res call({String? name, String? value});
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
  $Res call({String? name, String? value});
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
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$HeaderImpl implements _Header {
  const _$HeaderImpl({this.name, this.value});

  factory _$HeaderImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeaderImplFromJson(json);

  @override
  final String? name;
  @override
  final String? value;

  @override
  String toString() {
    return 'Header(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeaderImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

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
  const factory _Header({final String? name, final String? value}) =
      _$HeaderImpl;

  factory _Header.fromJson(Map<String, dynamic> json) = _$HeaderImpl.fromJson;

  @override
  String? get name;
  @override
  String? get value;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeaderImplCopyWith<_$HeaderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
