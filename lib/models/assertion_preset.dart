// DashAssert – Assertion Preset Templates
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'package:apidash/models/assertion_model.dart';
import 'package:apidash/consts.dart';

/// A named collection of [AssertionRule]s that can be applied in one click.
///
/// Built-in presets are available via [kDashAssertPresets].
class AssertionPreset {
  final String id;
  final String name;
  final String description;

  /// Emoji icon used in the Templates picker UI.
  final String icon;

  final List<AssertionRule> rules;

  const AssertionPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.rules,
  });
}

/// Built-in presets available in the DashAssert Templates picker.
final kDashAssertPresets = <AssertionPreset>[
  AssertionPreset(
    id: 'rest_standard',
    name: kPresetRestStandard,
    description: 'Basic checks every REST API response should pass',
    icon: '🌐',
    rules: [
      AssertionRule(
        id: 'preset_rs_1',
        type: AssertionType.statusCode,
        description: 'Status code is 200 OK',
        expectedValue: 200,
      ),
      AssertionRule(
        id: 'preset_rs_2',
        type: AssertionType.headerExists,
        description: 'Content-Type header is present',
        expectedValue: 'content-type',
      ),
      AssertionRule(
        id: 'preset_rs_3',
        type: AssertionType.responseTimeUnder,
        description: 'Response time under 2000ms',
        expectedValue: 2000,
      ),
    ],
  ),

  AssertionPreset(
    id: 'auth_protected',
    name: kPresetAuthProtected,
    description: 'Ensures endpoint rejects unauthenticated requests properly',
    icon: '🔐',
    rules: [
      AssertionRule(
        id: 'preset_ap_1',
        type: AssertionType.statusCode,
        description: 'Status is 401 Unauthorized',
        expectedValue: 401,
      ),
      AssertionRule(
        id: 'preset_ap_2',
        type: AssertionType.headerExists,
        description: 'WWW-Authenticate header present',
        expectedValue: 'www-authenticate',
      ),
    ],
  ),

  AssertionPreset(
    id: 'crud_success',
    name: kPresetCrudSuccess,
    description: 'Validates a successful create/update/delete operation',
    icon: '✏️',
    rules: [
      AssertionRule(
        id: 'preset_cs_1',
        type: AssertionType.statusCode,
        description: 'Status is 201 Created',
        expectedValue: 201,
      ),
      AssertionRule(
        id: 'preset_cs_2',
        type: AssertionType.jsonFieldExists,
        description: 'Response contains an id field',
        jsonPath: 'id',
      ),
      AssertionRule(
        id: 'preset_cs_3',
        type: AssertionType.responseTimeUnder,
        description: 'Response time under 1000ms',
        expectedValue: 1000,
      ),
    ],
  ),

  AssertionPreset(
    id: 'paginated_list',
    name: kPresetPaginatedList,
    description: 'Verifies standard pagination response shape',
    icon: '📋',
    rules: [
      AssertionRule(
        id: 'preset_pl_1',
        type: AssertionType.statusCode,
        description: 'Status is 200 OK',
        expectedValue: 200,
      ),
      AssertionRule(
        id: 'preset_pl_2',
        type: AssertionType.jsonFieldExists,
        description: 'Response contains data/results array',
        jsonPath: 'data',
      ),
      AssertionRule(
        id: 'preset_pl_3',
        type: AssertionType.jsonFieldExists,
        description: 'Response contains total count field',
        jsonPath: 'total',
      ),
    ],
  ),
];
