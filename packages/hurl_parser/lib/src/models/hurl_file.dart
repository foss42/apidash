// Models for representing a Hurl file structure
import 'package:hurl_parser/hurl_parser.dart';

class HurlFile {
  final List<Entry> entries;

  HurlFile({required this.entries});

  factory HurlFile.fromJson(Map<String, dynamic> json) {
    return HurlFile(
      entries: (json['entries'] as List)
          .map((e) => Entry.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'entries': entries.map((e) => e.toJson()).toList(),
  };
}
