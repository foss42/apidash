import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/services/grpc_reflection_service.dart';

class GrpcUtils {
  static Future<Map<String, dynamic>> parseProtoFile(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return {};

      final raw = await file.readAsString();
      final content = _stripComments(raw);

      final services = <String>[];
      final methods = <String, List<String>>{};
      final messageFields = <String, List<GrpcParameterModel>>{};
      // enum name (simple + fully-qualified) -> ordered value names
      final enums = <String, List<String>>{};

      // Recursively walk balanced { } blocks so nested message/enum blocks are
      // handled correctly instead of the old non-nesting `[^}]*` regex.
      _parseLevel(content, '', services, methods, messageFields, enums);

      // Post-process: fields whose declared type resolves to a parsed enum are
      // re-tagged as 'enum' and get their value list so the UI can offer a
      // dropdown. Fields keep their scalar type name otherwise.
      messageFields.forEach((msg, fields) {
        for (var i = 0; i < fields.length; i++) {
          final f = fields[i];
          final values = enums[f.type];
          if (values != null && values.isNotEmpty && f.type != 'enum') {
            fields[i] = f.copyWith(type: 'enum', enumValues: values);
          }
        }
      });

      return {
        'services': services,
        'methods': methods,
        'messageFields': messageFields,
      };
    } catch (e) {
      return {};
    }
  }

  // Strip `//` line comments and `/* */` block comments before parsing.
  static String _stripComments(String src) {
    var s = src.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ');
    s = s.replaceAll(RegExp(r'//[^\n]*'), ' ');
    return s;
  }

  // Index of the '}' that matches the '{' at [open]; -1 if unbalanced.
  static int _matchBrace(String s, int open) {
    int depth = 0;
    for (int i = open; i < s.length; i++) {
      final c = s.codeUnitAt(i);
      if (c == 0x7B) {
        depth++;
      } else if (c == 0x7D) {
        depth--;
        if (depth == 0) return i;
      }
    }
    return -1;
  }

  // Drop the contents of any nested { } blocks so field parsing of a message
  // does not accidentally pick up fields/values from nested messages or enums.
  static String _removeNestedBlocks(String s) {
    final sb = StringBuffer();
    int depth = 0;
    for (int i = 0; i < s.length; i++) {
      final c = s.codeUnitAt(i);
      if (c == 0x7B) {
        depth++;
        continue;
      }
      if (c == 0x7D) {
        if (depth > 0) depth--;
        continue;
      }
      if (depth == 0) sb.writeCharCode(c);
    }
    return sb.toString();
  }

  // Parse service / message / enum blocks found directly inside [body],
  // recursing into message bodies for nested definitions. `import`, `package`,
  // `option`, `syntax` etc. carry no braces so they are simply skipped.
  static void _parseLevel(
    String body,
    String prefix,
    List<String> services,
    Map<String, List<String>> methods,
    Map<String, List<GrpcParameterModel>> messageFields,
    Map<String, List<String>> enums,
  ) {
    final headerRe = RegExp(r'(service|message|enum)\s+(\w+)\s*\{');
    int pos = 0;
    while (pos < body.length) {
      final m = headerRe.firstMatch(body.substring(pos));
      if (m == null) break;
      final kw = m.group(1)!;
      final name = m.group(2)!;
      final openBrace = pos + m.end - 1;
      final close = _matchBrace(body, openBrace);
      if (close == -1) break;
      final inner = body.substring(openBrace + 1, close);
      final fullName = prefix.isEmpty ? name : '$prefix.$name';

      if (kw == 'service') {
        services.add(name);
        final serviceMethods = <String>[];
        final methodRegex = RegExp(
            r'rpc\s+(\w+)\s*\(([^)]*)\)\s+returns\s*\(([^)]*)\)');
        for (final mMatch in methodRegex.allMatches(inner)) {
          final methodName = mMatch.group(1)!;
          var requestType = mMatch.group(2)!.trim();
          // Drop a leading `stream ` qualifier so the type resolves cleanly.
          if (requestType.startsWith('stream ')) {
            requestType = requestType.substring(7).trim();
          }
          serviceMethods.add(methodName);
          methods['$name/$methodName'] = [requestType];
        }
        methods[name] = serviceMethods;
      } else if (kw == 'message') {
        final direct = _removeNestedBlocks(inner);
        final fields = <GrpcParameterModel>[];
        final fieldLineRegex = RegExp(r'(\w+)\s+(\w+)\s*=\s*(\d+)\s*;');
        for (final fMatch in fieldLineRegex.allMatches(direct)) {
          final type = fMatch.group(1)!;
          final fname = fMatch.group(2)!;
          final tag = int.tryParse(fMatch.group(3)!) ?? 0;
          fields.add(GrpcParameterModel(
            name: fname,
            tag: tag,
            type: type,
            enabled: true,
            value: "",
          ));
        }
        messageFields[name] = fields;
        if (fullName != name) messageFields[fullName] = fields;
        // Recurse for nested messages / enums.
        _parseLevel(inner, fullName, services, methods, messageFields, enums);
      } else {
        // enum
        final direct = _removeNestedBlocks(inner);
        final values = <String>[];
        final valueRegex = RegExp(r'(\w+)\s*=\s*-?\d+\s*;');
        for (final vMatch in valueRegex.allMatches(direct)) {
          final vName = vMatch.group(1)!;
          if (vName == 'option' || vName == 'reserved') continue;
          values.add(vName);
        }
        enums[name] = values;
        if (fullName != name) enums[fullName] = values;
      }

      pos = close + 1;
    }
  }

  static String decodeBinaryResponse(List<int> data, {GrpcMethodSchema? schema}) {
    try {
      if (data.isEmpty) return "";

      final mapped = _decodeWithSchema(
          data, schema?.outputDescriptor, schema?.allDescriptors ?? {});
      return _prettyJson(mapped);
    } catch (e) {
      return data.toString();
    }
  }

  static Map<String, dynamic> _decodeWithSchema(
      List<int> data, dynamic descriptor, Map<String, dynamic> allDescriptors) {
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
      final typeName = _fieldTypeName(fieldDesc);
      final repeated = _isRepeated(fieldDesc);

      switch (wireType) {
        case 0: // Varint (int32/64, uint32/64, bool, enum, sint via zigzag)
          final val = _readVarint(data, offset);
          if (val == null) return result;
          offset = val.nextOffset;
          _assign(result, fieldName, _decodeVarintValue(val.value, typeName),
              repeated);
          break;
        case 1: // 64-bit fixed (fixed64 / sfixed64 / double)
          if (offset + 8 > data.length) return result;
          final bd = Uint8List.fromList(data.sublist(offset, offset + 8))
              .buffer
              .asByteData();
          offset += 8;
          _assign(result, fieldName, _decodeFixed64Value(bd, typeName),
              repeated);
          break;
        case 2: // Length-delimited (string/bytes/message/packed repeated)
          final len = _readVarint(data, offset);
          if (len == null) return result;
          offset = len.nextOffset;
          if (offset + len.value > data.length) return result;
          final bytes = data.sublist(offset, offset + len.value);
          offset += len.value;

          if (_isMessageType(typeName)) {
            var tn = fieldDesc.typeName as String;
            if (tn.startsWith('.')) tn = tn.substring(1);
            final nestedDesc = allDescriptors[tn];
            _assign(result, fieldName,
                _decodeWithSchema(bytes, nestedDesc, allDescriptors), repeated);
          } else if (_packedKind(typeName) != null) {
            _assignList(result, fieldName, _decodePacked(bytes, typeName));
          } else if (_isBytesType(typeName)) {
            _assign(result, fieldName, base64Encode(bytes), repeated);
          } else if (typeName == 'TYPE_STRING') {
            try {
              _assign(result, fieldName, utf8.decode(bytes), repeated);
            } catch (_) {
              _assign(result, fieldName, bytes, repeated);
            }
          } else {
            // No descriptor: best-effort string, else nested protobuf, else raw.
            try {
              _assign(result, fieldName, utf8.decode(bytes), repeated);
            } catch (_) {
              if (descriptor == null && _isLikelyProtobuf(bytes)) {
                try {
                  _assign(result, fieldName,
                      _decodeWithSchema(bytes, null, allDescriptors), repeated);
                } catch (_) {
                  _assign(result, fieldName, bytes.toString(), repeated);
                }
              } else {
                _assign(result, fieldName, bytes.toString(), repeated);
              }
            }
          }
          break;
        case 5: // 32-bit fixed (fixed32 / sfixed32 / float)
          if (offset + 4 > data.length) return result;
          final bd32 = Uint8List.fromList(data.sublist(offset, offset + 4))
              .buffer
              .asByteData();
          offset += 4;
          _assign(result, fieldName, _decodeFixed32Value(bd32, typeName),
              repeated);
          break;
        default:
          return result;
      }
    }
    return result;
  }

  // --- decode helpers -------------------------------------------------------

  static String? _fieldTypeName(dynamic fieldDesc) {
    if (fieldDesc == null) return null;
    try {
      return fieldDesc.type.name as String; // e.g. 'TYPE_SINT32'
    } catch (_) {
      return fieldDesc.type.toString();
    }
  }

  static bool _isRepeated(dynamic fieldDesc) {
    if (fieldDesc == null) return false;
    try {
      return fieldDesc.label.name == 'LABEL_REPEATED';
    } catch (_) {
      return false;
    }
  }

  static bool _isMessageType(String? t) =>
      t == 'TYPE_MESSAGE' || t == 'TYPE_GROUP';
  static bool _isBytesType(String? t) => t == 'TYPE_BYTES';

  static dynamic _decodeVarintValue(int raw, String? t) {
    switch (t) {
      case 'TYPE_BOOL':
        return raw != 0;
      case 'TYPE_SINT32':
      case 'TYPE_SINT64':
        return _unzigzag(raw);
      default:
        return raw;
    }
  }

  static dynamic _decodeFixed64Value(ByteData bd, String? t) {
    if (t == 'TYPE_DOUBLE') return bd.getFloat64(0, Endian.little);
    // fixed64 / sfixed64 (and schemaless) -> integer bit pattern, LE.
    return bd.getInt64(0, Endian.little);
  }

  static dynamic _decodeFixed32Value(ByteData bd, String? t) {
    if (t == 'TYPE_FLOAT') return bd.getFloat32(0, Endian.little);
    if (t == 'TYPE_SFIXED32') return bd.getInt32(0, Endian.little);
    // fixed32 (unsigned) and schemaless.
    return bd.getUint32(0, Endian.little);
  }

  // Element kind for a packable scalar type, or null if not packable.
  static String? _packedKind(String? t) {
    switch (t) {
      case 'TYPE_INT32':
      case 'TYPE_INT64':
      case 'TYPE_UINT32':
      case 'TYPE_UINT64':
      case 'TYPE_SINT32':
      case 'TYPE_SINT64':
      case 'TYPE_BOOL':
      case 'TYPE_ENUM':
        return 'varint';
      case 'TYPE_FIXED64':
      case 'TYPE_SFIXED64':
      case 'TYPE_DOUBLE':
        return 'fixed64';
      case 'TYPE_FIXED32':
      case 'TYPE_SFIXED32':
      case 'TYPE_FLOAT':
        return 'fixed32';
      default:
        return null;
    }
  }

  static List<dynamic> _decodePacked(List<int> bytes, String? typeName) {
    final kind = _packedKind(typeName);
    final out = <dynamic>[];
    int o = 0;
    if (kind == 'varint') {
      while (o < bytes.length) {
        final v = _readVarint(bytes, o);
        if (v == null) break;
        o = v.nextOffset;
        out.add(_decodeVarintValue(v.value, typeName));
      }
    } else if (kind == 'fixed64') {
      while (o + 8 <= bytes.length) {
        final bd =
            Uint8List.fromList(bytes.sublist(o, o + 8)).buffer.asByteData();
        out.add(_decodeFixed64Value(bd, typeName));
        o += 8;
      }
    } else if (kind == 'fixed32') {
      while (o + 4 <= bytes.length) {
        final bd =
            Uint8List.fromList(bytes.sublist(o, o + 4)).buffer.asByteData();
        out.add(_decodeFixed32Value(bd, typeName));
        o += 4;
      }
    }
    return out;
  }

  // Accumulate a scalar/message value, turning repeated occurrences into a list.
  static void _assign(
      Map<String, dynamic> result, String name, dynamic value, bool forceList) {
    if (result.containsKey(name)) {
      final existing = result[name];
      if (existing is List) {
        existing.add(value);
      } else {
        result[name] = <dynamic>[existing, value];
      }
    } else {
      result[name] = forceList ? <dynamic>[value] : value;
    }
  }

  // Accumulate a packed list of values into the field.
  static void _assignList(
      Map<String, dynamic> result, String name, List<dynamic> vals) {
    final existing = result[name];
    if (existing is List) {
      existing.addAll(vals);
    } else if (result.containsKey(name)) {
      result[name] = <dynamic>[existing, ...vals];
    } else {
      result[name] = vals;
    }
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

  // --- zigzag ---------------------------------------------------------------

  static int _zigzag32(int n) => (n << 1) ^ (n >> 31);
  static int _zigzag64(int n) => (n << 1) ^ (n >> 63);
  static int _unzigzag(int n) => (n >>> 1) ^ -(n & 1);

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
          int val;
          if (p.type == 'bool') {
            val = p.value.toLowerCase() == 'true' ? 1 : 0;
          } else {
            final n = int.tryParse(p.value) ?? 0;
            if (p.type == 'sint32') {
              val = _zigzag32(n);
            } else if (p.type == 'sint64') {
              val = _zigzag64(n);
            } else {
              val = n; // int32/int64/uint32/uint64/enum (negatives -> 10-byte)
            }
          }
          _writeVarint(result, val);
          break;
        case 2: // Length-delimited (string / bytes / message text)
          final bytes = utf8.encode(p.value);
          _writeVarint(result, bytes.length);
          result.addAll(bytes);
          break;
        case 1: // 64-bit fixed (double / fixed64 / sfixed64)
          final bdata = ByteData(8);
          if (p.type == 'double') {
            bdata.setFloat64(0, double.tryParse(p.value) ?? 0.0, Endian.little);
          } else {
            bdata.setInt64(0, int.tryParse(p.value) ?? 0, Endian.little);
          }
          result.addAll(bdata.buffer.asUint8List());
          break;
        case 5: // 32-bit fixed (float / fixed32 / sfixed32)
          final bdata = ByteData(4);
          if (p.type == 'float') {
            bdata.setFloat32(0, double.tryParse(p.value) ?? 0.0, Endian.little);
          } else {
            bdata.setInt32(0, int.tryParse(p.value) ?? 0, Endian.little);
          }
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

  // Little-endian base-128 varint. Handles negative (int32/int64) values by
  // treating them as unsigned 64-bit -> a full 10-byte encoding.
  static void _writeVarint(List<int> buffer, int value) {
    while ((value & ~0x7F) != 0) {
      buffer.add((value & 0x7F) | 0x80);
      value >>>= 7;
    }
    buffer.add(value & 0x7F);
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
