// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hurl_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HurlFile _$HurlFileFromJson(Map<String, dynamic> json) {
  return _HurlFile.fromJson(json);
}

/// @nodoc
mixin _$HurlFile {
  List<HurlEntry> get entries => throw _privateConstructorUsedError;

  /// Serializes this HurlFile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HurlFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HurlFileCopyWith<HurlFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HurlFileCopyWith<$Res> {
  factory $HurlFileCopyWith(HurlFile value, $Res Function(HurlFile) then) =
      _$HurlFileCopyWithImpl<$Res, HurlFile>;
  @useResult
  $Res call({List<HurlEntry> entries});
}

/// @nodoc
class _$HurlFileCopyWithImpl<$Res, $Val extends HurlFile>
    implements $HurlFileCopyWith<$Res> {
  _$HurlFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HurlFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<HurlEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HurlFileImplCopyWith<$Res>
    implements $HurlFileCopyWith<$Res> {
  factory _$$HurlFileImplCopyWith(
          _$HurlFileImpl value, $Res Function(_$HurlFileImpl) then) =
      __$$HurlFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<HurlEntry> entries});
}

/// @nodoc
class __$$HurlFileImplCopyWithImpl<$Res>
    extends _$HurlFileCopyWithImpl<$Res, _$HurlFileImpl>
    implements _$$HurlFileImplCopyWith<$Res> {
  __$$HurlFileImplCopyWithImpl(
      _$HurlFileImpl _value, $Res Function(_$HurlFileImpl) _then)
      : super(_value, _then);

  /// Create a copy of HurlFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
  }) {
    return _then(_$HurlFileImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<HurlEntry>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$HurlFileImpl implements _HurlFile {
  const _$HurlFileImpl({required final List<HurlEntry> entries})
      : _entries = entries;

  factory _$HurlFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$HurlFileImplFromJson(json);

  final List<HurlEntry> _entries;
  @override
  List<HurlEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  String toString() {
    return 'HurlFile(entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HurlFileImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_entries));

  /// Create a copy of HurlFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HurlFileImplCopyWith<_$HurlFileImpl> get copyWith =>
      __$$HurlFileImplCopyWithImpl<_$HurlFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HurlFileImplToJson(
      this,
    );
  }
}

abstract class _HurlFile implements HurlFile {
  const factory _HurlFile({required final List<HurlEntry> entries}) =
      _$HurlFileImpl;

  factory _HurlFile.fromJson(Map<String, dynamic> json) =
      _$HurlFileImpl.fromJson;

  @override
  List<HurlEntry> get entries;

  /// Create a copy of HurlFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HurlFileImplCopyWith<_$HurlFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
