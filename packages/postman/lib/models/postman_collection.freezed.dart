// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'postman_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostmanCollection _$PostmanCollectionFromJson(Map<String, dynamic> json) {
  return _PostmanCollection.fromJson(json);
}

/// @nodoc
mixin _$PostmanCollection {
  Info? get info => throw _privateConstructorUsedError;
  List<Item>? get item => throw _privateConstructorUsedError;

  /// Serializes this PostmanCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostmanCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostmanCollectionCopyWith<PostmanCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostmanCollectionCopyWith<$Res> {
  factory $PostmanCollectionCopyWith(
          PostmanCollection value, $Res Function(PostmanCollection) then) =
      _$PostmanCollectionCopyWithImpl<$Res, PostmanCollection>;
  @useResult
  $Res call({Info? info, List<Item>? item});

  $InfoCopyWith<$Res>? get info;
}

/// @nodoc
class _$PostmanCollectionCopyWithImpl<$Res, $Val extends PostmanCollection>
    implements $PostmanCollectionCopyWith<$Res> {
  _$PostmanCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostmanCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = freezed,
    Object? item = freezed,
  }) {
    return _then(_value.copyWith(
      info: freezed == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as Info?,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
    ) as $Val);
  }

  /// Create a copy of PostmanCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InfoCopyWith<$Res>? get info {
    if (_value.info == null) {
      return null;
    }

    return $InfoCopyWith<$Res>(_value.info!, (value) {
      return _then(_value.copyWith(info: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostmanCollectionImplCopyWith<$Res>
    implements $PostmanCollectionCopyWith<$Res> {
  factory _$$PostmanCollectionImplCopyWith(_$PostmanCollectionImpl value,
          $Res Function(_$PostmanCollectionImpl) then) =
      __$$PostmanCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Info? info, List<Item>? item});

  @override
  $InfoCopyWith<$Res>? get info;
}

/// @nodoc
class __$$PostmanCollectionImplCopyWithImpl<$Res>
    extends _$PostmanCollectionCopyWithImpl<$Res, _$PostmanCollectionImpl>
    implements _$$PostmanCollectionImplCopyWith<$Res> {
  __$$PostmanCollectionImplCopyWithImpl(_$PostmanCollectionImpl _value,
      $Res Function(_$PostmanCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostmanCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = freezed,
    Object? item = freezed,
  }) {
    return _then(_$PostmanCollectionImpl(
      info: freezed == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as Info?,
      item: freezed == item
          ? _value._item
          : item // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$PostmanCollectionImpl implements _PostmanCollection {
  const _$PostmanCollectionImpl({this.info, final List<Item>? item})
      : _item = item;

  factory _$PostmanCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostmanCollectionImplFromJson(json);

  @override
  final Info? info;
  final List<Item>? _item;
  @override
  List<Item>? get item {
    final value = _item;
    if (value == null) return null;
    if (_item is EqualUnmodifiableListView) return _item;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PostmanCollection(info: $info, item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostmanCollectionImpl &&
            (identical(other.info, info) || other.info == info) &&
            const DeepCollectionEquality().equals(other._item, _item));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, info, const DeepCollectionEquality().hash(_item));

  /// Create a copy of PostmanCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostmanCollectionImplCopyWith<_$PostmanCollectionImpl> get copyWith =>
      __$$PostmanCollectionImplCopyWithImpl<_$PostmanCollectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostmanCollectionImplToJson(
      this,
    );
  }
}

abstract class _PostmanCollection implements PostmanCollection {
  const factory _PostmanCollection({final Info? info, final List<Item>? item}) =
      _$PostmanCollectionImpl;

  factory _PostmanCollection.fromJson(Map<String, dynamic> json) =
      _$PostmanCollectionImpl.fromJson;

  @override
  Info? get info;
  @override
  List<Item>? get item;

  /// Create a copy of PostmanCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostmanCollectionImplCopyWith<_$PostmanCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Info _$InfoFromJson(Map<String, dynamic> json) {
  return _Info.fromJson(json);
}

/// @nodoc
mixin _$Info {
  @JsonKey(name: '_postman_id')
  String? get postmanId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get schema => throw _privateConstructorUsedError;
  @JsonKey(name: '_exporter_id')
  String? get exporterId => throw _privateConstructorUsedError;

  /// Serializes this Info to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Info
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InfoCopyWith<Info> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfoCopyWith<$Res> {
  factory $InfoCopyWith(Info value, $Res Function(Info) then) =
      _$InfoCopyWithImpl<$Res, Info>;
  @useResult
  $Res call(
      {@JsonKey(name: '_postman_id') String? postmanId,
      String? name,
      String? schema,
      @JsonKey(name: '_exporter_id') String? exporterId});
}

/// @nodoc
class _$InfoCopyWithImpl<$Res, $Val extends Info>
    implements $InfoCopyWith<$Res> {
  _$InfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Info
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postmanId = freezed,
    Object? name = freezed,
    Object? schema = freezed,
    Object? exporterId = freezed,
  }) {
    return _then(_value.copyWith(
      postmanId: freezed == postmanId
          ? _value.postmanId
          : postmanId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String?,
      exporterId: freezed == exporterId
          ? _value.exporterId
          : exporterId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InfoImplCopyWith<$Res> implements $InfoCopyWith<$Res> {
  factory _$$InfoImplCopyWith(
          _$InfoImpl value, $Res Function(_$InfoImpl) then) =
      __$$InfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_postman_id') String? postmanId,
      String? name,
      String? schema,
      @JsonKey(name: '_exporter_id') String? exporterId});
}

/// @nodoc
class __$$InfoImplCopyWithImpl<$Res>
    extends _$InfoCopyWithImpl<$Res, _$InfoImpl>
    implements _$$InfoImplCopyWith<$Res> {
  __$$InfoImplCopyWithImpl(_$InfoImpl _value, $Res Function(_$InfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Info
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postmanId = freezed,
    Object? name = freezed,
    Object? schema = freezed,
    Object? exporterId = freezed,
  }) {
    return _then(_$InfoImpl(
      postmanId: freezed == postmanId
          ? _value.postmanId
          : postmanId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String?,
      exporterId: freezed == exporterId
          ? _value.exporterId
          : exporterId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$InfoImpl implements _Info {
  const _$InfoImpl(
      {@JsonKey(name: '_postman_id') this.postmanId,
      this.name,
      this.schema,
      @JsonKey(name: '_exporter_id') this.exporterId});

  factory _$InfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InfoImplFromJson(json);

  @override
  @JsonKey(name: '_postman_id')
  final String? postmanId;
  @override
  final String? name;
  @override
  final String? schema;
  @override
  @JsonKey(name: '_exporter_id')
  final String? exporterId;

  @override
  String toString() {
    return 'Info(postmanId: $postmanId, name: $name, schema: $schema, exporterId: $exporterId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InfoImpl &&
            (identical(other.postmanId, postmanId) ||
                other.postmanId == postmanId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.schema, schema) || other.schema == schema) &&
            (identical(other.exporterId, exporterId) ||
                other.exporterId == exporterId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, postmanId, name, schema, exporterId);

  /// Create a copy of Info
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InfoImplCopyWith<_$InfoImpl> get copyWith =>
      __$$InfoImplCopyWithImpl<_$InfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InfoImplToJson(
      this,
    );
  }
}

abstract class _Info implements Info {
  const factory _Info(
      {@JsonKey(name: '_postman_id') final String? postmanId,
      final String? name,
      final String? schema,
      @JsonKey(name: '_exporter_id') final String? exporterId}) = _$InfoImpl;

  factory _Info.fromJson(Map<String, dynamic> json) = _$InfoImpl.fromJson;

  @override
  @JsonKey(name: '_postman_id')
  String? get postmanId;
  @override
  String? get name;
  @override
  String? get schema;
  @override
  @JsonKey(name: '_exporter_id')
  String? get exporterId;

  /// Create a copy of Info
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InfoImplCopyWith<_$InfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
mixin _$Item {
  String? get name => throw _privateConstructorUsedError;
  List<Item>? get item => throw _privateConstructorUsedError;
  Request? get request => throw _privateConstructorUsedError;
  List<dynamic>? get response => throw _privateConstructorUsedError;

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemCopyWith<Item> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res, Item>;
  @useResult
  $Res call(
      {String? name,
      List<Item>? item,
      Request? request,
      List<dynamic>? response});

  $RequestCopyWith<$Res>? get request;
}

/// @nodoc
class _$ItemCopyWithImpl<$Res, $Val extends Item>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? item = freezed,
    Object? request = freezed,
    Object? response = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as Request?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ) as $Val);
  }

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestCopyWith<$Res>? get request {
    if (_value.request == null) {
      return null;
    }

    return $RequestCopyWith<$Res>(_value.request!, (value) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ItemImplCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$$ItemImplCopyWith(
          _$ItemImpl value, $Res Function(_$ItemImpl) then) =
      __$$ItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      List<Item>? item,
      Request? request,
      List<dynamic>? response});

  @override
  $RequestCopyWith<$Res>? get request;
}

/// @nodoc
class __$$ItemImplCopyWithImpl<$Res>
    extends _$ItemCopyWithImpl<$Res, _$ItemImpl>
    implements _$$ItemImplCopyWith<$Res> {
  __$$ItemImplCopyWithImpl(_$ItemImpl _value, $Res Function(_$ItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? item = freezed,
    Object? request = freezed,
    Object? response = freezed,
  }) {
    return _then(_$ItemImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      item: freezed == item
          ? _value._item
          : item // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as Request?,
      response: freezed == response
          ? _value._response
          : response // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$ItemImpl implements _Item {
  const _$ItemImpl(
      {this.name,
      final List<Item>? item,
      this.request,
      final List<dynamic>? response})
      : _item = item,
        _response = response;

  factory _$ItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemImplFromJson(json);

  @override
  final String? name;
  final List<Item>? _item;
  @override
  List<Item>? get item {
    final value = _item;
    if (value == null) return null;
    if (_item is EqualUnmodifiableListView) return _item;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Request? request;
  final List<dynamic>? _response;
  @override
  List<dynamic>? get response {
    final value = _response;
    if (value == null) return null;
    if (_response is EqualUnmodifiableListView) return _response;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Item(name: $name, item: $item, request: $request, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._item, _item) &&
            (identical(other.request, request) || other.request == request) &&
            const DeepCollectionEquality().equals(other._response, _response));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      const DeepCollectionEquality().hash(_item),
      request,
      const DeepCollectionEquality().hash(_response));

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      __$$ItemImplCopyWithImpl<_$ItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemImplToJson(
      this,
    );
  }
}

abstract class _Item implements Item {
  const factory _Item(
      {final String? name,
      final List<Item>? item,
      final Request? request,
      final List<dynamic>? response}) = _$ItemImpl;

  factory _Item.fromJson(Map<String, dynamic> json) = _$ItemImpl.fromJson;

  @override
  String? get name;
  @override
  List<Item>? get item;
  @override
  Request? get request;
  @override
  List<dynamic>? get response;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Request _$RequestFromJson(Map<String, dynamic> json) {
  return _Request.fromJson(json);
}

/// @nodoc
mixin _$Request {
  String? get method => throw _privateConstructorUsedError;
  List<Header>? get header => throw _privateConstructorUsedError;
  Body? get body => throw _privateConstructorUsedError;
  Url? get url => throw _privateConstructorUsedError;

  /// Serializes this Request to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestCopyWith<Request> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestCopyWith<$Res> {
  factory $RequestCopyWith(Request value, $Res Function(Request) then) =
      _$RequestCopyWithImpl<$Res, Request>;
  @useResult
  $Res call({String? method, List<Header>? header, Body? body, Url? url});

  $BodyCopyWith<$Res>? get body;
  $UrlCopyWith<$Res>? get url;
}

/// @nodoc
class _$RequestCopyWithImpl<$Res, $Val extends Request>
    implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = freezed,
    Object? header = freezed,
    Object? body = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String?,
      header: freezed == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as Body?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as Url?,
    ) as $Val);
  }

  /// Create a copy of Request
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

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UrlCopyWith<$Res>? get url {
    if (_value.url == null) {
      return null;
    }

    return $UrlCopyWith<$Res>(_value.url!, (value) {
      return _then(_value.copyWith(url: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestImplCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$$RequestImplCopyWith(
          _$RequestImpl value, $Res Function(_$RequestImpl) then) =
      __$$RequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? method, List<Header>? header, Body? body, Url? url});

  @override
  $BodyCopyWith<$Res>? get body;
  @override
  $UrlCopyWith<$Res>? get url;
}

/// @nodoc
class __$$RequestImplCopyWithImpl<$Res>
    extends _$RequestCopyWithImpl<$Res, _$RequestImpl>
    implements _$$RequestImplCopyWith<$Res> {
  __$$RequestImplCopyWithImpl(
      _$RequestImpl _value, $Res Function(_$RequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = freezed,
    Object? header = freezed,
    Object? body = freezed,
    Object? url = freezed,
  }) {
    return _then(_$RequestImpl(
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String?,
      header: freezed == header
          ? _value._header
          : header // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as Body?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as Url?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$RequestImpl implements _Request {
  const _$RequestImpl(
      {this.method, final List<Header>? header, this.body, this.url})
      : _header = header;

  factory _$RequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestImplFromJson(json);

  @override
  final String? method;
  final List<Header>? _header;
  @override
  List<Header>? get header {
    final value = _header;
    if (value == null) return null;
    if (_header is EqualUnmodifiableListView) return _header;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Body? body;
  @override
  final Url? url;

  @override
  String toString() {
    return 'Request(method: $method, header: $header, body: $body, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestImpl &&
            (identical(other.method, method) || other.method == method) &&
            const DeepCollectionEquality().equals(other._header, _header) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, method,
      const DeepCollectionEquality().hash(_header), body, url);

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      __$$RequestImplCopyWithImpl<_$RequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestImplToJson(
      this,
    );
  }
}

abstract class _Request implements Request {
  const factory _Request(
      {final String? method,
      final List<Header>? header,
      final Body? body,
      final Url? url}) = _$RequestImpl;

  factory _Request.fromJson(Map<String, dynamic> json) = _$RequestImpl.fromJson;

  @override
  String? get method;
  @override
  List<Header>? get header;
  @override
  Body? get body;
  @override
  Url? get url;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Header _$HeaderFromJson(Map<String, dynamic> json) {
  return _Header.fromJson(json);
}

/// @nodoc
mixin _$Header {
  String? get key => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
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
  $Res call({String? key, String? value, String? type, bool? disabled});
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
    Object? key = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? disabled = freezed,
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
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
  $Res call({String? key, String? value, String? type, bool? disabled});
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
    Object? key = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_$HeaderImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
  const _$HeaderImpl({this.key, this.value, this.type, this.disabled});

  factory _$HeaderImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeaderImplFromJson(json);

  @override
  final String? key;
  @override
  final String? value;
  @override
  final String? type;
  @override
  final bool? disabled;

  @override
  String toString() {
    return 'Header(key: $key, value: $value, type: $type, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeaderImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, type, disabled);

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
      {final String? key,
      final String? value,
      final String? type,
      final bool? disabled}) = _$HeaderImpl;

  factory _Header.fromJson(Map<String, dynamic> json) = _$HeaderImpl.fromJson;

  @override
  String? get key;
  @override
  String? get value;
  @override
  String? get type;
  @override
  bool? get disabled;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeaderImplCopyWith<_$HeaderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Url _$UrlFromJson(Map<String, dynamic> json) {
  return _Url.fromJson(json);
}

/// @nodoc
mixin _$Url {
  String? get raw => throw _privateConstructorUsedError;
  String? get protocol => throw _privateConstructorUsedError;
  List<String>? get host => throw _privateConstructorUsedError;
  List<String>? get path => throw _privateConstructorUsedError;
  List<Query>? get query => throw _privateConstructorUsedError;

  /// Serializes this Url to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Url
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UrlCopyWith<Url> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UrlCopyWith<$Res> {
  factory $UrlCopyWith(Url value, $Res Function(Url) then) =
      _$UrlCopyWithImpl<$Res, Url>;
  @useResult
  $Res call(
      {String? raw,
      String? protocol,
      List<String>? host,
      List<String>? path,
      List<Query>? query});
}

/// @nodoc
class _$UrlCopyWithImpl<$Res, $Val extends Url> implements $UrlCopyWith<$Res> {
  _$UrlCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Url
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? raw = freezed,
    Object? protocol = freezed,
    Object? host = freezed,
    Object? path = freezed,
    Object? query = freezed,
  }) {
    return _then(_value.copyWith(
      raw: freezed == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as String?,
      protocol: freezed == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as List<Query>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UrlImplCopyWith<$Res> implements $UrlCopyWith<$Res> {
  factory _$$UrlImplCopyWith(_$UrlImpl value, $Res Function(_$UrlImpl) then) =
      __$$UrlImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? raw,
      String? protocol,
      List<String>? host,
      List<String>? path,
      List<Query>? query});
}

/// @nodoc
class __$$UrlImplCopyWithImpl<$Res> extends _$UrlCopyWithImpl<$Res, _$UrlImpl>
    implements _$$UrlImplCopyWith<$Res> {
  __$$UrlImplCopyWithImpl(_$UrlImpl _value, $Res Function(_$UrlImpl) _then)
      : super(_value, _then);

  /// Create a copy of Url
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? raw = freezed,
    Object? protocol = freezed,
    Object? host = freezed,
    Object? path = freezed,
    Object? query = freezed,
  }) {
    return _then(_$UrlImpl(
      raw: freezed == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as String?,
      protocol: freezed == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value._host
          : host // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      path: freezed == path
          ? _value._path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      query: freezed == query
          ? _value._query
          : query // ignore: cast_nullable_to_non_nullable
              as List<Query>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$UrlImpl implements _Url {
  const _$UrlImpl(
      {this.raw,
      this.protocol,
      final List<String>? host,
      final List<String>? path,
      final List<Query>? query})
      : _host = host,
        _path = path,
        _query = query;

  factory _$UrlImpl.fromJson(Map<String, dynamic> json) =>
      _$$UrlImplFromJson(json);

  @override
  final String? raw;
  @override
  final String? protocol;
  final List<String>? _host;
  @override
  List<String>? get host {
    final value = _host;
    if (value == null) return null;
    if (_host is EqualUnmodifiableListView) return _host;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _path;
  @override
  List<String>? get path {
    final value = _path;
    if (value == null) return null;
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Query>? _query;
  @override
  List<Query>? get query {
    final value = _query;
    if (value == null) return null;
    if (_query is EqualUnmodifiableListView) return _query;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Url(raw: $raw, protocol: $protocol, host: $host, path: $path, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UrlImpl &&
            (identical(other.raw, raw) || other.raw == raw) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            const DeepCollectionEquality().equals(other._host, _host) &&
            const DeepCollectionEquality().equals(other._path, _path) &&
            const DeepCollectionEquality().equals(other._query, _query));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      raw,
      protocol,
      const DeepCollectionEquality().hash(_host),
      const DeepCollectionEquality().hash(_path),
      const DeepCollectionEquality().hash(_query));

  /// Create a copy of Url
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UrlImplCopyWith<_$UrlImpl> get copyWith =>
      __$$UrlImplCopyWithImpl<_$UrlImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UrlImplToJson(
      this,
    );
  }
}

abstract class _Url implements Url {
  const factory _Url(
      {final String? raw,
      final String? protocol,
      final List<String>? host,
      final List<String>? path,
      final List<Query>? query}) = _$UrlImpl;

  factory _Url.fromJson(Map<String, dynamic> json) = _$UrlImpl.fromJson;

  @override
  String? get raw;
  @override
  String? get protocol;
  @override
  List<String>? get host;
  @override
  List<String>? get path;
  @override
  List<Query>? get query;

  /// Create a copy of Url
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UrlImplCopyWith<_$UrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Query _$QueryFromJson(Map<String, dynamic> json) {
  return _Query.fromJson(json);
}

/// @nodoc
mixin _$Query {
  String? get key => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;

  /// Serializes this Query to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueryCopyWith<Query> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryCopyWith<$Res> {
  factory $QueryCopyWith(Query value, $Res Function(Query) then) =
      _$QueryCopyWithImpl<$Res, Query>;
  @useResult
  $Res call({String? key, String? value, bool? disabled});
}

/// @nodoc
class _$QueryCopyWithImpl<$Res, $Val extends Query>
    implements $QueryCopyWith<$Res> {
  _$QueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
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
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryImplCopyWith<$Res> implements $QueryCopyWith<$Res> {
  factory _$$QueryImplCopyWith(
          _$QueryImpl value, $Res Function(_$QueryImpl) then) =
      __$$QueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? key, String? value, bool? disabled});
}

/// @nodoc
class __$$QueryImplCopyWithImpl<$Res>
    extends _$QueryCopyWithImpl<$Res, _$QueryImpl>
    implements _$$QueryImplCopyWith<$Res> {
  __$$QueryImplCopyWithImpl(
      _$QueryImpl _value, $Res Function(_$QueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_$QueryImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
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
class _$QueryImpl implements _Query {
  const _$QueryImpl({this.key, this.value, this.disabled});

  factory _$QueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueryImplFromJson(json);

  @override
  final String? key;
  @override
  final String? value;
  @override
  final bool? disabled;

  @override
  String toString() {
    return 'Query(key: $key, value: $value, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, disabled);

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryImplCopyWith<_$QueryImpl> get copyWith =>
      __$$QueryImplCopyWithImpl<_$QueryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueryImplToJson(
      this,
    );
  }
}

abstract class _Query implements Query {
  const factory _Query(
      {final String? key,
      final String? value,
      final bool? disabled}) = _$QueryImpl;

  factory _Query.fromJson(Map<String, dynamic> json) = _$QueryImpl.fromJson;

  @override
  String? get key;
  @override
  String? get value;
  @override
  bool? get disabled;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueryImplCopyWith<_$QueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Body _$BodyFromJson(Map<String, dynamic> json) {
  return _Body.fromJson(json);
}

/// @nodoc
mixin _$Body {
  String? get mode => throw _privateConstructorUsedError;
  String? get raw => throw _privateConstructorUsedError;
  Options? get options => throw _privateConstructorUsedError;
  List<Formdatum>? get formdata => throw _privateConstructorUsedError;

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
  $Res call(
      {String? mode, String? raw, Options? options, List<Formdatum>? formdata});

  $OptionsCopyWith<$Res>? get options;
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
    Object? mode = freezed,
    Object? raw = freezed,
    Object? options = freezed,
    Object? formdata = freezed,
  }) {
    return _then(_value.copyWith(
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      raw: freezed == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as Options?,
      formdata: freezed == formdata
          ? _value.formdata
          : formdata // ignore: cast_nullable_to_non_nullable
              as List<Formdatum>?,
    ) as $Val);
  }

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OptionsCopyWith<$Res>? get options {
    if (_value.options == null) {
      return null;
    }

    return $OptionsCopyWith<$Res>(_value.options!, (value) {
      return _then(_value.copyWith(options: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BodyImplCopyWith<$Res> implements $BodyCopyWith<$Res> {
  factory _$$BodyImplCopyWith(
          _$BodyImpl value, $Res Function(_$BodyImpl) then) =
      __$$BodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? mode, String? raw, Options? options, List<Formdatum>? formdata});

  @override
  $OptionsCopyWith<$Res>? get options;
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
    Object? mode = freezed,
    Object? raw = freezed,
    Object? options = freezed,
    Object? formdata = freezed,
  }) {
    return _then(_$BodyImpl(
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      raw: freezed == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as Options?,
      formdata: freezed == formdata
          ? _value._formdata
          : formdata // ignore: cast_nullable_to_non_nullable
              as List<Formdatum>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$BodyImpl implements _Body {
  const _$BodyImpl(
      {this.mode, this.raw, this.options, final List<Formdatum>? formdata})
      : _formdata = formdata;

  factory _$BodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyImplFromJson(json);

  @override
  final String? mode;
  @override
  final String? raw;
  @override
  final Options? options;
  final List<Formdatum>? _formdata;
  @override
  List<Formdatum>? get formdata {
    final value = _formdata;
    if (value == null) return null;
    if (_formdata is EqualUnmodifiableListView) return _formdata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Body(mode: $mode, raw: $raw, options: $options, formdata: $formdata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.raw, raw) || other.raw == raw) &&
            (identical(other.options, options) || other.options == options) &&
            const DeepCollectionEquality().equals(other._formdata, _formdata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mode, raw, options,
      const DeepCollectionEquality().hash(_formdata));

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
      {final String? mode,
      final String? raw,
      final Options? options,
      final List<Formdatum>? formdata}) = _$BodyImpl;

  factory _Body.fromJson(Map<String, dynamic> json) = _$BodyImpl.fromJson;

  @override
  String? get mode;
  @override
  String? get raw;
  @override
  Options? get options;
  @override
  List<Formdatum>? get formdata;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyImplCopyWith<_$BodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Options _$OptionsFromJson(Map<String, dynamic> json) {
  return _Options.fromJson(json);
}

/// @nodoc
mixin _$Options {
  Raw? get raw => throw _privateConstructorUsedError;

  /// Serializes this Options to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Options
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptionsCopyWith<Options> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptionsCopyWith<$Res> {
  factory $OptionsCopyWith(Options value, $Res Function(Options) then) =
      _$OptionsCopyWithImpl<$Res, Options>;
  @useResult
  $Res call({Raw? raw});

  $RawCopyWith<$Res>? get raw;
}

/// @nodoc
class _$OptionsCopyWithImpl<$Res, $Val extends Options>
    implements $OptionsCopyWith<$Res> {
  _$OptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Options
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? raw = freezed,
  }) {
    return _then(_value.copyWith(
      raw: freezed == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as Raw?,
    ) as $Val);
  }

  /// Create a copy of Options
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RawCopyWith<$Res>? get raw {
    if (_value.raw == null) {
      return null;
    }

    return $RawCopyWith<$Res>(_value.raw!, (value) {
      return _then(_value.copyWith(raw: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OptionsImplCopyWith<$Res> implements $OptionsCopyWith<$Res> {
  factory _$$OptionsImplCopyWith(
          _$OptionsImpl value, $Res Function(_$OptionsImpl) then) =
      __$$OptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Raw? raw});

  @override
  $RawCopyWith<$Res>? get raw;
}

/// @nodoc
class __$$OptionsImplCopyWithImpl<$Res>
    extends _$OptionsCopyWithImpl<$Res, _$OptionsImpl>
    implements _$$OptionsImplCopyWith<$Res> {
  __$$OptionsImplCopyWithImpl(
      _$OptionsImpl _value, $Res Function(_$OptionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Options
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? raw = freezed,
  }) {
    return _then(_$OptionsImpl(
      raw: freezed == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as Raw?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$OptionsImpl implements _Options {
  const _$OptionsImpl({this.raw});

  factory _$OptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptionsImplFromJson(json);

  @override
  final Raw? raw;

  @override
  String toString() {
    return 'Options(raw: $raw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptionsImpl &&
            (identical(other.raw, raw) || other.raw == raw));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, raw);

  /// Create a copy of Options
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptionsImplCopyWith<_$OptionsImpl> get copyWith =>
      __$$OptionsImplCopyWithImpl<_$OptionsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OptionsImplToJson(
      this,
    );
  }
}

abstract class _Options implements Options {
  const factory _Options({final Raw? raw}) = _$OptionsImpl;

  factory _Options.fromJson(Map<String, dynamic> json) = _$OptionsImpl.fromJson;

  @override
  Raw? get raw;

  /// Create a copy of Options
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptionsImplCopyWith<_$OptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Raw _$RawFromJson(Map<String, dynamic> json) {
  return _Raw.fromJson(json);
}

/// @nodoc
mixin _$Raw {
  String? get language => throw _privateConstructorUsedError;

  /// Serializes this Raw to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Raw
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RawCopyWith<Raw> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RawCopyWith<$Res> {
  factory $RawCopyWith(Raw value, $Res Function(Raw) then) =
      _$RawCopyWithImpl<$Res, Raw>;
  @useResult
  $Res call({String? language});
}

/// @nodoc
class _$RawCopyWithImpl<$Res, $Val extends Raw> implements $RawCopyWith<$Res> {
  _$RawCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Raw
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = freezed,
  }) {
    return _then(_value.copyWith(
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RawImplCopyWith<$Res> implements $RawCopyWith<$Res> {
  factory _$$RawImplCopyWith(_$RawImpl value, $Res Function(_$RawImpl) then) =
      __$$RawImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? language});
}

/// @nodoc
class __$$RawImplCopyWithImpl<$Res> extends _$RawCopyWithImpl<$Res, _$RawImpl>
    implements _$$RawImplCopyWith<$Res> {
  __$$RawImplCopyWithImpl(_$RawImpl _value, $Res Function(_$RawImpl) _then)
      : super(_value, _then);

  /// Create a copy of Raw
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = freezed,
  }) {
    return _then(_$RawImpl(
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$RawImpl implements _Raw {
  const _$RawImpl({this.language});

  factory _$RawImpl.fromJson(Map<String, dynamic> json) =>
      _$$RawImplFromJson(json);

  @override
  final String? language;

  @override
  String toString() {
    return 'Raw(language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RawImpl &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, language);

  /// Create a copy of Raw
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RawImplCopyWith<_$RawImpl> get copyWith =>
      __$$RawImplCopyWithImpl<_$RawImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RawImplToJson(
      this,
    );
  }
}

abstract class _Raw implements Raw {
  const factory _Raw({final String? language}) = _$RawImpl;

  factory _Raw.fromJson(Map<String, dynamic> json) = _$RawImpl.fromJson;

  @override
  String? get language;

  /// Create a copy of Raw
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RawImplCopyWith<_$RawImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Formdatum _$FormdatumFromJson(Map<String, dynamic> json) {
  return _Formdatum.fromJson(json);
}

/// @nodoc
mixin _$Formdatum {
  String? get key => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
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
  $Res call({String? key, String? value, String? type, String? src});
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
    Object? key = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? src = freezed,
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
  $Res call({String? key, String? value, String? type, String? src});
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
    Object? key = freezed,
    Object? value = freezed,
    Object? type = freezed,
    Object? src = freezed,
  }) {
    return _then(_$FormdatumImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
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
  const _$FormdatumImpl({this.key, this.value, this.type, this.src});

  factory _$FormdatumImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormdatumImplFromJson(json);

  @override
  final String? key;
  @override
  final String? value;
  @override
  final String? type;
  @override
  final String? src;

  @override
  String toString() {
    return 'Formdatum(key: $key, value: $value, type: $type, src: $src)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormdatumImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.src, src) || other.src == src));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, type, src);

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
      {final String? key,
      final String? value,
      final String? type,
      final String? src}) = _$FormdatumImpl;

  factory _Formdatum.fromJson(Map<String, dynamic> json) =
      _$FormdatumImpl.fromJson;

  @override
  String? get key;
  @override
  String? get value;
  @override
  String? get type;
  @override
  String? get src;

  /// Create a copy of Formdatum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormdatumImplCopyWith<_$FormdatumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
