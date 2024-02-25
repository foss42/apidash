import 'dart:convert';
import 'dart:io';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Imports requests from a HAR Archive file
///
class ImportRequestsFromHARDialog extends ConsumerStatefulWidget {
  const ImportRequestsFromHARDialog({required this.harFile, super.key});

  /// File instance of selected HAR file
  final File harFile;

  @override
  ConsumerState<ImportRequestsFromHARDialog> createState() =>
      _ImportRequestsFromHARDialogState();
}

class _ImportRequestsFromHARDialogState
    extends ConsumerState<ImportRequestsFromHARDialog> {
  /// Stores HAR content into JSON to avoid multiple [jsonDecode]
  Map? harJSON;

  @override
  initState() {
    extractHARFile();
    super.initState();
  }

  /// Sets [widget.harFile] to the provided path and extracts contents
  /// into [harJSON]
  Future<void> extractHARFile() async {
    final string = await widget.harFile.readAsString();

    setState(() {
      harJSON = jsonDecode(string);
    });
  }

  /// Returns length of API Request Entities from HAR Archive
  int harListLength() {
    if (harJSON == null) return 0;

    return (harJSON!['log']['entries'] as List).length;
  }

  /// Reusable [NameValueModel] generator for parsing
  /// headers and query params from HAR file.
  List<NameValueModel> generateNameValueList(List jsonList) {
    List<NameValueModel> res = [];

    for (Map<String, dynamic> element in jsonList) {
      res.add(NameValueModel.fromJson(element));
    }

    return res;
  }

  /// Returns widget with HAR API Entry at [index]
  Widget generateHARTile(context, index) {
    if (harJSON == null) return Container();

    final String url = harJSON!['log']['entries'][index]['request']['url'];
    final List headersJSON =
        harJSON!['log']['entries'][index]['request']['headers'] as List;

    final List paramsJSON =
        harJSON!['log']['entries'][index]['request']['queryString'] as List;

    final String methodString =
        harJSON!['log']['entries'][index]['request']['method'];

    HTTPVerb method = HTTPVerb.values.firstWhere(
      (element) => element.name == methodString.toLowerCase(),
    );
    final id = const Uuid().v1();

    final requestModel = RequestModel(
      id: id,
      method: method,
      url: url,
      requestHeaders: generateNameValueList(headersJSON),
      requestParams: generateNameValueList(paramsJSON),
    );

    return SidebarRequestCard(
      id: id,
      method: requestModel.method,
      url: requestModel.url,
      onTap: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .addNewRequest(requestModel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return AlertDialog.adaptive(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kVSpacer20,
          Column(
            children: [
              Text(
                'Tap the tile to import its contents into your workspace.',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              kVSpacer20,
              SizedBox(
                height: size.height * 0.56,
                width: size.width * 0.4,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: harListLength(),
                  itemBuilder: (BuildContext context, int index) =>
                      generateHARTile(context, index),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ),
            ],
          ),
          kVSpacer20,
        ],
      ),
    );
  }
}
