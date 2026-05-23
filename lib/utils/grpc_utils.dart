import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:apidash/models/protocols/grpc_model.dart';
import 'package:apidash/services/grpc_reflection_service.dart';

class GrpcUtils {
  static Future<Map<String, dynamic>> parseProtoFile(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return {};

      final content = await file.readAsString();
      final services = <String>[];
      final methods = <String, List<String>>{};
      final messageFields = <String, List<GrpcParameterModel>>{};

      // Basic regex for services
      final serviceRegex = RegExp(r'service\s+(\w+)\s*\{');
      final matches = serviceRegex.allMatches(content);

      for (final match in matches) {
        final serviceName = match.group(1)!;
        services.add(serviceName);
        
        // Find methods for this service
        // This is a simplified search and won't handle complex nesting well
        final serviceBlockRegex = RegExp('service\\s+$serviceName\\s*\\{([^\\}]*)\\}');
        final serviceBlock = serviceBlockRegex.firstMatch(content)?.group(1) ?? "";
        
        final methodRegex = RegExp(r'rpc\s+(\w+)\s*\(([^)]*)\)\s+returns\s*\(([^)]*)\)');
        final methodMatches = methodRegex.allMatches(serviceBlock);
        
        final serviceMethods = <String>[];
        for (final mMatch in methodMatches) {
          final methodName = mMatch.group(1)!;
          final requestType = mMatch.group(2)!.trim();
          serviceMethods.add(methodName);
          
          // Store request type to map to fields later
          methods["$serviceName/$methodName"] = [requestType];
        }
        methods[serviceName] = serviceMethods;
      }

      // Basic regex for messages (to populate form fields)
      final messageRegex = RegExp(r'message\s+(\w+)\s*\{([^\}]*)\}');
      final msgMatches = messageRegex.allMatches(content);
      
      for (final match in msgMatches) {
        final msgName = match.group(1)!;
        final msgBody = match.group(2)!;
        
        final fields = <GrpcParameterModel>[];
        final fieldLineRegex = RegExp(r'(\w+)\s+(\w+)\s*=\s*(\d+);');
        final fieldLines = fieldLineRegex.allMatches(msgBody);
        
        for (final fMatch in fieldLines) {
          final type = fMatch.group(1)!;
          final name = fMatch.group(2)!;
          final tag = int.tryParse(fMatch.group(3)!) ?? 0;
          
          fields.add(GrpcParameterModel(
            name: name,
            tag: tag,
            type: type,
            enabled: true,
            value: "",
          ));
        }
        messageFields[msgName] = fields;
      }

      return {
        'services': services,
        'methods': methods,
        'messageFields': messageFields,
      };
    } catch (e) {
      print("Error parsing proto: $e");
      return {};
    }
  }

  static String decodeBinaryResponse(List<int> data, {GrpcMethodSchema? schema}) {
    try {
      if (data.isEmpty) return "";
      
      final mapped = _decodeWithSchema(data, schema?.outputDescriptor, schema?.allDescriptors ?? {});
      return _prettyJson(mapped);
    } catch (e) {
      return data.toString();
    }
  }

  static Map<String, dynamic> _decodeWithSchema(List<int> data, dynamic descriptor, Map<String, dynamic> allDescriptors) {
    final result = <String, dynamic>{};
    int offset = 0;

    while (offset < data.length) {
      final key = _readVarint(data, offset);
      if (key == null) break;
      offset = key.nextOffset;

      final tag = key.value >> 3;
      final wireType = key.value & 0x07;

      dynamic fieldDesc;
      if (descriptor != null) {
        for (final f in descriptor.field) {
          if (f.number == tag) {
            fieldDesc = f;
            break;
          }
        }
      }

      final fieldName = fieldDesc != null ? fieldDesc.name : tag.toString();

      switch (wireType) {
        case 0: // Varint
          final val = _readVarint(data, offset);
          if (val == null) return result;
          result[fieldName] = val.value;
          offset = val.nextOffset;
          break;
        case 2: // Length-delimited
          final len = _readVarint(data, offset);
          if (len == null) return result;
          offset = len.nextOffset;
          final bytes = data.sublist(offset, offset + len.value);
          offset += len.value;

          if (fieldDesc != null && fieldDesc.type.toString() == 'TYPE_MESSAGE') {
             var typeName = fieldDesc.typeName;
             if (typeName.startsWith('.')) typeName = typeName.substring(1);
             final nestedDesc = allDescriptors[typeName];
             result[fieldName] = _decodeWithSchema(bytes, nestedDesc, allDescriptors);
          } else {
             try {
               result[fieldName] = utf8.decode(bytes);
             } catch (_) {
               // If there's no descriptor, fallback to checking if it's likely protobuf
               if (descriptor == null && _isLikelyProtobuf(bytes)) {
                  try {
                    result[fieldName] = _decodeWithSchema(bytes, null, allDescriptors);
                  } catch (_) {
                    result[fieldName] = bytes.toString();
                  }
               } else {
                 result[fieldName] = bytes.toString();
               }
             }
          }
          break;
        case 1: // 64-bit
          offset += 8;
          break;
        case 5: // 32-bit
          offset += 4;
          break;
        default:
          return result;
      }
    }
    return result;
  }

  static bool _isLikelyProtobuf(List<int> data) {
      if (data.isEmpty) return false;
      final firstByte = data[0];
      final wireType = firstByte & 0x07;
      return wireType <= 5;
  }

  static _VarintResult? _readVarint(List<int> data, int offset) {
    int value = 0;
    int shift = 0;
    int index = offset;

    while (index < data.length) {
      final b = data[index++];
      value |= (b & 0x7F) << shift;
      if (b < 0x80) return _VarintResult(value, index);
      shift += 7;
      if (shift >= 64) break;
    }
    return null;
  }

  static String paramsToJson(List<GrpcParameterModel> params) {
    if (params.isEmpty) return "";
    final map = <String, dynamic>{};
    for (var p in params) {
      if (p.enabled && p.name.isNotEmpty) {
        dynamic val = p.value;
        if (p.type == 'int32' || p.type == 'uint32' || p.type == 'sint32' || p.type == 'fixed32' || p.type == 'sfixed32') {
          val = int.tryParse(p.value) ?? 0;
        } else if (p.type == 'int64' || p.type == 'uint64' || p.type == 'sint64' || p.type == 'fixed64' || p.type == 'sfixed64') {
          val = int.tryParse(p.value) ?? 0;
        } else if (p.type == 'double' || p.type == 'float') {
          val = double.tryParse(p.value) ?? 0.0;
        } else if (p.type == 'bool') {
          val = p.value.toLowerCase() == 'true';
        }
        map[p.name] = val;
      }
    }
    return _prettyJson(map);
  }

  static List<int> paramsToBytes(List<GrpcParameterModel> params) {
    if (params.isEmpty) return [];
    
    final List<int> result = [];
    for (var p in params) {
      if (!p.enabled || p.name.isEmpty || p.tag == null) continue;
      
      final tag = p.tag!;
      final wireType = _getWireType(p.type);
      
      // Write tag & wire type
      _writeVarint(result, (tag << 3) | wireType);
      
      switch (wireType) {
        case 0: // Varint
          int val = 0;
          if (p.type == 'bool') {
            val = p.value.toLowerCase() == 'true' ? 1 : 0;
          } else {
            val = int.tryParse(p.value) ?? 0;
          }
          _writeVarint(result, val);
          break;
        case 2: // Length-delimited
          final bytes = utf8.encode(p.value);
          _writeVarint(result, bytes.length);
          result.addAll(bytes);
          break;
        case 1: // 64-bit
          // Simple fixed64/double (simplified)
          final val = double.tryParse(p.value) ?? 0.0;
          final bdata = ByteData(8);
          bdata.setFloat64(0, val, Endian.little);
          result.addAll(bdata.buffer.asUint8List());
          break;
        case 5: // 32-bit
          final val = double.tryParse(p.value) ?? 0.0;
          final bdata = ByteData(4);
          bdata.setFloat32(0, val.toDouble(), Endian.little);
          result.addAll(bdata.buffer.asUint8List());
          break;
      }
    }
    return result;
  }

  static int _getWireType(String type) {
    switch (type) {
      case 'double':
      case 'fixed64':
      case 'sfixed64':
        return 1;
      case 'float':
      case 'fixed32':
      case 'sfixed32':
        return 5;
      case 'string':
      case 'bytes':
      case 'message':
        return 2;
      default:
        return 0; // Varint for most ints and bool
    }
  }

  static void _writeVarint(List<int> buffer, int value) {
    while (value >= 0x80) {
      buffer.add((value & 0x7F) | 0x80);
      value >>= 7;
    }
    buffer.add(value);
  }

  static String _prettyJson(dynamic obj) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(obj);
  }
}

class _VarintResult {
  final int value;
  final int nextOffset;
  _VarintResult(this.value, this.nextOffset);
}
