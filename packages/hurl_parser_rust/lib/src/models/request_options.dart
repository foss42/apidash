// request_options.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_options.freezed.dart';
part 'request_options.g.dart';

@freezed
class RequestOptions with _$RequestOptions {
  const factory RequestOptions({
    String? awsSigv4,
    String? cacert,
    String? cert,
    String? key,
    bool? compressed,
    String? connectTimeout,
    String? delay,
    bool? http3,
    bool? insecure,
    bool? ipv6,
    int? limitRate,
    bool? location,
    int? maxRedirs,
    String? output,
    bool? pathAsIs,
    int? retry,
    String? retryInterval,
    bool? skip,
    String? unixSocket,
    String? user,
    String? proxy,
    Map<String, String>? variables,
    bool? verbose,
    bool? veryVerbose,
  }) = _RequestOptions;

  factory RequestOptions.fromJson(Map<String, dynamic> json) =>
      _$RequestOptionsFromJson(json);
}
