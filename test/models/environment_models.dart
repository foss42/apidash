import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart'
    show
        EnvironmentModel,
        EnvironmentVariableModel,
        EnvironmentVariableSuggestion;

/// Global environment model
const globalEnvironment = EnvironmentModel(
  id: kGlobalEnvironmentId,
  name: 'Global',
  values: [
    EnvironmentVariableModel(
      key: 'key1',
      value: 'value1',
      enabled: true,
    ),
    EnvironmentVariableModel(
      key: 'key2',
      value: 'value2',
      enabled: false,
    ),
  ],
);

/// Basic Environment model with 2 variables
const environmentModel1 = EnvironmentModel(
  id: 'environmentId',
  name: 'Development',
  values: [
    EnvironmentVariableModel(
      key: 'key1',
      value: 'value1',
      type: EnvironmentVariableType.variable,
      enabled: true,
    ),
    EnvironmentVariableModel(
      key: 'key2',
      value: 'value2',
      type: EnvironmentVariableType.variable,
      enabled: false,
    ),
  ],
);

/// Basic Environment model with 2 secrets
const environmentModel2 = EnvironmentModel(
  id: 'environmentId',
  name: 'Development',
  values: [
    EnvironmentVariableModel(
      key: 'key1',
      value: 'value1',
      type: EnvironmentVariableType.secret,
      enabled: true,
    ),
    EnvironmentVariableModel(
      key: 'key2',
      value: 'value2',
      type: EnvironmentVariableType.secret,
      enabled: false,
    ),
  ],
);

/// Basic Environment Variable
const environmentVariableModel1 = EnvironmentVariableModel(
  key: 'key1',
  value: 'value1',
  type: EnvironmentVariableType.variable,
  enabled: true,
);

/// Secret Environment Variable
const environmentVariableModel2 = EnvironmentVariableModel(
  key: 'key1',
  value: 'value1',
  type: EnvironmentVariableType.secret,
  enabled: true,
);

/// Basic Environment Variable Suggestion
const environmentVariableSuggestion1 = EnvironmentVariableSuggestion(
  environmentId: 'environmentId',
  variable: environmentVariableModel1,
);

/// Secret Environment Variable Suggestion
const environmentVariableSuggestion2 = EnvironmentVariableSuggestion(
  environmentId: 'environmentId',
  variable: environmentVariableModel2,
);

/// JSONs
const environmentModel1Json = {
  'id': 'environmentId',
  'name': 'Development',
  'values': [
    {
      'key': 'key1',
      'value': 'value1',
      'type': 'variable',
      'enabled': true,
    },
    {
      'key': 'key2',
      'value': 'value2',
      'type': 'variable',
      'enabled': false,
    },
  ],
};

const environmentModel2Json = {
  'id': 'environmentId',
  'name': 'Development',
  'values': [
    {
      'key': 'key',
      'value': 'value1',
      'type': 'secret',
      'enabled': true,
    },
    {
      'key': 'key2',
      'value': 'value2',
      'type': 'secret',
      'enabled': false,
    },
  ],
};

const environmentVariableModel1Json = {
  'key': 'key1',
  'value': 'value1',
  'type': 'variable',
  'enabled': true,
};

const environmentVariableModel2Json = {
  'key': 'key1',
  'value': 'value1',
  'type': 'secret',
  'enabled': true,
};
