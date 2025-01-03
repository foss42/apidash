// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graphql_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GraphqlRequestModel _$GraphqlRequestModelFromJson(Map<String, dynamic> json) {
  return _GraphqlRequestModel.fromJson(json);
}

/// @nodoc
mixin _$GraphqlRequestModel {
  String get url => throw _privateConstructorUsedError;
  List<NameValueModel>? get headers => throw _privateConstructorUsedError;
  String? get query => throw _privateConstructorUsedError;
  List<NameValueModel>? get graphqlVariables =>
      throw _privateConstructorUsedError;
  List<bool>? get isHeaderEnabledList => throw _privateConstructorUsedError;
  List<bool>? get isgraphqlVariablesEnabledList =>
      throw _privateConstructorUsedError;

  /// Serializes this GraphqlRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphqlRequestModelCopyWith<GraphqlRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphqlRequestModelCopyWith<$Res> {
  factory $GraphqlRequestModelCopyWith(
          GraphqlRequestModel value, $Res Function(GraphqlRequestModel) then) =
      _$GraphqlRequestModelCopyWithImpl<$Res, GraphqlRequestModel>;
  @useResult
  $Res call(
      {String url,
      List<NameValueModel>? headers,
      String? query,
      List<NameValueModel>? graphqlVariables,
      List<bool>? isHeaderEnabledList,
      List<bool>? isgraphqlVariablesEnabledList});
}

/// @nodoc
class _$GraphqlRequestModelCopyWithImpl<$Res, $Val extends GraphqlRequestModel>
    implements $GraphqlRequestModelCopyWith<$Res> {
  _$GraphqlRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? headers = freezed,
    Object? query = freezed,
    Object? graphqlVariables = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? isgraphqlVariablesEnabledList = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      graphqlVariables: freezed == graphqlVariables
          ? _value.graphqlVariables
          : graphqlVariables // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _value.isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      isgraphqlVariablesEnabledList: freezed == isgraphqlVariablesEnabledList
          ? _value.isgraphqlVariablesEnabledList
          : isgraphqlVariablesEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphqlRequestModelImplCopyWith<$Res>
    implements $GraphqlRequestModelCopyWith<$Res> {
  factory _$$GraphqlRequestModelImplCopyWith(_$GraphqlRequestModelImpl value,
          $Res Function(_$GraphqlRequestModelImpl) then) =
      __$$GraphqlRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      List<NameValueModel>? headers,
      String? query,
      List<NameValueModel>? graphqlVariables,
      List<bool>? isHeaderEnabledList,
      List<bool>? isgraphqlVariablesEnabledList});
}

/// @nodoc
class __$$GraphqlRequestModelImplCopyWithImpl<$Res>
    extends _$GraphqlRequestModelCopyWithImpl<$Res, _$GraphqlRequestModelImpl>
    implements _$$GraphqlRequestModelImplCopyWith<$Res> {
  __$$GraphqlRequestModelImplCopyWithImpl(_$GraphqlRequestModelImpl _value,
      $Res Function(_$GraphqlRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? headers = freezed,
    Object? query = freezed,
    Object? graphqlVariables = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? isgraphqlVariablesEnabledList = freezed,
  }) {
    return _then(_$GraphqlRequestModelImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      graphqlVariables: freezed == graphqlVariables
          ? _value._graphqlVariables
          : graphqlVariables // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _value._isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      isgraphqlVariablesEnabledList: freezed == isgraphqlVariablesEnabledList
          ? _value._isgraphqlVariablesEnabledList
          : isgraphqlVariablesEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$GraphqlRequestModelImpl extends _GraphqlRequestModel {
  const _$GraphqlRequestModelImpl(
      {this.url = "",
      final List<NameValueModel>? headers,
      this.query,
      final List<NameValueModel>? graphqlVariables,
      final List<bool>? isHeaderEnabledList,
      final List<bool>? isgraphqlVariablesEnabledList})
      : _headers = headers,
        _graphqlVariables = graphqlVariables,
        _isHeaderEnabledList = isHeaderEnabledList,
        _isgraphqlVariablesEnabledList = isgraphqlVariablesEnabledList,
        super._();

  factory _$GraphqlRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphqlRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final String url;
  final List<NameValueModel>? _headers;
  @override
  List<NameValueModel>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? query;
  final List<NameValueModel>? _graphqlVariables;
  @override
  List<NameValueModel>? get graphqlVariables {
    final value = _graphqlVariables;
    if (value == null) return null;
    if (_graphqlVariables is EqualUnmodifiableListView)
      return _graphqlVariables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<bool>? _isHeaderEnabledList;
  @override
  List<bool>? get isHeaderEnabledList {
    final value = _isHeaderEnabledList;
    if (value == null) return null;
    if (_isHeaderEnabledList is EqualUnmodifiableListView)
      return _isHeaderEnabledList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<bool>? _isgraphqlVariablesEnabledList;
  @override
  List<bool>? get isgraphqlVariablesEnabledList {
    final value = _isgraphqlVariablesEnabledList;
    if (value == null) return null;
    if (_isgraphqlVariablesEnabledList is EqualUnmodifiableListView)
      return _isgraphqlVariablesEnabledList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GraphqlRequestModel(url: $url, headers: $headers, query: $query, graphqlVariables: $graphqlVariables, isHeaderEnabledList: $isHeaderEnabledList, isgraphqlVariablesEnabledList: $isgraphqlVariablesEnabledList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphqlRequestModelImpl &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality()
                .equals(other._graphqlVariables, _graphqlVariables) &&
            const DeepCollectionEquality()
                .equals(other._isHeaderEnabledList, _isHeaderEnabledList) &&
            const DeepCollectionEquality().equals(
                other._isgraphqlVariablesEnabledList,
                _isgraphqlVariablesEnabledList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      const DeepCollectionEquality().hash(_headers),
      query,
      const DeepCollectionEquality().hash(_graphqlVariables),
      const DeepCollectionEquality().hash(_isHeaderEnabledList),
      const DeepCollectionEquality().hash(_isgraphqlVariablesEnabledList));

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphqlRequestModelImplCopyWith<_$GraphqlRequestModelImpl> get copyWith =>
      __$$GraphqlRequestModelImplCopyWithImpl<_$GraphqlRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphqlRequestModelImplToJson(
      this,
    );
  }
}

abstract class _GraphqlRequestModel extends GraphqlRequestModel {
  const factory _GraphqlRequestModel(
          {final String url,
          final List<NameValueModel>? headers,
          final String? query,
          final List<NameValueModel>? graphqlVariables,
          final List<bool>? isHeaderEnabledList,
          final List<bool>? isgraphqlVariablesEnabledList}) =
      _$GraphqlRequestModelImpl;
  const _GraphqlRequestModel._() : super._();

  factory _GraphqlRequestModel.fromJson(Map<String, dynamic> json) =
      _$GraphqlRequestModelImpl.fromJson;

  @override
  String get url;
  @override
  List<NameValueModel>? get headers;
  @override
  String? get query;
  @override
  List<NameValueModel>? get graphqlVariables;
  @override
  List<bool>? get isHeaderEnabledList;
  @override
  List<bool>? get isgraphqlVariablesEnabledList;

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphqlRequestModelImplCopyWith<_$GraphqlRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
