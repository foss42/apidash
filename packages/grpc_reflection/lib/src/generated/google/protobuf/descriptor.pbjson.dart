// This is a generated file - do not edit.
//
// Generated from google/protobuf/descriptor.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use editionDescriptor instead')
const Edition$json = {
  '1': 'Edition',
  '2': [
    {'1': 'EDITION_UNKNOWN', '2': 0},
    {'1': 'EDITION_LEGACY', '2': 900},
    {'1': 'EDITION_PROTO2', '2': 998},
    {'1': 'EDITION_PROTO3', '2': 999},
    {'1': 'EDITION_2023', '2': 1000},
    {'1': 'EDITION_2024', '2': 1001},
    {'1': 'EDITION_UNSTABLE', '2': 9999},
    {'1': 'EDITION_1_TEST_ONLY', '2': 1},
    {'1': 'EDITION_2_TEST_ONLY', '2': 2},
    {'1': 'EDITION_99997_TEST_ONLY', '2': 99997},
    {'1': 'EDITION_99998_TEST_ONLY', '2': 99998},
    {'1': 'EDITION_99999_TEST_ONLY', '2': 99999},
    {'1': 'EDITION_MAX', '2': 2147483647},
  ],
};

/// Descriptor for `Edition`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List editionDescriptor = $convert.base64Decode(
    'CgdFZGl0aW9uEhMKD0VESVRJT05fVU5LTk9XThAAEhMKDkVESVRJT05fTEVHQUNZEIQHEhMKDk'
    'VESVRJT05fUFJPVE8yEOYHEhMKDkVESVRJT05fUFJPVE8zEOcHEhEKDEVESVRJT05fMjAyMxDo'
    'BxIRCgxFRElUSU9OXzIwMjQQ6QcSFQoQRURJVElPTl9VTlNUQUJMRRCPThIXChNFRElUSU9OXz'
    'FfVEVTVF9PTkxZEAESFwoTRURJVElPTl8yX1RFU1RfT05MWRACEh0KF0VESVRJT05fOTk5OTdf'
    'VEVTVF9PTkxZEJ2NBhIdChdFRElUSU9OXzk5OTk4X1RFU1RfT05MWRCejQYSHQoXRURJVElPTl'
    '85OTk5OV9URVNUX09OTFkQn40GEhMKC0VESVRJT05fTUFYEP////8H');

@$core.Deprecated('Use symbolVisibilityDescriptor instead')
const SymbolVisibility$json = {
  '1': 'SymbolVisibility',
  '2': [
    {'1': 'VISIBILITY_UNSET', '2': 0},
    {'1': 'VISIBILITY_LOCAL', '2': 1},
    {'1': 'VISIBILITY_EXPORT', '2': 2},
  ],
};

/// Descriptor for `SymbolVisibility`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List symbolVisibilityDescriptor = $convert.base64Decode(
    'ChBTeW1ib2xWaXNpYmlsaXR5EhQKEFZJU0lCSUxJVFlfVU5TRVQQABIUChBWSVNJQklMSVRZX0'
    'xPQ0FMEAESFQoRVklTSUJJTElUWV9FWFBPUlQQAg==');

@$core.Deprecated('Use fileDescriptorSetDescriptor instead')
const FileDescriptorSet$json = {
  '1': 'FileDescriptorSet',
  '2': [
    {
      '1': 'file',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.FileDescriptorProto',
      '10': 'file'
    },
  ],
  '5': [
    {'1': 536000000, '2': 536000001},
  ],
};

/// Descriptor for `FileDescriptorSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptorSetDescriptor = $convert.base64Decode(
    'ChFGaWxlRGVzY3JpcHRvclNldBI4CgRmaWxlGAEgAygLMiQuZ29vZ2xlLnByb3RvYnVmLkZpbG'
    'VEZXNjcmlwdG9yUHJvdG9SBGZpbGUqDAiA7Mr/ARCB7Mr/AQ==');

@$core.Deprecated('Use fileDescriptorProtoDescriptor instead')
const FileDescriptorProto$json = {
  '1': 'FileDescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'package', '3': 2, '4': 1, '5': 9, '10': 'package'},
    {'1': 'dependency', '3': 3, '4': 3, '5': 9, '10': 'dependency'},
    {
      '1': 'public_dependency',
      '3': 10,
      '4': 3,
      '5': 5,
      '10': 'publicDependency'
    },
    {'1': 'weak_dependency', '3': 11, '4': 3, '5': 5, '10': 'weakDependency'},
    {
      '1': 'option_dependency',
      '3': 15,
      '4': 3,
      '5': 9,
      '10': 'optionDependency'
    },
    {
      '1': 'message_type',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.DescriptorProto',
      '10': 'messageType'
    },
    {
      '1': 'enum_type',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.EnumDescriptorProto',
      '10': 'enumType'
    },
    {
      '1': 'service',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.ServiceDescriptorProto',
      '10': 'service'
    },
    {
      '1': 'extension',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.FieldDescriptorProto',
      '10': 'extension'
    },
    {
      '1': 'options',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FileOptions',
      '10': 'options'
    },
    {
      '1': 'source_code_info',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.SourceCodeInfo',
      '10': 'sourceCodeInfo'
    },
    {'1': 'syntax', '3': 12, '4': 1, '5': 9, '10': 'syntax'},
    {
      '1': 'edition',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'edition'
    },
  ],
};

/// Descriptor for `FileDescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptorProtoDescriptor = $convert.base64Decode(
    'ChNGaWxlRGVzY3JpcHRvclByb3RvEhIKBG5hbWUYASABKAlSBG5hbWUSGAoHcGFja2FnZRgCIA'
    'EoCVIHcGFja2FnZRIeCgpkZXBlbmRlbmN5GAMgAygJUgpkZXBlbmRlbmN5EisKEXB1YmxpY19k'
    'ZXBlbmRlbmN5GAogAygFUhBwdWJsaWNEZXBlbmRlbmN5EicKD3dlYWtfZGVwZW5kZW5jeRgLIA'
    'MoBVIOd2Vha0RlcGVuZGVuY3kSKwoRb3B0aW9uX2RlcGVuZGVuY3kYDyADKAlSEG9wdGlvbkRl'
    'cGVuZGVuY3kSQwoMbWVzc2FnZV90eXBlGAQgAygLMiAuZ29vZ2xlLnByb3RvYnVmLkRlc2NyaX'
    'B0b3JQcm90b1ILbWVzc2FnZVR5cGUSQQoJZW51bV90eXBlGAUgAygLMiQuZ29vZ2xlLnByb3Rv'
    'YnVmLkVudW1EZXNjcmlwdG9yUHJvdG9SCGVudW1UeXBlEkEKB3NlcnZpY2UYBiADKAsyJy5nb2'
    '9nbGUucHJvdG9idWYuU2VydmljZURlc2NyaXB0b3JQcm90b1IHc2VydmljZRJDCglleHRlbnNp'
    'b24YByADKAsyJS5nb29nbGUucHJvdG9idWYuRmllbGREZXNjcmlwdG9yUHJvdG9SCWV4dGVuc2'
    'lvbhI2CgdvcHRpb25zGAggASgLMhwuZ29vZ2xlLnByb3RvYnVmLkZpbGVPcHRpb25zUgdvcHRp'
    'b25zEkkKEHNvdXJjZV9jb2RlX2luZm8YCSABKAsyHy5nb29nbGUucHJvdG9idWYuU291cmNlQ2'
    '9kZUluZm9SDnNvdXJjZUNvZGVJbmZvEhYKBnN5bnRheBgMIAEoCVIGc3ludGF4EjIKB2VkaXRp'
    'b24YDiABKA4yGC5nb29nbGUucHJvdG9idWYuRWRpdGlvblIHZWRpdGlvbg==');

@$core.Deprecated('Use descriptorProtoDescriptor instead')
const DescriptorProto$json = {
  '1': 'DescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'field',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.FieldDescriptorProto',
      '10': 'field'
    },
    {
      '1': 'extension',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.FieldDescriptorProto',
      '10': 'extension'
    },
    {
      '1': 'nested_type',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.DescriptorProto',
      '10': 'nestedType'
    },
    {
      '1': 'enum_type',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.EnumDescriptorProto',
      '10': 'enumType'
    },
    {
      '1': 'extension_range',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.DescriptorProto.ExtensionRange',
      '10': 'extensionRange'
    },
    {
      '1': 'oneof_decl',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.OneofDescriptorProto',
      '10': 'oneofDecl'
    },
    {
      '1': 'options',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.MessageOptions',
      '10': 'options'
    },
    {
      '1': 'reserved_range',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.DescriptorProto.ReservedRange',
      '10': 'reservedRange'
    },
    {'1': 'reserved_name', '3': 10, '4': 3, '5': 9, '10': 'reservedName'},
    {
      '1': 'visibility',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.SymbolVisibility',
      '10': 'visibility'
    },
  ],
  '3': [
    DescriptorProto_ExtensionRange$json,
    DescriptorProto_ReservedRange$json
  ],
};

@$core.Deprecated('Use descriptorProtoDescriptor instead')
const DescriptorProto_ExtensionRange$json = {
  '1': 'ExtensionRange',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 5, '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 5, '10': 'end'},
    {
      '1': 'options',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.ExtensionRangeOptions',
      '10': 'options'
    },
  ],
};

@$core.Deprecated('Use descriptorProtoDescriptor instead')
const DescriptorProto_ReservedRange$json = {
  '1': 'ReservedRange',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 5, '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 5, '10': 'end'},
  ],
};

