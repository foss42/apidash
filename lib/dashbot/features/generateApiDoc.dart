// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:fl_chart/fl_chart.dart';
import '../services/dashbot_service.dart';
import 'package:apidash/models/request_model.dart';

class VisualizationFeature {
  final DashBotService _service;

  VisualizationFeature(this._service);

  Future<String> generateApiPlots({
    required RequestModel? requestModel,
    required dynamic responseModel,
    required String selectedAI,
    required BuildContext context,
  }) async {
    if (requestModel == null || responseModel == null) {
      return "No recent API response available for visualization.";
    }

    final prompt = """
Extract the relevant data from the API response to plot a graph. Identify the key X and Y axis values and labels. Ensure:
- X-axis represents a logical progression (time, categories, indexes, etc.).
- Y-axis represents numerical values.
- Provide labels for both axes.
- Return the structured data in JSON format like:

{
  "xAxis": ["Label1", "Label2", "Label3"],
  "yAxis": [10, 20, 30],
  "xLabel": "Time",
  "yLabel": "Value"
}

Use the response data below to determine the best fields for visualization:
$responseModel
""";

    try {
      final aiResponse = await _service.generateResponse(prompt, selectedAI);

      // Debug: Log the raw response
      // print("Raw AI response: $aiResponse");

      // Extract JSON from the AI response
      // This handles cases where the AI might return explanatory text along with JSON
      final jsonRegExp = RegExp(r'({[\s\S]*})');
      final match = jsonRegExp.firstMatch(aiResponse);

      if (match == null) {
        return "⚠️ Could not find JSON in AI response.";
      }

      final jsonString = match.group(1)?.trim();
      if (jsonString == null || jsonString.isEmpty) {
        return "⚠️ Extracted JSON is empty.";
      }

      // Clean the JSON string - sometimes AI adds backticks or code formatting
      final cleanJsonString =
          jsonString.replaceAll("```json", "").replaceAll("```", "").trim();

      // print("Cleaned JSON string: $cleanJsonString");

      final extractedData = jsonDecode(cleanJsonString);

      if (extractedData is! Map ||
          !extractedData.containsKey('xAxis') ||
          !extractedData.containsKey('yAxis') ||
          !extractedData.containsKey('xLabel') ||
          !extractedData.containsKey('yLabel')) {
        return "⚠️ AI response is missing required fields (xAxis, yAxis, xLabel, yLabel).";
      }

      final List<dynamic> xAxisRaw = extractedData['xAxis'];
      final List<dynamic> yAxisRaw = extractedData['yAxis'];

      // Convert all elements to string for xAxis and num for yAxis
      final List<String> xAxis = xAxisRaw.map((e) => e.toString()).toList();

      // Handle null values in yAxis by converting them to 0
      final List<num> yAxis = yAxisRaw.map((e) {
        if (e == null) return 0;
        return num.tryParse(e.toString()) ?? 0;
      }).toList();

      final String xLabel = extractedData['xLabel'].toString();
      final String yLabel = extractedData['yLabel'].toString();

      if (xAxis.isEmpty || yAxis.isEmpty) {
        return "⚠️ Extracted data contains empty axes.";
      }

      if (xAxis.length != yAxis.length) {
        // print(
        //     "⚠️ Warning: X and Y axes have different lengths. X: ${xAxis.length}, Y: ${yAxis.length}");
      }

      // Navigate to visualization page instead of showing dialog
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VisualizationPage(
              xAxis: xAxis,
              yAxis: yAxis,
              xLabel: xLabel,
              yLabel: yLabel,
            ),
          ),
        );
        return "✅ Visualization generated successfully!";
      } else {
        return "⚠️ Context is not mounted, cannot show visualization.";
      }
    // ignore: unused_catch_stack
    } catch (e, stackTrace) {
      // More detailed error message with stack trace
      // print("Error details: $e");
      // print("Stack trace: $stackTrace");
      return "⚠️ Failed to parse AI response for visualization: ${e.toString()}";
    }
  }

  int min(int a, int b) => a < b ? a : b;
  int max(int a, int b) => a > b ? a : b;
}

// New dedicated page for visualization
class VisualizationPage extends StatelessWidget {
  final List<String> xAxis;
  final List<num> yAxis;
  final String xLabel;
  final String yLabel;

  const VisualizationPage({
    Key? key,
    required this.xAxis,
    required this.yAxis,
    required this.xLabel,
    required this.yLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Find min and max values for better scaling
    final nonZeroValues = yAxis.where((value) => value != 0).toList();
    final minY = nonZeroValues.isEmpty
        ? 0.0
        : nonZeroValues.reduce((a, b) => a < b ? a : b).toDouble();

    final maxY =
        yAxis.isEmpty ? 10.0 : yAxis.reduce((a, b) => a > b ? a : b).toDouble();

    final padding = maxY == 0 ? 1.0 : (maxY - minY) * 0.1; // 10% padding

    return Scaffold(
      appBar: AppBar(
        title: const Text("API Data Visualization"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _savePdf(context),
            tooltip: "Export to PDF",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "X-Axis: $xLabel, Y-Axis: $yLabel",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval:
                          (maxY - minY) / 5 == 0 ? 1.0 : (maxY - minY) / 5,
                      verticalInterval: 1,
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                          interval: (maxY - minY) / 5 == 0
                              ? 1.0
                              : (maxY - minY) / 5,
                        ),
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            yLabel,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 &&
                                index < xAxis.length &&
                                index % max(1, (xAxis.length ~/ 5)) == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  xAxis[index],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          interval: 1,
                        ),
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            xLabel,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black12),
                    ),
                    minX: 0,
                    maxX: (xAxis.length - 1).toDouble(),
                    minY: minY - padding,
                    maxY: maxY + padding,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          min(xAxis.length, yAxis.length),
                          (index) =>
                              FlSpot(index.toDouble(), yAxis[index].toDouble()),
                        ),
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.blue,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue,
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          // ignore: deprecated_member_use
                          color: Colors.blue.withOpacity(0.2),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            final int index = barSpot.x.toInt();
                            return LineTooltipItem(
                              '${xAxis[index]}: ${barSpot.y.toStringAsFixed(2)}',
                              const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: min(xAxis.length, yAxis.length),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(xAxis[index]),
                        trailing: Text(
                          yAxis[index] == 0
                              ? "N/A"
                              : yAxis[index].toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;
  int max(int a, int b) => a > b ? a : b;

  Future<void> _savePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context pdfContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('API Data Visualization',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('X-Axis: $xLabel, Y-Axis: $yLabel'),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('X Value',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Y Value',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...List.generate(
                    min(xAxis.length, yAxis.length),
                    (index) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(xAxis[index]),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(yAxis[index] == 0
                              ? "N/A"
                              : yAxis[index].toString()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                  'Generated on ${DateTime.now().toString().split('.')[0]}'),
            ],
          );
        },
      ),
    );

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          '${dir.path}/api_visualization_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to: ${file.path}'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }

      // print("PDF saved to: ${file.path}");
    } catch (e) {
      // print("Failed to save PDF: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}