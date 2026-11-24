/// Load profile shapes supported by API Dash performance tests.
///
/// The engine that schedules virtual users is added in a later step; this
/// enum and [PerfLoadProfile] only describe the configuration so it can be
/// stored in, and imported from, the versioned results format.
enum PerfLoadProfileType {
  /// Constant number of virtual users for the whole test duration.
  fixed,

  /// Virtual users increase linearly from the starting count to
  /// [PerfLoadProfile.virtualUsers] over [PerfLoadProfile.rampDurationSeconds],
  /// then hold for the remainder of the test.
  rampUp,

  /// A sudden burst: [PerfLoadProfile.baselineVirtualUsers] virtual users,
  /// jumping to [PerfLoadProfile.virtualUsers] for
  /// [PerfLoadProfile.spikeDurationSeconds], then returning to baseline.
  spike,

  /// Sustained load at or near [PerfLoadProfile.virtualUsers] for the whole
  /// test, used to find the breaking point of the target.
  peak,
}

/// Serializable description of a performance test's load profile.
class PerfLoadProfile {
  const PerfLoadProfile({
    required this.type,
    this.virtualUsers,
    this.rampDurationSeconds,
    this.baselineVirtualUsers,
    this.spikeDurationSeconds,
  });

  final PerfLoadProfileType type;

  /// Target (or peak) virtual user count. Required for [PerfLoadProfileType
  /// .fixed], [PerfLoadProfileType.rampUp], [PerfLoadProfileType.spike] and
  /// [PerfLoadProfileType.peak].
  final int? virtualUsers;

  /// Ramp-up length in seconds. Only meaningful for
  /// [PerfLoadProfileType.rampUp].
  final int? rampDurationSeconds;

  /// Virtual users before and after the spike. Only meaningful for
  /// [PerfLoadProfileType.spike].
  final int? baselineVirtualUsers;

  /// Spike length in seconds. Only meaningful for [PerfLoadProfileType.spike].
  final int? spikeDurationSeconds;

  Map<String, Object?> toJson() => {
    'type': type.name,
    if (virtualUsers != null) 'virtualUsers': virtualUsers,
    if (rampDurationSeconds != null) 'rampDurationSeconds': rampDurationSeconds,
    if (baselineVirtualUsers != null)
      'baselineVirtualUsers': baselineVirtualUsers,
    if (spikeDurationSeconds != null)
      'spikeDurationSeconds': spikeDurationSeconds,
  };

  factory PerfLoadProfile.fromJson(Map<String, Object?> json) {
    final typeName = json['type'] as String?;
    final type = PerfLoadProfileType.values.asNameMap()[typeName];
    if (type == null) {
      throw FormatException('Unknown perf load profile type: $typeName');
    }
    return PerfLoadProfile(
      type: type,
      virtualUsers: (json['virtualUsers'] as num?)?.toInt(),
      rampDurationSeconds: (json['rampDurationSeconds'] as num?)?.toInt(),
      baselineVirtualUsers: (json['baselineVirtualUsers'] as num?)?.toInt(),
      spikeDurationSeconds: (json['spikeDurationSeconds'] as num?)?.toInt(),
    );
  }

  @override
  String toString() => 'PerfLoadProfile(${toJson()})';
}