/// Descriptor for `DescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List descriptorProtoDescriptor = $convert.base64Decode(
    'Cg9EZXNjcmlwdG9yUHJvdG8SEgoEbmFtZRgBIAEoCVIEbmFtZRI7CgVmaWVsZBgCIAMoCzIlLm'
    'dvb2dsZS5wcm90b2J1Zi5GaWVsZERlc2NyaXB0b3JQcm90b1IFZmllbGQSQwoJZXh0ZW5zaW9u'
    'GAYgAygLMiUuZ29vZ2xlLnByb3RvYnVmLkZpZWxkRGVzY3JpcHRvclByb3RvUglleHRlbnNpb2'
    '4SQQoLbmVzdGVkX3R5cGUYAyADKAsyIC5nb29nbGUucHJvdG9idWYuRGVzY3JpcHRvclByb3Rv'
    'UgpuZXN0ZWRUeXBlEkEKCWVudW1fdHlwZRgEIAMoCzIkLmdvb2dsZS5wcm90b2J1Zi5FbnVtRG'
    'VzY3JpcHRvclByb3RvUghlbnVtVHlwZRJYCg9leHRlbnNpb25fcmFuZ2UYBSADKAsyLy5nb29n'
    'bGUucHJvdG9idWYuRGVzY3JpcHRvclByb3RvLkV4dGVuc2lvblJhbmdlUg5leHRlbnNpb25SYW'
    '5nZRJECgpvbmVvZl9kZWNsGAggAygLMiUuZ29vZ2xlLnByb3RvYnVmLk9uZW9mRGVzY3JpcHRv'
    'clByb3RvUglvbmVvZkRlY2wSOQoHb3B0aW9ucxgHIAEoCzIfLmdvb2dsZS5wcm90b2J1Zi5NZX'
    'NzYWdlT3B0aW9uc1IHb3B0aW9ucxJVCg5yZXNlcnZlZF9yYW5nZRgJIAMoCzIuLmdvb2dsZS5w'
    'cm90b2J1Zi5EZXNjcmlwdG9yUHJvdG8uUmVzZXJ2ZWRSYW5nZVINcmVzZXJ2ZWRSYW5nZRIjCg'
    '1yZXNlcnZlZF9uYW1lGAogAygJUgxyZXNlcnZlZE5hbWUSQQoKdmlzaWJpbGl0eRgLIAEoDjIh'
    'Lmdvb2dsZS5wcm90b2J1Zi5TeW1ib2xWaXNpYmlsaXR5Ugp2aXNpYmlsaXR5GnoKDkV4dGVuc2'
    'lvblJhbmdlEhQKBXN0YXJ0GAEgASgFUgVzdGFydBIQCgNlbmQYAiABKAVSA2VuZBJACgdvcHRp'
    'b25zGAMgASgLMiYuZ29vZ2xlLnByb3RvYnVmLkV4dGVuc2lvblJhbmdlT3B0aW9uc1IHb3B0aW'
    '9ucxo3Cg1SZXNlcnZlZFJhbmdlEhQKBXN0YXJ0GAEgASgFUgVzdGFydBIQCgNlbmQYAiABKAVS'
    'A2VuZA==');

@$core.Deprecated('Use extensionRangeOptionsDescriptor instead')
const ExtensionRangeOptions$json = {
  '1': 'ExtensionRangeOptions',
  '2': [
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
    {
      '1': 'declaration',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.ExtensionRangeOptions.Declaration',
      '8': {'17': 2},
      '10': 'declaration',
    },
    {
      '1': 'features',
      '3': 50,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'verification',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.ExtensionRangeOptions.VerificationState',
      '7': 'UNVERIFIED',
      '8': {'17': 2},
      '10': 'verification',
    },
  ],
  '3': [ExtensionRangeOptions_Declaration$json],
  '4': [ExtensionRangeOptions_VerificationState$json],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
};

@$core.Deprecated('Use extensionRangeOptionsDescriptor instead')
const ExtensionRangeOptions_Declaration$json = {
  '1': 'Declaration',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 5, '10': 'number'},
    {'1': 'full_name', '3': 2, '4': 1, '5': 9, '10': 'fullName'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'reserved', '3': 5, '4': 1, '5': 8, '10': 'reserved'},
    {'1': 'repeated', '3': 6, '4': 1, '5': 8, '10': 'repeated'},
  ],
  '9': [
    {'1': 4, '2': 5},
  ],
};

@$core.Deprecated('Use extensionRangeOptionsDescriptor instead')
const ExtensionRangeOptions_VerificationState$json = {
  '1': 'VerificationState',
  '2': [
    {'1': 'DECLARATION', '2': 0},
    {'1': 'UNVERIFIED', '2': 1},
  ],
};

/// Descriptor for `ExtensionRangeOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extensionRangeOptionsDescriptor = $convert.base64Decode(
    'ChVFeHRlbnNpb25SYW5nZU9wdGlvbnMSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygLMi'
    'QuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRp'
    'b24SWQoLZGVjbGFyYXRpb24YAiADKAsyMi5nb29nbGUucHJvdG9idWYuRXh0ZW5zaW9uUmFuZ2'
    'VPcHRpb25zLkRlY2xhcmF0aW9uQgOIAQJSC2RlY2xhcmF0aW9uEjcKCGZlYXR1cmVzGDIgASgL'
    'MhsuZ29vZ2xlLnByb3RvYnVmLkZlYXR1cmVTZXRSCGZlYXR1cmVzEm0KDHZlcmlmaWNhdGlvbh'
    'gDIAEoDjI4Lmdvb2dsZS5wcm90b2J1Zi5FeHRlbnNpb25SYW5nZU9wdGlvbnMuVmVyaWZpY2F0'
    'aW9uU3RhdGU6ClVOVkVSSUZJRURCA4gBAlIMdmVyaWZpY2F0aW9uGpQBCgtEZWNsYXJhdGlvbh'
    'IWCgZudW1iZXIYASABKAVSBm51bWJlchIbCglmdWxsX25hbWUYAiABKAlSCGZ1bGxOYW1lEhIK'
    'BHR5cGUYAyABKAlSBHR5cGUSGgoIcmVzZXJ2ZWQYBSABKAhSCHJlc2VydmVkEhoKCHJlcGVhdG'
    'VkGAYgASgIUghyZXBlYXRlZEoECAQQBSI0ChFWZXJpZmljYXRpb25TdGF0ZRIPCgtERUNMQVJB'
    'VElPThAAEg4KClVOVkVSSUZJRUQQASoJCOgHEICAgIAC');

@$core.Deprecated('Use fieldDescriptorProtoDescriptor instead')
const FieldDescriptorProto$json = {
  '1': 'FieldDescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'number', '3': 3, '4': 1, '5': 5, '10': 'number'},
    {
      '1': 'label',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FieldDescriptorProto.Label',
      '10': 'label'
    },
    {
      '1': 'type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FieldDescriptorProto.Type',
      '10': 'type'
    },
    {'1': 'type_name', '3': 6, '4': 1, '5': 9, '10': 'typeName'},
    {'1': 'extendee', '3': 2, '4': 1, '5': 9, '10': 'extendee'},
    {'1': 'default_value', '3': 7, '4': 1, '5': 9, '10': 'defaultValue'},
    {'1': 'oneof_index', '3': 9, '4': 1, '5': 5, '10': 'oneofIndex'},
    {'1': 'json_name', '3': 10, '4': 1, '5': 9, '10': 'jsonName'},
    {
      '1': 'options',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldOptions',
      '10': 'options'
    },
    {'1': 'proto3_optional', '3': 17, '4': 1, '5': 8, '10': 'proto3Optional'},
  ],
  '4': [FieldDescriptorProto_Type$json, FieldDescriptorProto_Label$json],
};

@$core.Deprecated('Use fieldDescriptorProtoDescriptor instead')
const FieldDescriptorProto_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'TYPE_DOUBLE', '2': 1},
    {'1': 'TYPE_FLOAT', '2': 2},
    {'1': 'TYPE_INT64', '2': 3},
    {'1': 'TYPE_UINT64', '2': 4},
    {'1': 'TYPE_INT32', '2': 5},
    {'1': 'TYPE_FIXED64', '2': 6},
    {'1': 'TYPE_FIXED32', '2': 7},
    {'1': 'TYPE_BOOL', '2': 8},
    {'1': 'TYPE_STRING', '2': 9},
    {'1': 'TYPE_GROUP', '2': 10},
    {'1': 'TYPE_MESSAGE', '2': 11},
    {'1': 'TYPE_BYTES', '2': 12},
    {'1': 'TYPE_UINT32', '2': 13},
    {'1': 'TYPE_ENUM', '2': 14},
    {'1': 'TYPE_SFIXED32', '2': 15},
    {'1': 'TYPE_SFIXED64', '2': 16},
    {'1': 'TYPE_SINT32', '2': 17},
    {'1': 'TYPE_SINT64', '2': 18},
  ],
};

@$core.Deprecated('Use fieldDescriptorProtoDescriptor instead')
const FieldDescriptorProto_Label$json = {
  '1': 'Label',
  '2': [
    {'1': 'LABEL_OPTIONAL', '2': 1},
    {'1': 'LABEL_REPEATED', '2': 3},
    {'1': 'LABEL_REQUIRED', '2': 2},
  ],
};

/// Descriptor for `FieldDescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldDescriptorProtoDescriptor = $convert.base64Decode(
    'ChRGaWVsZERlc2NyaXB0b3JQcm90bxISCgRuYW1lGAEgASgJUgRuYW1lEhYKBm51bWJlchgDIA'
    'EoBVIGbnVtYmVyEkEKBWxhYmVsGAQgASgOMisuZ29vZ2xlLnByb3RvYnVmLkZpZWxkRGVzY3Jp'
    'cHRvclByb3RvLkxhYmVsUgVsYWJlbBI+CgR0eXBlGAUgASgOMiouZ29vZ2xlLnByb3RvYnVmLk'
    'ZpZWxkRGVzY3JpcHRvclByb3RvLlR5cGVSBHR5cGUSGwoJdHlwZV9uYW1lGAYgASgJUgh0eXBl'
    'TmFtZRIaCghleHRlbmRlZRgCIAEoCVIIZXh0ZW5kZWUSIwoNZGVmYXVsdF92YWx1ZRgHIAEoCV'
    'IMZGVmYXVsdFZhbHVlEh8KC29uZW9mX2luZGV4GAkgASgFUgpvbmVvZkluZGV4EhsKCWpzb25f'
    'bmFtZRgKIAEoCVIIanNvbk5hbWUSNwoHb3B0aW9ucxgIIAEoCzIdLmdvb2dsZS5wcm90b2J1Zi'
    '5GaWVsZE9wdGlvbnNSB29wdGlvbnMSJwoPcHJvdG8zX29wdGlvbmFsGBEgASgIUg5wcm90bzNP'
    'cHRpb25hbCK2AgoEVHlwZRIPCgtUWVBFX0RPVUJMRRABEg4KClRZUEVfRkxPQVQQAhIOCgpUWV'
    'BFX0lOVDY0EAMSDwoLVFlQRV9VSU5UNjQQBBIOCgpUWVBFX0lOVDMyEAUSEAoMVFlQRV9GSVhF'
    'RDY0EAYSEAoMVFlQRV9GSVhFRDMyEAcSDQoJVFlQRV9CT09MEAgSDwoLVFlQRV9TVFJJTkcQCR'
    'IOCgpUWVBFX0dST1VQEAoSEAoMVFlQRV9NRVNTQUdFEAsSDgoKVFlQRV9CWVRFUxAMEg8KC1RZ'
    'UEVfVUlOVDMyEA0SDQoJVFlQRV9FTlVNEA4SEQoNVFlQRV9TRklYRUQzMhAPEhEKDVRZUEVfU0'
    'ZJWEVENjQQEBIPCgtUWVBFX1NJTlQzMhAREg8KC1RZUEVfU0lOVDY0EBIiQwoFTGFiZWwSEgoO'
    'TEFCRUxfT1BUSU9OQUwQARISCg5MQUJFTF9SRVBFQVRFRBADEhIKDkxBQkVMX1JFUVVJUkVEEA'
    'I=');

