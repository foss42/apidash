// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MQTTRequestModel _$MQTTRequestModelFromJson(Map<String, dynamic> json) {
  return _MQTTRequestModel.fromJson(json);
}

/// @nodoc
mixin _$MQTTRequestModel {
  String get brokerUrl => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  int get keepAlive => throw _privateConstructorUsedError;
  bool get cleanSession => throw _privateConstructorUsedError;
  int get connectTimeout => throw _privateConstructorUsedError;
  List<MQTTTopicModel> get topics => throw _privateConstructorUsedError;
  String get publishTopic => throw _privateConstructorUsedError;
  String get publishPayload => throw _privateConstructorUsedError;
  int get publishQos => throw _privateConstructorUsedError;
  bool get publishRetain => throw _privateConstructorUsedError;

  /// Serializes this MQTTRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MQTTRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MQTTRequestModelCopyWith<MQTTRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MQTTRequestModelCopyWith<$Res> {
  factory $MQTTRequestModelCopyWith(
          MQTTRequestModel value, $Res Function(MQTTRequestModel) then) =
      _$MQTTRequestModelCopyWithImpl<$Res, MQTTRequestModel>;
  @useResult
  $Res call(
      {String brokerUrl,
      int port,
      String clientId,
      String username,
      String password,
      int keepAlive,
      bool cleanSession,
      int connectTimeout,
      List<MQTTTopicModel> topics,
      String publishTopic,
      String publishPayload,
      int publishQos,
      bool publishRetain});
}

