import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Auto Render Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('JSON Auto Render Demo')),
        body: JSONDataTable(),
      ),
    );
  }
}

class JSONDataTable extends StatelessWidget {
  const JSONDataTable({Key? key}) : super(key: key);

  // Load JSON data from assets
  Future<List<Map<String, dynamic>>> _loadData() async {
    String jsonString = await rootBundle.loadString('sample.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return Center(child: Text('No data available'));

        List<Map<String, dynamic>> data = snapshot.data!;
        List<String> columns = data.first.keys.toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: DataTable(
                headingRowHeight: 56,
                dataRowHeight: 56,
                columns: columns.map((col) {
                  return DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text(
                        col,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
                rows: data.map((row) {
                  return DataRow(
                    cells: columns.map((col) {
                      return DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            row[col]?.toString() ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}