@$core.Deprecated('Use oneofDescriptorProtoDescriptor instead')
const OneofDescriptorProto$json = {
  '1': 'OneofDescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'options',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.OneofOptions',
      '10': 'options'
    },
  ],
};

/// Descriptor for `OneofDescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oneofDescriptorProtoDescriptor = $convert.base64Decode(
    'ChRPbmVvZkRlc2NyaXB0b3JQcm90bxISCgRuYW1lGAEgASgJUgRuYW1lEjcKB29wdGlvbnMYAi'
    'ABKAsyHS5nb29nbGUucHJvdG9idWYuT25lb2ZPcHRpb25zUgdvcHRpb25z');

@$core.Deprecated('Use enumDescriptorProtoDescriptor instead')
const EnumDescriptorProto$json = {
  '1': 'EnumDescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'value',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.EnumValueDescriptorProto',
      '10': 'value'
    },
    {
      '1': 'options',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.EnumOptions',
      '10': 'options'
    },
    {
      '1': 'reserved_range',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.EnumDescriptorProto.EnumReservedRange',
      '10': 'reservedRange'
    },
    {'1': 'reserved_name', '3': 5, '4': 3, '5': 9, '10': 'reservedName'},
    {
      '1': 'visibility',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.SymbolVisibility',
      '10': 'visibility'
    },
  ],
  '3': [EnumDescriptorProto_EnumReservedRange$json],
};

@$core.Deprecated('Use enumDescriptorProtoDescriptor instead')
const EnumDescriptorProto_EnumReservedRange$json = {
  '1': 'EnumReservedRange',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 5, '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 5, '10': 'end'},
  ],
};

/// Descriptor for `EnumDescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enumDescriptorProtoDescriptor = $convert.base64Decode(
    'ChNFbnVtRGVzY3JpcHRvclByb3RvEhIKBG5hbWUYASABKAlSBG5hbWUSPwoFdmFsdWUYAiADKA'
    'syKS5nb29nbGUucHJvdG9idWYuRW51bVZhbHVlRGVzY3JpcHRvclByb3RvUgV2YWx1ZRI2Cgdv'
    'cHRpb25zGAMgASgLMhwuZ29vZ2xlLnByb3RvYnVmLkVudW1PcHRpb25zUgdvcHRpb25zEl0KDn'
    'Jlc2VydmVkX3JhbmdlGAQgAygLMjYuZ29vZ2xlLnByb3RvYnVmLkVudW1EZXNjcmlwdG9yUHJv'
    'dG8uRW51bVJlc2VydmVkUmFuZ2VSDXJlc2VydmVkUmFuZ2USIwoNcmVzZXJ2ZWRfbmFtZRgFIA'
    'MoCVIMcmVzZXJ2ZWROYW1lEkEKCnZpc2liaWxpdHkYBiABKA4yIS5nb29nbGUucHJvdG9idWYu'
    'U3ltYm9sVmlzaWJpbGl0eVIKdmlzaWJpbGl0eRo7ChFFbnVtUmVzZXJ2ZWRSYW5nZRIUCgVzdG'
    'FydBgBIAEoBVIFc3RhcnQSEAoDZW5kGAIgASgFUgNlbmQ=');

@$core.Deprecated('Use enumValueDescriptorProtoDescriptor instead')
const EnumValueDescriptorProto$json = {
  '1': 'EnumValueDescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'number', '3': 2, '4': 1, '5': 5, '10': 'number'},
    {
      '1': 'options',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.EnumValueOptions',
      '10': 'options'
    },
  ],
};

/// Descriptor for `EnumValueDescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enumValueDescriptorProtoDescriptor = $convert.base64Decode(
    'ChhFbnVtVmFsdWVEZXNjcmlwdG9yUHJvdG8SEgoEbmFtZRgBIAEoCVIEbmFtZRIWCgZudW1iZX'
    'IYAiABKAVSBm51bWJlchI7CgdvcHRpb25zGAMgASgLMiEuZ29vZ2xlLnByb3RvYnVmLkVudW1W'
    'YWx1ZU9wdGlvbnNSB29wdGlvbnM=');

@$core.Deprecated('Use serviceDescriptorProtoDescriptor instead')
const ServiceDescriptorProto$json = {
  '1': 'ServiceDescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'method',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.MethodDescriptorProto',
      '10': 'method'
    },
    {
      '1': 'options',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.ServiceOptions',
      '10': 'options'
    },
  ],
  '9': [
    {'1': 4, '2': 5},
  ],
  '10': ['stream'],
};

/// Descriptor for `ServiceDescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceDescriptorProtoDescriptor = $convert.base64Decode(
    'ChZTZXJ2aWNlRGVzY3JpcHRvclByb3RvEhIKBG5hbWUYASABKAlSBG5hbWUSPgoGbWV0aG9kGA'
    'IgAygLMiYuZ29vZ2xlLnByb3RvYnVmLk1ldGhvZERlc2NyaXB0b3JQcm90b1IGbWV0aG9kEjkK'
    'B29wdGlvbnMYAyABKAsyHy5nb29nbGUucHJvdG9idWYuU2VydmljZU9wdGlvbnNSB29wdGlvbn'
    'NKBAgEEAVSBnN0cmVhbQ==');

@$core.Deprecated('Use methodDescriptorProtoDescriptor instead')
const MethodDescriptorProto$json = {
  '1': 'MethodDescriptorProto',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'input_type', '3': 2, '4': 1, '5': 9, '10': 'inputType'},
    {'1': 'output_type', '3': 3, '4': 1, '5': 9, '10': 'outputType'},
    {
      '1': 'options',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.MethodOptions',
      '10': 'options'
    },
    {
      '1': 'client_streaming',
      '3': 5,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'clientStreaming'
    },
    {
      '1': 'server_streaming',
      '3': 6,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'serverStreaming'
    },
  ],
};

/// Descriptor for `MethodDescriptorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List methodDescriptorProtoDescriptor = $convert.base64Decode(
    'ChVNZXRob2REZXNjcmlwdG9yUHJvdG8SEgoEbmFtZRgBIAEoCVIEbmFtZRIdCgppbnB1dF90eX'
    'BlGAIgASgJUglpbnB1dFR5cGUSHwoLb3V0cHV0X3R5cGUYAyABKAlSCm91dHB1dFR5cGUSOAoH'
    'b3B0aW9ucxgEIAEoCzIeLmdvb2dsZS5wcm90b2J1Zi5NZXRob2RPcHRpb25zUgdvcHRpb25zEj'
    'AKEGNsaWVudF9zdHJlYW1pbmcYBSABKAg6BWZhbHNlUg9jbGllbnRTdHJlYW1pbmcSMAoQc2Vy'
    'dmVyX3N0cmVhbWluZxgGIAEoCDoFZmFsc2VSD3NlcnZlclN0cmVhbWluZw==');