/// @nodoc
class _$MQTTRequestModelCopyWithImpl<$Res, $Val extends MQTTRequestModel>
    implements $MQTTRequestModelCopyWith<$Res> {
  _$MQTTRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MQTTRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brokerUrl = null,
    Object? port = null,
    Object? clientId = null,
    Object? username = null,
    Object? password = null,
    Object? keepAlive = null,
    Object? cleanSession = null,
    Object? connectTimeout = null,
    Object? topics = null,
    Object? publishTopic = null,
    Object? publishPayload = null,
    Object? publishQos = null,
    Object? publishRetain = null,
  }) {
    return _then(_value.copyWith(
      brokerUrl: null == brokerUrl
          ? _value.brokerUrl
          : brokerUrl // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      keepAlive: null == keepAlive
          ? _value.keepAlive
          : keepAlive // ignore: cast_nullable_to_non_nullable
              as int,
      cleanSession: null == cleanSession
          ? _value.cleanSession
          : cleanSession // ignore: cast_nullable_to_non_nullable
              as bool,
      connectTimeout: null == connectTimeout
          ? _value.connectTimeout
          : connectTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<MQTTTopicModel>,
      publishTopic: null == publishTopic
          ? _value.publishTopic
          : publishTopic // ignore: cast_nullable_to_non_nullable
              as String,
      publishPayload: null == publishPayload
          ? _value.publishPayload
          : publishPayload // ignore: cast_nullable_to_non_nullable
              as String,
      publishQos: null == publishQos
          ? _value.publishQos
          : publishQos // ignore: cast_nullable_to_non_nullable
              as int,
      publishRetain: null == publishRetain
          ? _value.publishRetain
          : publishRetain // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MQTTRequestModelImplCopyWith<$Res>
    implements $MQTTRequestModelCopyWith<$Res> {
  factory _$$MQTTRequestModelImplCopyWith(_$MQTTRequestModelImpl value,
          $Res Function(_$MQTTRequestModelImpl) then) =
      __$$MQTTRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String brokerUrl,
      int port,
      String clientId,
      String username,
      String password,
      int keepAlive,
      bool cleanSession,
      int connectTimeout,
      List<MQTTTopicModel> topics,
      String publishTopic,
      String publishPayload,
      int publishQos,
      bool publishRetain});
}

/// @nodoc
class __$$MQTTRequestModelImplCopyWithImpl<$Res>
    extends _$MQTTRequestModelCopyWithImpl<$Res, _$MQTTRequestModelImpl>
    implements _$$MQTTRequestModelImplCopyWith<$Res> {
  __$$MQTTRequestModelImplCopyWithImpl(_$MQTTRequestModelImpl _value,
      $Res Function(_$MQTTRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MQTTRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brokerUrl = null,
    Object? port = null,
    Object? clientId = null,
    Object? username = null,
    Object? password = null,
    Object? keepAlive = null,
    Object? cleanSession = null,
    Object? connectTimeout = null,
    Object? topics = null,
    Object? publishTopic = null,
    Object? publishPayload = null,
    Object? publishQos = null,
    Object? publishRetain = null,
  }) {
    return _then(_$MQTTRequestModelImpl(
      brokerUrl: null == brokerUrl
          ? _value.brokerUrl
          : brokerUrl // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      keepAlive: null == keepAlive
          ? _value.keepAlive
          : keepAlive // ignore: cast_nullable_to_non_nullable
              as int,
      cleanSession: null == cleanSession
          ? _value.cleanSession
          : cleanSession // ignore: cast_nullable_to_non_nullable
              as bool,
      connectTimeout: null == connectTimeout
          ? _value.connectTimeout
          : connectTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<MQTTTopicModel>,
      publishTopic: null == publishTopic
          ? _value.publishTopic
          : publishTopic // ignore: cast_nullable_to_non_nullable
              as String,
      publishPayload: null == publishPayload
          ? _value.publishPayload
          : publishPayload // ignore: cast_nullable_to_non_nullable
              as String,
      publishQos: null == publishQos
          ? _value.publishQos
          : publishQos // ignore: cast_nullable_to_non_nullable
              as int,
      publishRetain: null == publishRetain
          ? _value.publishRetain
          : publishRetain // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MQTTRequestModelImpl implements _MQTTRequestModel {
  const _$MQTTRequestModelImpl(
      {this.brokerUrl = "",
      this.port = 1883,
      this.clientId = "",
      this.username = "",
      this.password = "",
      this.keepAlive = 60,
      this.cleanSession = false,
      this.connectTimeout = 3,
      final List<MQTTTopicModel> topics = const [],
      this.publishTopic = "",
      this.publishPayload = "",
      this.publishQos = 0,
      this.publishRetain = false})
      : _topics = topics;

  factory _$MQTTRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MQTTRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final String brokerUrl;
  @override
  @JsonKey()
  final int port;
  @override
  @JsonKey()
  final String clientId;
  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final int keepAlive;
  @override
  @JsonKey()
  final bool cleanSession;
  @override
  @JsonKey()
  final int connectTimeout;
  final List<MQTTTopicModel> _topics;
  @override
  @JsonKey()
  List<MQTTTopicModel> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  @JsonKey()
  final String publishTopic;
  @override
  @JsonKey()
  final String publishPayload;
  @override
  @JsonKey()
  final int publishQos;
  @override
  @JsonKey()
  final bool publishRetain;

  @override
  String toString() {
    return 'MQTTRequestModel(brokerUrl: $brokerUrl, port: $port, clientId: $clientId, username: $username, password: $password, keepAlive: $keepAlive, cleanSession: $cleanSession, connectTimeout: $connectTimeout, topics: $topics, publishTopic: $publishTopic, publishPayload: $publishPayload, publishQos: $publishQos, publishRetain: $publishRetain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MQTTRequestModelImpl &&
            (identical(other.brokerUrl, brokerUrl) ||
                other.brokerUrl == brokerUrl) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.keepAlive, keepAlive) ||
                other.keepAlive == keepAlive) &&
            (identical(other.cleanSession, cleanSession) ||
                other.cleanSession == cleanSession) &&
            (identical(other.connectTimeout, connectTimeout) ||
                other.connectTimeout == connectTimeout) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            (identical(other.publishTopic, publishTopic) ||
                other.publishTopic == publishTopic) &&
            (identical(other.publishPayload, publishPayload) ||
                other.publishPayload == publishPayload) &&
            (identical(other.publishQos, publishQos) ||
                other.publishQos == publishQos) &&
            (identical(other.publishRetain, publishRetain) ||
                other.publishRetain == publishRetain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      brokerUrl,
      port,
      clientId,
      username,
      password,
      keepAlive,
      cleanSession,
      connectTimeout,
      const DeepCollectionEquality().hash(_topics),
      publishTopic,
      publishPayload,
      publishQos,
      publishRetain);

  /// Create a copy of MQTTRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MQTTRequestModelImplCopyWith<_$MQTTRequestModelImpl> get copyWith =>
      __$$MQTTRequestModelImplCopyWithImpl<_$MQTTRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MQTTRequestModelImplToJson(
      this,
    );
  }
}

abstract class _MQTTRequestModel implements MQTTRequestModel {
  const factory _MQTTRequestModel(
      {final String brokerUrl,
      final int port,
      final String clientId,
      final String username,
      final String password,
      final int keepAlive,
      final bool cleanSession,
      final int connectTimeout,
      final List<MQTTTopicModel> topics,
      final String publishTopic,
      final String publishPayload,
      final int publishQos,
      final bool publishRetain}) = _$MQTTRequestModelImpl;

  factory _MQTTRequestModel.fromJson(Map<String, dynamic> json) =
      _$MQTTRequestModelImpl.fromJson;

  @override
  String get brokerUrl;
  @override
  int get port;
  @override
  String get clientId;
  @override
  String get username;
  @override
  String get password;
  @override
  int get keepAlive;
  @override
  bool get cleanSession;
  @override
  int get connectTimeout;
  @override
  List<MQTTTopicModel> get topics;
  @override
  String get publishTopic;
  @override
  String get publishPayload;
  @override
  int get publishQos;
  @override
  bool get publishRetain;

  /// Create a copy of MQTTRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MQTTRequestModelImplCopyWith<_$MQTTRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MQTTTopicModel _$MQTTTopicModelFromJson(Map<String, dynamic> json) {
  return _MQTTTopicModel.fromJson(json);
}

/// @nodoc
mixin _$MQTTTopicModel {
  String get topic => throw _privateConstructorUsedError;
  int get qos => throw _privateConstructorUsedError;
  bool get subscribe => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this MQTTTopicModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MQTTTopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MQTTTopicModelCopyWith<MQTTTopicModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MQTTTopicModelCopyWith<$Res> {
  factory $MQTTTopicModelCopyWith(
          MQTTTopicModel value, $Res Function(MQTTTopicModel) then) =
      _$MQTTTopicModelCopyWithImpl<$Res, MQTTTopicModel>;
  @useResult
  $Res call({String topic, int qos, bool subscribe, String description});
}

/// @nodoc
class _$MQTTTopicModelCopyWithImpl<$Res, $Val extends MQTTTopicModel>
    implements $MQTTTopicModelCopyWith<$Res> {
  _$MQTTTopicModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MQTTTopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? qos = null,
    Object? subscribe = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      qos: null == qos
          ? _value.qos
          : qos // ignore: cast_nullable_to_non_nullable
              as int,
      subscribe: null == subscribe
          ? _value.subscribe
          : subscribe // ignore: cast_nullable_to_non_nullable
              as bool,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MQTTTopicModelImplCopyWith<$Res>
    implements $MQTTTopicModelCopyWith<$Res> {
  factory _$$MQTTTopicModelImplCopyWith(_$MQTTTopicModelImpl value,
          $Res Function(_$MQTTTopicModelImpl) then) =
      __$$MQTTTopicModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String topic, int qos, bool subscribe, String description});
}

/// @nodoc
class __$$MQTTTopicModelImplCopyWithImpl<$Res>
    extends _$MQTTTopicModelCopyWithImpl<$Res, _$MQTTTopicModelImpl>
    implements _$$MQTTTopicModelImplCopyWith<$Res> {
  __$$MQTTTopicModelImplCopyWithImpl(
      _$MQTTTopicModelImpl _value, $Res Function(_$MQTTTopicModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MQTTTopicModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? qos = null,
    Object? subscribe = null,
    Object? description = null,
  }) {
    return _then(_$MQTTTopicModelImpl(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      qos: null == qos
          ? _value.qos
          : qos // ignore: cast_nullable_to_non_nullable
              as int,
      subscribe: null == subscribe
          ? _value.subscribe
          : subscribe // ignore: cast_nullable_to_non_nullable
              as bool,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MQTTTopicModelImpl implements _MQTTTopicModel {
  const _$MQTTTopicModelImpl(
      {required this.topic,
      this.qos = 0,
      this.subscribe = false,
      this.description = ""});

  factory _$MQTTTopicModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MQTTTopicModelImplFromJson(json);

  @override
  final String topic;
  @override
  @JsonKey()
  final int qos;
  @override
  @JsonKey()
  final bool subscribe;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'MQTTTopicModel(topic: $topic, qos: $qos, subscribe: $subscribe, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MQTTTopicModelImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.qos, qos) || other.qos == qos) &&
            (identical(other.subscribe, subscribe) ||
                other.subscribe == subscribe) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, topic, qos, subscribe, description);

  /// Create a copy of MQTTTopicModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MQTTTopicModelImplCopyWith<_$MQTTTopicModelImpl> get copyWith =>
      __$$MQTTTopicModelImplCopyWithImpl<_$MQTTTopicModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MQTTTopicModelImplToJson(
      this,
    );
  }
}

abstract class _MQTTTopicModel implements MQTTTopicModel {
  const factory _MQTTTopicModel(
      {required final String topic,
      final int qos,
      final bool subscribe,
      final String description}) = _$MQTTTopicModelImpl;

  factory _MQTTTopicModel.fromJson(Map<String, dynamic> json) =
      _$MQTTTopicModelImpl.fromJson;

  @override
  String get topic;
  @override
  int get qos;
  @override
  bool get subscribe;
  @override
  String get description;

  /// Create a copy of MQTTTopicModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MQTTTopicModelImplCopyWith<_$MQTTTopicModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
