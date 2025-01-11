// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestOptionsImpl _$$RequestOptionsImplFromJson(Map<String, dynamic> json) =>
    _$RequestOptionsImpl(
      awsSigv4: json['awsSigv4'] as String?,
      cacert: json['cacert'] as String?,
      cert: json['cert'] as String?,
      key: json['key'] as String?,
      compressed: json['compressed'] as bool?,
      connectTimeout: json['connectTimeout'] as String?,
      delay: json['delay'] as String?,
      http3: json['http3'] as bool?,
      insecure: json['insecure'] as bool?,
      ipv6: json['ipv6'] as bool?,
      limitRate: (json['limitRate'] as num?)?.toInt(),
      location: json['location'] as bool?,
      maxRedirs: (json['maxRedirs'] as num?)?.toInt(),
      output: json['output'] as String?,
      pathAsIs: json['pathAsIs'] as bool?,
      retry: (json['retry'] as num?)?.toInt(),
      retryInterval: json['retryInterval'] as String?,
      skip: json['skip'] as bool?,
      unixSocket: json['unixSocket'] as String?,
      user: json['user'] as String?,
      proxy: json['proxy'] as String?,
      variables: (json['variables'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      verbose: json['verbose'] as bool?,
      veryVerbose: json['veryVerbose'] as bool?,
    );

Map<String, dynamic> _$$RequestOptionsImplToJson(
        _$RequestOptionsImpl instance) =>
    <String, dynamic>{
      'awsSigv4': instance.awsSigv4,
      'cacert': instance.cacert,
      'cert': instance.cert,
      'key': instance.key,
      'compressed': instance.compressed,
      'connectTimeout': instance.connectTimeout,
      'delay': instance.delay,
      'http3': instance.http3,
      'insecure': instance.insecure,
      'ipv6': instance.ipv6,
      'limitRate': instance.limitRate,
      'location': instance.location,
      'maxRedirs': instance.maxRedirs,
      'output': instance.output,
      'pathAsIs': instance.pathAsIs,
      'retry': instance.retry,
      'retryInterval': instance.retryInterval,
      'skip': instance.skip,
      'unixSocket': instance.unixSocket,
      'user': instance.user,
      'proxy': instance.proxy,
      'variables': instance.variables,
      'verbose': instance.verbose,
      'veryVerbose': instance.veryVerbose,
    };
