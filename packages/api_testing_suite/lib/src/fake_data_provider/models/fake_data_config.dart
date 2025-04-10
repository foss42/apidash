import 'package:json_annotation/json_annotation.dart';

part 'fake_data_config.g.dart';

@JsonSerializable()
class FakeDataConfig {
  final List<String> tags;
  final int iterations;
  final bool includeTimestamp;

  FakeDataConfig({
    this.tags = const [],
    this.iterations = 10,
    this.includeTimestamp = false,
  });

  factory FakeDataConfig.fromJson(Map<String, dynamic> json) => _$FakeDataConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FakeDataConfigToJson(this);
}