@$core.Deprecated('Use fileOptionsDescriptor instead')
const FileOptions$json = {
  '1': 'FileOptions',
  '2': [
    {'1': 'java_package', '3': 1, '4': 1, '5': 9, '10': 'javaPackage'},
    {
      '1': 'java_outer_classname',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'javaOuterClassname'
    },
    {
      '1': 'java_multiple_files',
      '3': 10,
      '4': 1,
      '5': 8,
      '7': 'false',
      '8': {
        '22': {'1': 998, '4': 1001},
      },
      '10': 'javaMultipleFiles',
    },
    {
      '1': 'java_generate_equals_and_hash',
      '3': 20,
      '4': 1,
      '5': 8,
      '8': {'3': true},
      '10': 'javaGenerateEqualsAndHash',
    },
    {
      '1': 'java_string_check_utf8',
      '3': 27,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'javaStringCheckUtf8'
    },
    {
      '1': 'optimize_for',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FileOptions.OptimizeMode',
      '7': 'SPEED',
      '10': 'optimizeFor'
    },
    {'1': 'go_package', '3': 11, '4': 1, '5': 9, '10': 'goPackage'},
    {
      '1': 'cc_generic_services',
      '3': 16,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'ccGenericServices'
    },
    {
      '1': 'java_generic_services',
      '3': 17,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'javaGenericServices'
    },
    {
      '1': 'py_generic_services',
      '3': 18,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'pyGenericServices'
    },
    {
      '1': 'deprecated',
      '3': 23,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'deprecated'
    },
    {
      '1': 'cc_enable_arenas',
      '3': 31,
      '4': 1,
      '5': 8,
      '7': 'true',
      '10': 'ccEnableArenas'
    },
    {
      '1': 'objc_class_prefix',
      '3': 36,
      '4': 1,
      '5': 9,
      '10': 'objcClassPrefix'
    },
    {'1': 'csharp_namespace', '3': 37, '4': 1, '5': 9, '10': 'csharpNamespace'},
    {'1': 'swift_prefix', '3': 39, '4': 1, '5': 9, '10': 'swiftPrefix'},
    {'1': 'php_class_prefix', '3': 40, '4': 1, '5': 9, '10': 'phpClassPrefix'},
    {'1': 'php_namespace', '3': 41, '4': 1, '5': 9, '10': 'phpNamespace'},
    {
      '1': 'php_metadata_namespace',
      '3': 44,
      '4': 1,
      '5': 9,
      '10': 'phpMetadataNamespace'
    },
    {'1': 'ruby_package', '3': 45, '4': 1, '5': 9, '10': 'rubyPackage'},
    {
      '1': 'features',
      '3': 50,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '4': [FileOptions_OptimizeMode$json],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
  '9': [
    {'1': 42, '2': 43},
    {'1': 38, '2': 39},
  ],
  '10': ['php_generic_services'],
};

@$core.Deprecated('Use fileOptionsDescriptor instead')
const FileOptions_OptimizeMode$json = {
  '1': 'OptimizeMode',
  '2': [
    {'1': 'SPEED', '2': 1},
    {'1': 'CODE_SIZE', '2': 2},
    {'1': 'LITE_RUNTIME', '2': 3},
  ],
};

/// Descriptor for `FileOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileOptionsDescriptor = $convert.base64Decode(
    'CgtGaWxlT3B0aW9ucxIhCgxqYXZhX3BhY2thZ2UYASABKAlSC2phdmFQYWNrYWdlEjAKFGphdm'
    'Ffb3V0ZXJfY2xhc3NuYW1lGAggASgJUhJqYXZhT3V0ZXJDbGFzc25hbWUS+QEKE2phdmFfbXVs'
    'dGlwbGVfZmlsZXMYCiABKAg6BWZhbHNlQsEBsgG9AQjmByDpByq0AVRoaXMgYmVoYXZpb3IgaX'
    'MgZW5hYmxlZCBieSBkZWZhdWx0IGluIGVkaXRpb25zIDIwMjQgYW5kIGFib3ZlLiBUbyBkaXNh'
    'YmxlIGl0LCB5b3UgY2FuIHNldCBgZmVhdHVyZXMuKHBiLmphdmEpLm5lc3RfaW5fZmlsZV9jbG'
    'FzcyA9IFlFU2Agb24gaW5kaXZpZHVhbCBtZXNzYWdlcywgZW51bXMsIG9yIHNlcnZpY2VzLlIR'
    'amF2YU11bHRpcGxlRmlsZXMSRAodamF2YV9nZW5lcmF0ZV9lcXVhbHNfYW5kX2hhc2gYFCABKA'
    'hCAhgBUhlqYXZhR2VuZXJhdGVFcXVhbHNBbmRIYXNoEjoKFmphdmFfc3RyaW5nX2NoZWNrX3V0'
    'ZjgYGyABKAg6BWZhbHNlUhNqYXZhU3RyaW5nQ2hlY2tVdGY4ElMKDG9wdGltaXplX2ZvchgJIA'
    'EoDjIpLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9ucy5PcHRpbWl6ZU1vZGU6BVNQRUVEUgtv'
    'cHRpbWl6ZUZvchIdCgpnb19wYWNrYWdlGAsgASgJUglnb1BhY2thZ2USNQoTY2NfZ2VuZXJpY1'
    '9zZXJ2aWNlcxgQIAEoCDoFZmFsc2VSEWNjR2VuZXJpY1NlcnZpY2VzEjkKFWphdmFfZ2VuZXJp'
    'Y19zZXJ2aWNlcxgRIAEoCDoFZmFsc2VSE2phdmFHZW5lcmljU2VydmljZXMSNQoTcHlfZ2VuZX'
    'JpY19zZXJ2aWNlcxgSIAEoCDoFZmFsc2VSEXB5R2VuZXJpY1NlcnZpY2VzEiUKCmRlcHJlY2F0'
    'ZWQYFyABKAg6BWZhbHNlUgpkZXByZWNhdGVkEi4KEGNjX2VuYWJsZV9hcmVuYXMYHyABKAg6BH'
    'RydWVSDmNjRW5hYmxlQXJlbmFzEioKEW9iamNfY2xhc3NfcHJlZml4GCQgASgJUg9vYmpjQ2xh'
    'c3NQcmVmaXgSKQoQY3NoYXJwX25hbWVzcGFjZRglIAEoCVIPY3NoYXJwTmFtZXNwYWNlEiEKDH'
    'N3aWZ0X3ByZWZpeBgnIAEoCVILc3dpZnRQcmVmaXgSKAoQcGhwX2NsYXNzX3ByZWZpeBgoIAEo'
    'CVIOcGhwQ2xhc3NQcmVmaXgSIwoNcGhwX25hbWVzcGFjZRgpIAEoCVIMcGhwTmFtZXNwYWNlEj'
    'QKFnBocF9tZXRhZGF0YV9uYW1lc3BhY2UYLCABKAlSFHBocE1ldGFkYXRhTmFtZXNwYWNlEiEK'
    'DHJ1YnlfcGFja2FnZRgtIAEoCVILcnVieVBhY2thZ2USNwoIZmVhdHVyZXMYMiABKAsyGy5nb2'
    '9nbGUucHJvdG9idWYuRmVhdHVyZVNldFIIZmVhdHVyZXMSWAoUdW5pbnRlcnByZXRlZF9vcHRp'
    'b24Y5wcgAygLMiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZX'
    'JwcmV0ZWRPcHRpb24iOgoMT3B0aW1pemVNb2RlEgkKBVNQRUVEEAESDQoJQ09ERV9TSVpFEAIS'
    'EAoMTElURV9SVU5USU1FEAMqCQjoBxCAgICAAkoECCoQK0oECCYQJ1IUcGhwX2dlbmVyaWNfc2'
    'VydmljZXM=');

@$core.Deprecated('Use messageOptionsDescriptor instead')
const MessageOptions$json = {
  '1': 'MessageOptions',
  '2': [
    {
      '1': 'message_set_wire_format',
      '3': 1,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'messageSetWireFormat'
    },
    {
      '1': 'no_standard_descriptor_accessor',
      '3': 2,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'noStandardDescriptorAccessor'
    },
    {
      '1': 'deprecated',
      '3': 3,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'deprecated'
    },
    {'1': 'map_entry', '3': 7, '4': 1, '5': 8, '10': 'mapEntry'},
    {
      '1': 'deprecated_legacy_json_field_conflicts',
      '3': 11,
      '4': 1,
      '5': 8,
      '8': {'3': true},
      '10': 'deprecatedLegacyJsonFieldConflicts',
    },
    {
      '1': 'features',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
  '9': [
    {'1': 4, '2': 5},
    {'1': 5, '2': 6},
    {'1': 6, '2': 7},
    {'1': 8, '2': 9},
    {'1': 9, '2': 10},
  ],
};

/// Descriptor for `MessageOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageOptionsDescriptor = $convert.base64Decode(
    'Cg5NZXNzYWdlT3B0aW9ucxI8ChdtZXNzYWdlX3NldF93aXJlX2Zvcm1hdBgBIAEoCDoFZmFsc2'
    'VSFG1lc3NhZ2VTZXRXaXJlRm9ybWF0EkwKH25vX3N0YW5kYXJkX2Rlc2NyaXB0b3JfYWNjZXNz'
    'b3IYAiABKAg6BWZhbHNlUhxub1N0YW5kYXJkRGVzY3JpcHRvckFjY2Vzc29yEiUKCmRlcHJlY2'
    'F0ZWQYAyABKAg6BWZhbHNlUgpkZXByZWNhdGVkEhsKCW1hcF9lbnRyeRgHIAEoCFIIbWFwRW50'
    'cnkSVgomZGVwcmVjYXRlZF9sZWdhY3lfanNvbl9maWVsZF9jb25mbGljdHMYCyABKAhCAhgBUi'
    'JkZXByZWNhdGVkTGVnYWN5SnNvbkZpZWxkQ29uZmxpY3RzEjcKCGZlYXR1cmVzGAwgASgLMhsu'
    'Z29vZ2xlLnByb3RvYnVmLkZlYXR1cmVTZXRSCGZlYXR1cmVzElgKFHVuaW50ZXJwcmV0ZWRfb3'
    'B0aW9uGOcHIAMoCzIkLmdvb2dsZS5wcm90b2J1Zi5VbmludGVycHJldGVkT3B0aW9uUhN1bmlu'
    'dGVycHJldGVkT3B0aW9uKgkI6AcQgICAgAJKBAgEEAVKBAgFEAZKBAgGEAdKBAgIEAlKBAgJEA'
    'o=');

@$core.Deprecated('Use fieldOptionsDescriptor instead')
const FieldOptions$json = {
  '1': 'FieldOptions',
  '2': [
    {
      '1': 'ctype',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FieldOptions.CType',
      '7': 'STRING',
      '10': 'ctype'
    },
    {'1': 'packed', '3': 2, '4': 1, '5': 8, '10': 'packed'},
    {
      '1': 'jstype',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FieldOptions.JSType',
      '7': 'JS_NORMAL',
      '10': 'jstype'
    },
    {'1': 'lazy', '3': 5, '4': 1, '5': 8, '7': 'false', '10': 'lazy'},
    {
      '1': 'unverified_lazy',
      '3': 15,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'unverifiedLazy'
    },
    {
      '1': 'deprecated',
      '3': 3,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'deprecated'
    },
    {
      '1': 'weak',
      '3': 10,
      '4': 1,
      '5': 8,
      '7': 'false',
      '8': {'3': true},
      '10': 'weak',
    },
    {
      '1': 'debug_redact',
      '3': 16,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'debugRedact'
    },
    {
      '1': 'retention',
      '3': 17,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FieldOptions.OptionRetention',
      '10': 'retention'
    },
    {
      '1': 'targets',
      '3': 19,
      '4': 3,
      '5': 14,
      '6': '.google.protobuf.FieldOptions.OptionTargetType',
      '10': 'targets'
    },
    {
      '1': 'edition_defaults',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.FieldOptions.EditionDefault',
      '10': 'editionDefaults'
    },
    {
      '1': 'features',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'feature_support',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldOptions.FeatureSupport',
      '10': 'featureSupport'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '3': [FieldOptions_EditionDefault$json, FieldOptions_FeatureSupport$json],
  '4': [
    FieldOptions_CType$json,
    FieldOptions_JSType$json,
    FieldOptions_OptionRetention$json,
    FieldOptions_OptionTargetType$json
  ],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
  '9': [
    {'1': 4, '2': 5},
    {'1': 18, '2': 19},
  ],
};

@$core.Deprecated('Use fieldOptionsDescriptor instead')
const FieldOptions_EditionDefault$json = {
  '1': 'EditionDefault',
  '2': [
    {
      '1': 'edition',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'edition'
    },
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

@$core.Deprecated('Use fieldOptionsDescriptor instead')
const FieldOptions_FeatureSupport$json = {
  '1': 'FeatureSupport',
  '2': [
    {
      '1': 'edition_introduced',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'editionIntroduced'
    },
    {
      '1': 'edition_deprecated',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'editionDeprecated'
    },
    {
      '1': 'deprecation_warning',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'deprecationWarning'
    },
    {
      '1': 'edition_removed',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'editionRemoved'
    },
    {'1': 'removal_error', '3': 5, '4': 1, '5': 9, '10': 'removalError'},
  ],
};

@$core.Deprecated('Use fieldOptionsDescriptor instead')
const FieldOptions_CType$json = {
  '1': 'CType',
  '2': [
    {'1': 'STRING', '2': 0},
    {'1': 'CORD', '2': 1},
    {'1': 'STRING_PIECE', '2': 2},
  ],
};

@$core.Deprecated('Use fieldOptionsDescriptor instead')
const FieldOptions_JSType$json = {
  '1': 'JSType',
  '2': [
    {'1': 'JS_NORMAL', '2': 0},
    {'1': 'JS_STRING', '2': 1},
    {'1': 'JS_NUMBER', '2': 2},
  ],
};

@$core.Deprecated('Use fieldOptionsDescriptor instead')
const FieldOptions_OptionRetention$json = {
  '1': 'OptionRetention',
  '2': [
    {'1': 'RETENTION_UNKNOWN', '2': 0},
    {'1': 'RETENTION_RUNTIME', '2': 1},
    {'1': 'RETENTION_SOURCE', '2': 2},
  ],
};

@$core.Deprecated('Use fieldOptionsDescriptor instead')
const FieldOptions_OptionTargetType$json = {
  '1': 'OptionTargetType',
  '2': [
    {'1': 'TARGET_TYPE_UNKNOWN', '2': 0},
    {'1': 'TARGET_TYPE_FILE', '2': 1},
    {'1': 'TARGET_TYPE_EXTENSION_RANGE', '2': 2},
    {'1': 'TARGET_TYPE_MESSAGE', '2': 3},
    {'1': 'TARGET_TYPE_FIELD', '2': 4},
    {'1': 'TARGET_TYPE_ONEOF', '2': 5},
    {'1': 'TARGET_TYPE_ENUM', '2': 6},
    {'1': 'TARGET_TYPE_ENUM_ENTRY', '2': 7},
    {'1': 'TARGET_TYPE_SERVICE', '2': 8},
    {'1': 'TARGET_TYPE_METHOD', '2': 9},
  ],
};

/// Descriptor for `FieldOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldOptionsDescriptor = $convert.base64Decode(
    'CgxGaWVsZE9wdGlvbnMSQQoFY3R5cGUYASABKA4yIy5nb29nbGUucHJvdG9idWYuRmllbGRPcH'
    'Rpb25zLkNUeXBlOgZTVFJJTkdSBWN0eXBlEhYKBnBhY2tlZBgCIAEoCFIGcGFja2VkEkcKBmpz'
    'dHlwZRgGIAEoDjIkLmdvb2dsZS5wcm90b2J1Zi5GaWVsZE9wdGlvbnMuSlNUeXBlOglKU19OT1'
    'JNQUxSBmpzdHlwZRIZCgRsYXp5GAUgASgIOgVmYWxzZVIEbGF6eRIuCg91bnZlcmlmaWVkX2xh'
    'enkYDyABKAg6BWZhbHNlUg51bnZlcmlmaWVkTGF6eRIlCgpkZXByZWNhdGVkGAMgASgIOgVmYW'
    'xzZVIKZGVwcmVjYXRlZBIdCgR3ZWFrGAogASgIOgVmYWxzZUICGAFSBHdlYWsSKAoMZGVidWdf'
    'cmVkYWN0GBAgASgIOgVmYWxzZVILZGVidWdSZWRhY3QSSwoJcmV0ZW50aW9uGBEgASgOMi0uZ2'
    '9vZ2xlLnByb3RvYnVmLkZpZWxkT3B0aW9ucy5PcHRpb25SZXRlbnRpb25SCXJldGVudGlvbhJI'
    'Cgd0YXJnZXRzGBMgAygOMi4uZ29vZ2xlLnByb3RvYnVmLkZpZWxkT3B0aW9ucy5PcHRpb25UYX'
    'JnZXRUeXBlUgd0YXJnZXRzElcKEGVkaXRpb25fZGVmYXVsdHMYFCADKAsyLC5nb29nbGUucHJv'
    'dG9idWYuRmllbGRPcHRpb25zLkVkaXRpb25EZWZhdWx0Ug9lZGl0aW9uRGVmYXVsdHMSNwoIZm'
    'VhdHVyZXMYFSABKAsyGy5nb29nbGUucHJvdG9idWYuRmVhdHVyZVNldFIIZmVhdHVyZXMSVQoP'
    'ZmVhdHVyZV9zdXBwb3J0GBYgASgLMiwuZ29vZ2xlLnByb3RvYnVmLkZpZWxkT3B0aW9ucy5GZW'
    'F0dXJlU3VwcG9ydFIOZmVhdHVyZVN1cHBvcnQSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcg'
    'AygLMiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZW'
    'RPcHRpb24aWgoORWRpdGlvbkRlZmF1bHQSMgoHZWRpdGlvbhgDIAEoDjIYLmdvb2dsZS5wcm90'
    'b2J1Zi5FZGl0aW9uUgdlZGl0aW9uEhQKBXZhbHVlGAIgASgJUgV2YWx1ZRq7AgoORmVhdHVyZV'
    'N1cHBvcnQSRwoSZWRpdGlvbl9pbnRyb2R1Y2VkGAEgASgOMhguZ29vZ2xlLnByb3RvYnVmLkVk'
    'aXRpb25SEWVkaXRpb25JbnRyb2R1Y2VkEkcKEmVkaXRpb25fZGVwcmVjYXRlZBgCIAEoDjIYLm'
    'dvb2dsZS5wcm90b2J1Zi5FZGl0aW9uUhFlZGl0aW9uRGVwcmVjYXRlZBIvChNkZXByZWNhdGlv'
    'bl93YXJuaW5nGAMgASgJUhJkZXByZWNhdGlvbldhcm5pbmcSQQoPZWRpdGlvbl9yZW1vdmVkGA'
    'QgASgOMhguZ29vZ2xlLnByb3RvYnVmLkVkaXRpb25SDmVkaXRpb25SZW1vdmVkEiMKDXJlbW92'
    'YWxfZXJyb3IYBSABKAlSDHJlbW92YWxFcnJvciIvCgVDVHlwZRIKCgZTVFJJTkcQABIICgRDT1'
    'JEEAESEAoMU1RSSU5HX1BJRUNFEAIiNQoGSlNUeXBlEg0KCUpTX05PUk1BTBAAEg0KCUpTX1NU'
    'UklORxABEg0KCUpTX05VTUJFUhACIlUKD09wdGlvblJldGVudGlvbhIVChFSRVRFTlRJT05fVU'
    '5LTk9XThAAEhUKEVJFVEVOVElPTl9SVU5USU1FEAESFAoQUkVURU5USU9OX1NPVVJDRRACIowC'
    'ChBPcHRpb25UYXJnZXRUeXBlEhcKE1RBUkdFVF9UWVBFX1VOS05PV04QABIUChBUQVJHRVRfVF'
    'lQRV9GSUxFEAESHwobVEFSR0VUX1RZUEVfRVhURU5TSU9OX1JBTkdFEAISFwoTVEFSR0VUX1RZ'
    'UEVfTUVTU0FHRRADEhUKEVRBUkdFVF9UWVBFX0ZJRUxEEAQSFQoRVEFSR0VUX1RZUEVfT05FT0'
    'YQBRIUChBUQVJHRVRfVFlQRV9FTlVNEAYSGgoWVEFSR0VUX1RZUEVfRU5VTV9FTlRSWRAHEhcK'
    'E1RBUkdFVF9UWVBFX1NFUlZJQ0UQCBIWChJUQVJHRVRfVFlQRV9NRVRIT0QQCSoJCOgHEICAgI'
    'ACSgQIBBAFSgQIEhAT');

@$core.Deprecated('Use oneofOptionsDescriptor instead')
const OneofOptions$json = {
  '1': 'OneofOptions',
  '2': [
    {
      '1': 'features',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
};

/// Descriptor for `OneofOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oneofOptionsDescriptor = $convert.base64Decode(
    'CgxPbmVvZk9wdGlvbnMSNwoIZmVhdHVyZXMYASABKAsyGy5nb29nbGUucHJvdG9idWYuRmVhdH'
    'VyZVNldFIIZmVhdHVyZXMSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygLMiQuZ29vZ2xl'
    'LnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRpb24qCQjoBx'
    'CAgICAAg==');

@$core.Deprecated('Use enumOptionsDescriptor instead')
const EnumOptions$json = {
  '1': 'EnumOptions',
  '2': [
    {'1': 'allow_alias', '3': 2, '4': 1, '5': 8, '10': 'allowAlias'},
    {
      '1': 'deprecated',
      '3': 3,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'deprecated'
    },
    {
      '1': 'deprecated_legacy_json_field_conflicts',
      '3': 6,
      '4': 1,
      '5': 8,
      '8': {'3': true},
      '10': 'deprecatedLegacyJsonFieldConflicts',
    },
    {
      '1': 'features',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
  '9': [
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `EnumOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enumOptionsDescriptor = $convert.base64Decode(
    'CgtFbnVtT3B0aW9ucxIfCgthbGxvd19hbGlhcxgCIAEoCFIKYWxsb3dBbGlhcxIlCgpkZXByZW'
    'NhdGVkGAMgASgIOgVmYWxzZVIKZGVwcmVjYXRlZBJWCiZkZXByZWNhdGVkX2xlZ2FjeV9qc29u'
    'X2ZpZWxkX2NvbmZsaWN0cxgGIAEoCEICGAFSImRlcHJlY2F0ZWRMZWdhY3lKc29uRmllbGRDb2'
    '5mbGljdHMSNwoIZmVhdHVyZXMYByABKAsyGy5nb29nbGUucHJvdG9idWYuRmVhdHVyZVNldFII'
    'ZmVhdHVyZXMSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygLMiQuZ29vZ2xlLnByb3RvYn'
    'VmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRpb24qCQjoBxCAgICAAkoE'
    'CAUQBg==');

@$core.Deprecated('Use enumValueOptionsDescriptor instead')
const EnumValueOptions$json = {
  '1': 'EnumValueOptions',
  '2': [
    {
      '1': 'deprecated',
      '3': 1,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'deprecated'
    },
    {
      '1': 'features',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'debug_redact',
      '3': 3,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'debugRedact'
    },
    {
      '1': 'feature_support',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldOptions.FeatureSupport',
      '10': 'featureSupport'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
};

/// Descriptor for `EnumValueOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enumValueOptionsDescriptor = $convert.base64Decode(
    'ChBFbnVtVmFsdWVPcHRpb25zEiUKCmRlcHJlY2F0ZWQYASABKAg6BWZhbHNlUgpkZXByZWNhdG'
    'VkEjcKCGZlYXR1cmVzGAIgASgLMhsuZ29vZ2xlLnByb3RvYnVmLkZlYXR1cmVTZXRSCGZlYXR1'
    'cmVzEigKDGRlYnVnX3JlZGFjdBgDIAEoCDoFZmFsc2VSC2RlYnVnUmVkYWN0ElUKD2ZlYXR1cm'
    'Vfc3VwcG9ydBgEIAEoCzIsLmdvb2dsZS5wcm90b2J1Zi5GaWVsZE9wdGlvbnMuRmVhdHVyZVN1'
    'cHBvcnRSDmZlYXR1cmVTdXBwb3J0ElgKFHVuaW50ZXJwcmV0ZWRfb3B0aW9uGOcHIAMoCzIkLm'
    'dvb2dsZS5wcm90b2J1Zi5VbmludGVycHJldGVkT3B0aW9uUhN1bmludGVycHJldGVkT3B0aW9u'
    'KgkI6AcQgICAgAI=');

@$core.Deprecated('Use serviceOptionsDescriptor instead')
const ServiceOptions$json = {
  '1': 'ServiceOptions',
  '2': [
    {
      '1': 'features',
      '3': 34,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'deprecated',
      '3': 33,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'deprecated'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
};

/// Descriptor for `ServiceOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceOptionsDescriptor = $convert.base64Decode(
    'Cg5TZXJ2aWNlT3B0aW9ucxI3CghmZWF0dXJlcxgiIAEoCzIbLmdvb2dsZS5wcm90b2J1Zi5GZW'
    'F0dXJlU2V0UghmZWF0dXJlcxIlCgpkZXByZWNhdGVkGCEgASgIOgVmYWxzZVIKZGVwcmVjYXRl'
    'ZBJYChR1bmludGVycHJldGVkX29wdGlvbhjnByADKAsyJC5nb29nbGUucHJvdG9idWYuVW5pbn'
    'RlcnByZXRlZE9wdGlvblITdW5pbnRlcnByZXRlZE9wdGlvbioJCOgHEICAgIAC');

@$core.Deprecated('Use methodOptionsDescriptor instead')
const MethodOptions$json = {
  '1': 'MethodOptions',
  '2': [
    {
      '1': 'deprecated',
      '3': 33,
      '4': 1,
      '5': 8,
      '7': 'false',
      '10': 'deprecated'
    },
    {
      '1': 'idempotency_level',
      '3': 34,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.MethodOptions.IdempotencyLevel',
      '7': 'IDEMPOTENCY_UNKNOWN',
      '10': 'idempotencyLevel'
    },
    {
      '1': 'features',
      '3': 35,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'features'
    },
    {
      '1': 'uninterpreted_option',
      '3': 999,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption',
      '10': 'uninterpretedOption'
    },
  ],
  '4': [MethodOptions_IdempotencyLevel$json],
  '5': [
    {'1': 1000, '2': 536870912},
  ],
};

@$core.Deprecated('Use methodOptionsDescriptor instead')
const MethodOptions_IdempotencyLevel$json = {
  '1': 'IdempotencyLevel',
  '2': [
    {'1': 'IDEMPOTENCY_UNKNOWN', '2': 0},
    {'1': 'NO_SIDE_EFFECTS', '2': 1},
    {'1': 'IDEMPOTENT', '2': 2},
  ],
};

/// Descriptor for `MethodOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List methodOptionsDescriptor = $convert.base64Decode(
    'Cg1NZXRob2RPcHRpb25zEiUKCmRlcHJlY2F0ZWQYISABKAg6BWZhbHNlUgpkZXByZWNhdGVkEn'
    'EKEWlkZW1wb3RlbmN5X2xldmVsGCIgASgOMi8uZ29vZ2xlLnByb3RvYnVmLk1ldGhvZE9wdGlv'
    'bnMuSWRlbXBvdGVuY3lMZXZlbDoTSURFTVBPVEVOQ1lfVU5LTk9XTlIQaWRlbXBvdGVuY3lMZX'
    'ZlbBI3CghmZWF0dXJlcxgjIAEoCzIbLmdvb2dsZS5wcm90b2J1Zi5GZWF0dXJlU2V0UghmZWF0'
    'dXJlcxJYChR1bmludGVycHJldGVkX29wdGlvbhjnByADKAsyJC5nb29nbGUucHJvdG9idWYuVW'
    '5pbnRlcnByZXRlZE9wdGlvblITdW5pbnRlcnByZXRlZE9wdGlvbiJQChBJZGVtcG90ZW5jeUxl'
    'dmVsEhcKE0lERU1QT1RFTkNZX1VOS05PV04QABITCg9OT19TSURFX0VGRkVDVFMQARIOCgpJRE'
    'VNUE9URU5UEAIqCQjoBxCAgICAAg==');

@$core.Deprecated('Use uninterpretedOptionDescriptor instead')
const UninterpretedOption$json = {
  '1': 'UninterpretedOption',
  '2': [
    {
      '1': 'name',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.UninterpretedOption.NamePart',
      '10': 'name'
    },
    {'1': 'identifier_value', '3': 3, '4': 1, '5': 9, '10': 'identifierValue'},
    {
      '1': 'positive_int_value',
      '3': 4,
      '4': 1,
      '5': 4,
      '10': 'positiveIntValue'
    },
    {
      '1': 'negative_int_value',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'negativeIntValue'
    },
    {'1': 'double_value', '3': 6, '4': 1, '5': 1, '10': 'doubleValue'},
    {'1': 'string_value', '3': 7, '4': 1, '5': 12, '10': 'stringValue'},
    {'1': 'aggregate_value', '3': 8, '4': 1, '5': 9, '10': 'aggregateValue'},
  ],
  '3': [UninterpretedOption_NamePart$json],
};

@$core.Deprecated('Use uninterpretedOptionDescriptor instead')
const UninterpretedOption_NamePart$json = {
  '1': 'NamePart',
  '2': [
    {'1': 'name_part', '3': 1, '4': 2, '5': 9, '10': 'namePart'},
    {'1': 'is_extension', '3': 2, '4': 2, '5': 8, '10': 'isExtension'},
  ],
};

/// Descriptor for `UninterpretedOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uninterpretedOptionDescriptor = $convert.base64Decode(
    'ChNVbmludGVycHJldGVkT3B0aW9uEkEKBG5hbWUYAiADKAsyLS5nb29nbGUucHJvdG9idWYuVW'
    '5pbnRlcnByZXRlZE9wdGlvbi5OYW1lUGFydFIEbmFtZRIpChBpZGVudGlmaWVyX3ZhbHVlGAMg'
    'ASgJUg9pZGVudGlmaWVyVmFsdWUSLAoScG9zaXRpdmVfaW50X3ZhbHVlGAQgASgEUhBwb3NpdG'
    'l2ZUludFZhbHVlEiwKEm5lZ2F0aXZlX2ludF92YWx1ZRgFIAEoA1IQbmVnYXRpdmVJbnRWYWx1'
    'ZRIhCgxkb3VibGVfdmFsdWUYBiABKAFSC2RvdWJsZVZhbHVlEiEKDHN0cmluZ192YWx1ZRgHIA'
    'EoDFILc3RyaW5nVmFsdWUSJwoPYWdncmVnYXRlX3ZhbHVlGAggASgJUg5hZ2dyZWdhdGVWYWx1'
    'ZRpKCghOYW1lUGFydBIbCgluYW1lX3BhcnQYASACKAlSCG5hbWVQYXJ0EiEKDGlzX2V4dGVuc2'
    'lvbhgCIAIoCFILaXNFeHRlbnNpb24=');

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet$json = {
  '1': 'FeatureSet',
  '2': [
    {
      '1': 'field_presence',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FeatureSet.FieldPresence',
      '8': {
        '17': 1,
        '19': [4, 1],
        '20': [
          {'2': 'EXPLICIT', '3': 900},
          {'2': 'IMPLICIT', '3': 999},
          {'2': 'EXPLICIT', '3': 1000},
        ],
        '22': {'1': 1000},
      },
      '10': 'fieldPresence',
    },
    {
      '1': 'enum_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FeatureSet.EnumType',
      '8': {
        '17': 1,
        '19': [6, 1],
        '20': [
          {'2': 'CLOSED', '3': 900},
          {'2': 'OPEN', '3': 999},
        ],
        '22': {'1': 1000},
      },
      '10': 'enumType',
    },
    {
      '1': 'repeated_field_encoding',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FeatureSet.RepeatedFieldEncoding',
      '8': {
        '17': 1,
        '19': [4, 1],
        '20': [
          {'2': 'EXPANDED', '3': 900},
          {'2': 'PACKED', '3': 999},
        ],
        '22': {'1': 1000},
      },
      '10': 'repeatedFieldEncoding',
    },
    {
      '1': 'utf8_validation',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FeatureSet.Utf8Validation',
      '8': {
        '17': 1,
        '19': [4, 1],
        '20': [
          {'2': 'NONE', '3': 900},
          {'2': 'VERIFY', '3': 999},
        ],
        '22': {'1': 1000},
      },
      '10': 'utf8Validation',
    },
    {
      '1': 'message_encoding',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FeatureSet.MessageEncoding',
      '8': {
        '17': 1,
        '19': [4, 1],
        '20': [
          {'2': 'LENGTH_PREFIXED', '3': 900},
        ],
        '22': {'1': 1000},
      },
      '10': 'messageEncoding',
    },
    {
      '1': 'json_format',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FeatureSet.JsonFormat',
      '8': {
        '17': 1,
        '19': [3, 6, 1],
        '20': [
          {'2': 'LEGACY_BEST_EFFORT', '3': 900},
          {'2': 'ALLOW', '3': 999},
        ],
        '22': {'1': 1000},
      },
      '10': 'jsonFormat',
    },
    {
      '1': 'enforce_naming_style',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.FeatureSet.EnforceNamingStyle',
      '8': {
        '17': 2,
        '19': [1, 2, 3, 4, 5, 6, 7, 8, 9],
        '20': [
          {'2': 'STYLE_LEGACY', '3': 900},
          {'2': 'STYLE2024', '3': 1001},
        ],
        '22': {'1': 1001},
      },
      '10': 'enforceNamingStyle',
    },
    {
      '1': 'default_symbol_visibility',
      '3': 8,
      '4': 1,
      '5': 14,
      '6':
          '.google.protobuf.FeatureSet.VisibilityFeature.DefaultSymbolVisibility',
      '8': {
        '17': 2,
        '19': [1],
        '20': [
          {'2': 'EXPORT_ALL', '3': 900},
          {'2': 'EXPORT_TOP_LEVEL', '3': 1001},
        ],
        '22': {'1': 1001},
      },
      '10': 'defaultSymbolVisibility',
    },
  ],
  '3': [FeatureSet_VisibilityFeature$json],
  '4': [
    FeatureSet_FieldPresence$json,
    FeatureSet_EnumType$json,
    FeatureSet_RepeatedFieldEncoding$json,
    FeatureSet_Utf8Validation$json,
    FeatureSet_MessageEncoding$json,
    FeatureSet_JsonFormat$json,
    FeatureSet_EnforceNamingStyle$json
  ],
  '5': [
    {'1': 1000, '2': 9995},
    {'1': 9995, '2': 10000},
    {'1': 10000, '2': 10001},
  ],
  '9': [
    {'1': 999, '2': 1000},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_VisibilityFeature$json = {
  '1': 'VisibilityFeature',
  '4': [FeatureSet_VisibilityFeature_DefaultSymbolVisibility$json],
  '9': [
    {'1': 1, '2': 536870912},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_VisibilityFeature_DefaultSymbolVisibility$json = {
  '1': 'DefaultSymbolVisibility',
  '2': [
    {'1': 'DEFAULT_SYMBOL_VISIBILITY_UNKNOWN', '2': 0},
    {'1': 'EXPORT_ALL', '2': 1},
    {'1': 'EXPORT_TOP_LEVEL', '2': 2},
    {'1': 'LOCAL_ALL', '2': 3},
    {'1': 'STRICT', '2': 4},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_FieldPresence$json = {
  '1': 'FieldPresence',
  '2': [
    {'1': 'FIELD_PRESENCE_UNKNOWN', '2': 0},
    {'1': 'EXPLICIT', '2': 1},
    {'1': 'IMPLICIT', '2': 2},
    {'1': 'LEGACY_REQUIRED', '2': 3},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_EnumType$json = {
  '1': 'EnumType',
  '2': [
    {'1': 'ENUM_TYPE_UNKNOWN', '2': 0},
    {'1': 'OPEN', '2': 1},
    {'1': 'CLOSED', '2': 2},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_RepeatedFieldEncoding$json = {
  '1': 'RepeatedFieldEncoding',
  '2': [
    {'1': 'REPEATED_FIELD_ENCODING_UNKNOWN', '2': 0},
    {'1': 'PACKED', '2': 1},
    {'1': 'EXPANDED', '2': 2},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_Utf8Validation$json = {
  '1': 'Utf8Validation',
  '2': [
    {'1': 'UTF8_VALIDATION_UNKNOWN', '2': 0},
    {'1': 'VERIFY', '2': 2},
    {'1': 'NONE', '2': 3},
  ],
  '4': [
    {'1': 1, '2': 1},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_MessageEncoding$json = {
  '1': 'MessageEncoding',
  '2': [
    {'1': 'MESSAGE_ENCODING_UNKNOWN', '2': 0},
    {'1': 'LENGTH_PREFIXED', '2': 1},
    {'1': 'DELIMITED', '2': 2},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_JsonFormat$json = {
  '1': 'JsonFormat',
  '2': [
    {'1': 'JSON_FORMAT_UNKNOWN', '2': 0},
    {'1': 'ALLOW', '2': 1},
    {'1': 'LEGACY_BEST_EFFORT', '2': 2},
  ],
};

@$core.Deprecated('Use featureSetDescriptor instead')
const FeatureSet_EnforceNamingStyle$json = {
  '1': 'EnforceNamingStyle',
  '2': [
    {'1': 'ENFORCE_NAMING_STYLE_UNKNOWN', '2': 0},
    {'1': 'STYLE2024', '2': 1},
    {'1': 'STYLE_LEGACY', '2': 2},
  ],
};

/// Descriptor for `FeatureSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureSetDescriptor = $convert.base64Decode(
    'CgpGZWF0dXJlU2V0EpEBCg5maWVsZF9wcmVzZW5jZRgBIAEoDjIpLmdvb2dsZS5wcm90b2J1Zi'
    '5GZWF0dXJlU2V0LkZpZWxkUHJlc2VuY2VCP4gBAZgBBJgBAaIBDRIIRVhQTElDSVQYhAeiAQ0S'
    'CElNUExJQ0lUGOcHogENEghFWFBMSUNJVBjoB7IBAwjoB1INZmllbGRQcmVzZW5jZRJsCgllbn'
    'VtX3R5cGUYAiABKA4yJC5nb29nbGUucHJvdG9idWYuRmVhdHVyZVNldC5FbnVtVHlwZUIpiAEB'
    'mAEGmAEBogELEgZDTE9TRUQYhAeiAQkSBE9QRU4Y5weyAQMI6AdSCGVudW1UeXBlEpgBChdyZX'
    'BlYXRlZF9maWVsZF9lbmNvZGluZxgDIAEoDjIxLmdvb2dsZS5wcm90b2J1Zi5GZWF0dXJlU2V0'
    'LlJlcGVhdGVkRmllbGRFbmNvZGluZ0ItiAEBmAEEmAEBogENEghFWFBBTkRFRBiEB6IBCxIGUE'
    'FDS0VEGOcHsgEDCOgHUhVyZXBlYXRlZEZpZWxkRW5jb2RpbmcSfgoPdXRmOF92YWxpZGF0aW9u'
    'GAQgASgOMiouZ29vZ2xlLnByb3RvYnVmLkZlYXR1cmVTZXQuVXRmOFZhbGlkYXRpb25CKYgBAZ'
    'gBBJgBAaIBCRIETk9ORRiEB6IBCxIGVkVSSUZZGOcHsgEDCOgHUg51dGY4VmFsaWRhdGlvbhJ+'
    'ChBtZXNzYWdlX2VuY29kaW5nGAUgASgOMisuZ29vZ2xlLnByb3RvYnVmLkZlYXR1cmVTZXQuTW'
    'Vzc2FnZUVuY29kaW5nQiaIAQGYAQSYAQGiARQSD0xFTkdUSF9QUkVGSVhFRBiEB7IBAwjoB1IP'
    'bWVzc2FnZUVuY29kaW5nEoIBCgtqc29uX2Zvcm1hdBgGIAEoDjImLmdvb2dsZS5wcm90b2J1Zi'
    '5GZWF0dXJlU2V0Lkpzb25Gb3JtYXRCOYgBAZgBA5gBBpgBAaIBFxISTEVHQUNZX0JFU1RfRUZG'
    'T1JUGIQHogEKEgVBTExPVxjnB7IBAwjoB1IKanNvbkZvcm1hdBKrAQoUZW5mb3JjZV9uYW1pbm'
    'dfc3R5bGUYByABKA4yLi5nb29nbGUucHJvdG9idWYuRmVhdHVyZVNldC5FbmZvcmNlTmFtaW5n'
    'U3R5bGVCSYgBApgBAZgBApgBA5gBBJgBBZgBBpgBB5gBCJgBCaIBERIMU1RZTEVfTEVHQUNZGI'
    'QHogEOEglTVFlMRTIwMjQY6QeyAQMI6QdSEmVuZm9yY2VOYW1pbmdTdHlsZRK5AQoZZGVmYXVs'
    'dF9zeW1ib2xfdmlzaWJpbGl0eRgIIAEoDjJFLmdvb2dsZS5wcm90b2J1Zi5GZWF0dXJlU2V0Ll'
    'Zpc2liaWxpdHlGZWF0dXJlLkRlZmF1bHRTeW1ib2xWaXNpYmlsaXR5QjaIAQKYAQGiAQ8SCkVY'
    'UE9SVF9BTEwYhAeiARUSEEVYUE9SVF9UT1BfTEVWRUwY6QeyAQMI6QdSF2RlZmF1bHRTeW1ib2'
    'xWaXNpYmlsaXR5GqEBChFWaXNpYmlsaXR5RmVhdHVyZSKBAQoXRGVmYXVsdFN5bWJvbFZpc2li'
    'aWxpdHkSJQohREVGQVVMVF9TWU1CT0xfVklTSUJJTElUWV9VTktOT1dOEAASDgoKRVhQT1JUX0'
    'FMTBABEhQKEEVYUE9SVF9UT1BfTEVWRUwQAhINCglMT0NBTF9BTEwQAxIKCgZTVFJJQ1QQBEoI'
    'CAEQgICAgAIiXAoNRmllbGRQcmVzZW5jZRIaChZGSUVMRF9QUkVTRU5DRV9VTktOT1dOEAASDA'
    'oIRVhQTElDSVQQARIMCghJTVBMSUNJVBACEhMKD0xFR0FDWV9SRVFVSVJFRBADIjcKCEVudW1U'
    'eXBlEhUKEUVOVU1fVFlQRV9VTktOT1dOEAASCAoET1BFThABEgoKBkNMT1NFRBACIlYKFVJlcG'
    'VhdGVkRmllbGRFbmNvZGluZxIjCh9SRVBFQVRFRF9GSUVMRF9FTkNPRElOR19VTktOT1dOEAAS'
    'CgoGUEFDS0VEEAESDAoIRVhQQU5ERUQQAiJJCg5VdGY4VmFsaWRhdGlvbhIbChdVVEY4X1ZBTE'
    'lEQVRJT05fVU5LTk9XThAAEgoKBlZFUklGWRACEggKBE5PTkUQAyIECAEQASJTCg9NZXNzYWdl'
    'RW5jb2RpbmcSHAoYTUVTU0FHRV9FTkNPRElOR19VTktOT1dOEAASEwoPTEVOR1RIX1BSRUZJWE'
    'VEEAESDQoJREVMSU1JVEVEEAIiSAoKSnNvbkZvcm1hdBIXChNKU09OX0ZPUk1BVF9VTktOT1dO'
    'EAASCQoFQUxMT1cQARIWChJMRUdBQ1lfQkVTVF9FRkZPUlQQAiJXChJFbmZvcmNlTmFtaW5nU3'
    'R5bGUSIAocRU5GT1JDRV9OQU1JTkdfU1RZTEVfVU5LTk9XThAAEg0KCVNUWUxFMjAyNBABEhAK'
    'DFNUWUxFX0xFR0FDWRACKgYI6AcQi04qBgiLThCQTioGCJBOEJFOSgYI5wcQ6Ac=');

@$core.Deprecated('Use featureSetDefaultsDescriptor instead')
const FeatureSetDefaults$json = {
  '1': 'FeatureSetDefaults',
  '2': [
    {
      '1': 'defaults',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.FeatureSetDefaults.FeatureSetEditionDefault',
      '10': 'defaults'
    },
    {
      '1': 'minimum_edition',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'minimumEdition'
    },
    {
      '1': 'maximum_edition',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'maximumEdition'
    },
  ],
  '3': [FeatureSetDefaults_FeatureSetEditionDefault$json],
};

@$core.Deprecated('Use featureSetDefaultsDescriptor instead')
const FeatureSetDefaults_FeatureSetEditionDefault$json = {
  '1': 'FeatureSetEditionDefault',
  '2': [
    {
      '1': 'edition',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.Edition',
      '10': 'edition'
    },
    {
      '1': 'overridable_features',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'overridableFeatures'
    },
    {
      '1': 'fixed_features',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FeatureSet',
      '10': 'fixedFeatures'
    },
  ],
  '9': [
    {'1': 1, '2': 2},
    {'1': 2, '2': 3},
  ],
  '10': ['features'],
};

/// Descriptor for `FeatureSetDefaults`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureSetDefaultsDescriptor = $convert.base64Decode(
    'ChJGZWF0dXJlU2V0RGVmYXVsdHMSWAoIZGVmYXVsdHMYASADKAsyPC5nb29nbGUucHJvdG9idW'
    'YuRmVhdHVyZVNldERlZmF1bHRzLkZlYXR1cmVTZXRFZGl0aW9uRGVmYXVsdFIIZGVmYXVsdHMS'
    'QQoPbWluaW11bV9lZGl0aW9uGAQgASgOMhguZ29vZ2xlLnByb3RvYnVmLkVkaXRpb25SDm1pbm'
    'ltdW1FZGl0aW9uEkEKD21heGltdW1fZWRpdGlvbhgFIAEoDjIYLmdvb2dsZS5wcm90b2J1Zi5F'
    'ZGl0aW9uUg5tYXhpbXVtRWRpdGlvbhr4AQoYRmVhdHVyZVNldEVkaXRpb25EZWZhdWx0EjIKB2'
    'VkaXRpb24YAyABKA4yGC5nb29nbGUucHJvdG9idWYuRWRpdGlvblIHZWRpdGlvbhJOChRvdmVy'
    'cmlkYWJsZV9mZWF0dXJlcxgEIAEoCzIbLmdvb2dsZS5wcm90b2J1Zi5GZWF0dXJlU2V0UhNvdm'
    'VycmlkYWJsZUZlYXR1cmVzEkIKDmZpeGVkX2ZlYXR1cmVzGAUgASgLMhsuZ29vZ2xlLnByb3Rv'
    'YnVmLkZlYXR1cmVTZXRSDWZpeGVkRmVhdHVyZXNKBAgBEAJKBAgCEANSCGZlYXR1cmVz');

@$core.Deprecated('Use sourceCodeInfoDescriptor instead')
const SourceCodeInfo$json = {
  '1': 'SourceCodeInfo',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.SourceCodeInfo.Location',
      '10': 'location'
    },
  ],
  '3': [SourceCodeInfo_Location$json],
  '5': [
    {'1': 536000000, '2': 536000001},
  ],
};

@$core.Deprecated('Use sourceCodeInfoDescriptor instead')
const SourceCodeInfo_Location$json = {
  '1': 'Location',
  '2': [
    {
      '1': 'path',
      '3': 1,
      '4': 3,
      '5': 5,
      '8': {'2': true},
      '10': 'path',
    },
    {
      '1': 'span',
      '3': 2,
      '4': 3,
      '5': 5,
      '8': {'2': true},
      '10': 'span',
    },
    {'1': 'leading_comments', '3': 3, '4': 1, '5': 9, '10': 'leadingComments'},
    {
      '1': 'trailing_comments',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'trailingComments'
    },
    {
      '1': 'leading_detached_comments',
      '3': 6,
      '4': 3,
      '5': 9,
      '10': 'leadingDetachedComments'
    },
  ],
};

/// Descriptor for `SourceCodeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sourceCodeInfoDescriptor = $convert.base64Decode(
    'Cg5Tb3VyY2VDb2RlSW5mbxJECghsb2NhdGlvbhgBIAMoCzIoLmdvb2dsZS5wcm90b2J1Zi5Tb3'
    'VyY2VDb2RlSW5mby5Mb2NhdGlvblIIbG9jYXRpb24azgEKCExvY2F0aW9uEhYKBHBhdGgYASAD'
    'KAVCAhABUgRwYXRoEhYKBHNwYW4YAiADKAVCAhABUgRzcGFuEikKEGxlYWRpbmdfY29tbWVudH'
    'MYAyABKAlSD2xlYWRpbmdDb21tZW50cxIrChF0cmFpbGluZ19jb21tZW50cxgEIAEoCVIQdHJh'
    'aWxpbmdDb21tZW50cxI6ChlsZWFkaW5nX2RldGFjaGVkX2NvbW1lbnRzGAYgAygJUhdsZWFkaW'
    '5nRGV0YWNoZWRDb21tZW50cyoMCIDsyv8BEIHsyv8B');

@$core.Deprecated('Use generatedCodeInfoDescriptor instead')
const GeneratedCodeInfo$json = {
  '1': 'GeneratedCodeInfo',
  '2': [
    {
      '1': 'annotation',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.GeneratedCodeInfo.Annotation',
      '10': 'annotation'
    },
  ],
  '3': [GeneratedCodeInfo_Annotation$json],
};

@$core.Deprecated('Use generatedCodeInfoDescriptor instead')
const GeneratedCodeInfo_Annotation$json = {
  '1': 'Annotation',
  '2': [
    {
      '1': 'path',
      '3': 1,
      '4': 3,
      '5': 5,
      '8': {'2': true},
      '10': 'path',
    },
    {'1': 'source_file', '3': 2, '4': 1, '5': 9, '10': 'sourceFile'},
    {'1': 'begin', '3': 3, '4': 1, '5': 5, '10': 'begin'},
    {'1': 'end', '3': 4, '4': 1, '5': 5, '10': 'end'},
    {
      '1': 'semantic',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.google.protobuf.GeneratedCodeInfo.Annotation.Semantic',
      '10': 'semantic'
    },
  ],
  '4': [GeneratedCodeInfo_Annotation_Semantic$json],
};

@$core.Deprecated('Use generatedCodeInfoDescriptor instead')
const GeneratedCodeInfo_Annotation_Semantic$json = {
  '1': 'Semantic',
  '2': [
    {'1': 'NONE', '2': 0},
    {'1': 'SET', '2': 1},
    {'1': 'ALIAS', '2': 2},
  ],
};

/// Descriptor for `GeneratedCodeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatedCodeInfoDescriptor = $convert.base64Decode(
    'ChFHZW5lcmF0ZWRDb2RlSW5mbxJNCgphbm5vdGF0aW9uGAEgAygLMi0uZ29vZ2xlLnByb3RvYn'
    'VmLkdlbmVyYXRlZENvZGVJbmZvLkFubm90YXRpb25SCmFubm90YXRpb24a6wEKCkFubm90YXRp'
    'b24SFgoEcGF0aBgBIAMoBUICEAFSBHBhdGgSHwoLc291cmNlX2ZpbGUYAiABKAlSCnNvdXJjZU'
    'ZpbGUSFAoFYmVnaW4YAyABKAVSBWJlZ2luEhAKA2VuZBgEIAEoBVIDZW5kElIKCHNlbWFudGlj'
    'GAUgASgOMjYuZ29vZ2xlLnByb3RvYnVmLkdlbmVyYXRlZENvZGVJbmZvLkFubm90YXRpb24uU2'
    'VtYW50aWNSCHNlbWFudGljIigKCFNlbWFudGljEggKBE5PTkUQABIHCgNTRVQQARIJCgVBTElB'
    'UxAC');
