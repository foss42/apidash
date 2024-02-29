import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'error_message.dart';
import '../consts.dart';

class CsvPreviewer extends StatelessWidget {
  const CsvPreviewer({super.key, required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    try {
      final List<List<dynamic>> csvData =
          const CsvToListConverter().convert(body, eol: '\n');
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: csvData[0]
                .map(
                  (item) => DataColumn(
                    label: Text(
                      item.toString(),
                    ),
                  ),
                )
                .toList(),
            rows: csvData
                .skip(1)
                .map(
                  (csvrow) => DataRow(
                    cells: csvrow
                        .map(
                          (csvItem) => DataCell(
                            Text(
                              csvItem.toString(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } catch (e) {
      return const ErrorMessage(message: kCsvError);
    }
  }
}
