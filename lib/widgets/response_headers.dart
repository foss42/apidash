import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';
import 'button_copy.dart';
import 'table_map.dart';

class ResponseHeadersHeader extends StatelessWidget {
  const ResponseHeadersHeader({
    super.key,
    required this.map,
    required this.name,
  });

  final Map map;
  final String name;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return SizedBox(
      height: kHeaderHeight*ds.scaleFactor,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$name (${map.length} $kLabelItems)",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (map.isNotEmpty)
            CopyButton(
              toCopy: kJsonEncoder.convert(map),
            ),
        ],
      ),
    );
  }
}

class ResponseHeaders extends StatelessWidget {
  const ResponseHeaders({
    super.key,
    required this.responseHeaders,
    required this.requestHeaders,
  });

  final Map responseHeaders;
  final Map requestHeaders;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return Padding(
      padding: kPh20v5,
      child: ListView(
        children: [
          ResponseHeadersHeader(
            map: responseHeaders,
            name: kLabelResponseHeaders,
          ),
          if (responseHeaders.isNotEmpty) kVSpacer5(ds.scaleFactor),
          if (responseHeaders.isNotEmpty)
            MapTable(
              map: responseHeaders,
              colNames: kHeaderRow,
              firstColumnHeaderCase: true,
            ),
          kVSpacer10(ds.scaleFactor),
          ResponseHeadersHeader(
            map: requestHeaders,
            name: kLabelRequestHeaders,
          ),
          if (requestHeaders.isNotEmpty) kVSpacer5(ds.scaleFactor),
          if (requestHeaders.isNotEmpty)
            MapTable(
              map: requestHeaders,
              colNames: kHeaderRow,
              firstColumnHeaderCase: true,
            ),
        ],
      ),
    );
  }
}
