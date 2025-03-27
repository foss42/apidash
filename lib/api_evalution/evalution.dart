import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// void main() => runApp(AIEvaluationApp());

// class AIEvaluationApp extends StatelessWidget {
//   const AIEvaluationApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AI API Evaluator',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: Colors.grey[50],
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: EvaluationDashboard(),
//     );
//   }
// }

class EvaluationDashboard extends StatefulWidget {
  const EvaluationDashboard({super.key});
  @override
  State<EvaluationDashboard> createState() => _EvaluationDashboardState();
}

class _EvaluationDashboardState extends State<EvaluationDashboard> {
  int _selectedIndex = 0;
  String? _selectedModel; // Store selected model name

  final List<String> _availableModels = [
    "falcon-7b",
    "Llama-3.2-3B"
  ]; // Add available models
  final List<ModelResult> _results = [];
  bool _isLoading = false;
  Future<void> fetchModelResults() async {
    if (_selectedModel == null) {
      // print("No model selected!");
      return;
    }

    final url = Uri.parse(
        "http://localhost:8000/evaluate/$_selectedModel"); // Use selected model

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("Received Data: $data");

        setState(() => _isLoading = true);
        {
          try {
            _results.clear();
            for (var item in data) {
              _results.add(ModelResult(
                modelName: item["model_name"],
                scores: Map<String, double>.from(item["scores"]),
                latency: item["latency"].toDouble(),
                cost: item["cost"].toDouble(),
                timestamp: DateTime.parse(item["timestamp"]),
              ));
            }
          } finally {
            setState(() => _isLoading = false);
          }
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI API Evaluator'),
        actions: [
          // Model selection dropdown in app bar
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DropdownButton<String>(
              value: _selectedModel,
              hint: Text("Select Model"),
              items: _availableModels.map((String model) {
                return DropdownMenuItem<String>(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchModelResults,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildBody(), // Use your dashboard layout
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startNewEvaluation,
        icon: Icon(Icons.add),
        label: Text("New Evaluation"),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.compare), label: 'Compare'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_results.isEmpty) {
      return Center(child: Text("Select a model and evaluate"));
    }
    switch (_selectedIndex) {
      case 0:
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Model Performance Overview',
                  style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16),
              _buildMetricCards(),
              SizedBox(height: 24),
              _buildRadarChart(),
              SizedBox(height: 24),
              _buildRecentEvaluations(),
            ],
          ),
        );
      case 1:
        return Center(child: Text('Detailed Reports'));
      case 2:
        return Center(child: Text('Model Comparison'));
      default:
        return Container();
    }
  }

  Widget _buildMetricCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard("Best Performing Model", _selectedModel ?? "N/A",
            Icons.emoji_events, Colors.amber),
        _buildMetricCard("Average BERT-4", "0.84", Icons.score, Colors.blue),
        _buildMetricCard("Fastest Model", _selectedModel ?? "N/A", Icons.speed,
            Colors.green),
        _buildMetricCard("Cost Efficiency", _selectedModel ?? "N/A",
            Icons.attach_money, Colors.purple),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

// Replace the _buildRadarChart and related methods with this:

  Widget _buildRadarChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Show empty state if no results
            if (_results.isEmpty)
              Container(
                height: 300,
                alignment: Alignment.center,
                child: Text(
                  'No evaluation data available\nSelect a model and evaluate',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            else
              SizedBox(
                height: 300,
                child: RadarChart(
                  RadarChartData(
                    dataSets: _createRadarData(),
                    radarBackgroundColor: Colors.transparent,
                    radarBorderData: const BorderSide(color: Colors.grey),
                    titlePositionPercentageOffset: 0.2,
                    titleTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    tickCount: 5,
                    ticksTextStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                    radarShape: RadarShape.polygon,
                    getTitle: (index, angle) {
                      final metrics = [
                        'BLEU-4',
                        'ROUGE-L',
                        'BERTScore',
                        'METEOR',
                        'CIDEr',
                        'SPICE',
                      ];
                      return RadarChartTitle(
                        text: metrics[index],
                        angle: angle,
                      );
                    },
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 500),
                ),
              ),

            // Only show legend if we have data
            if (_results.isNotEmpty) _buildRadarLegend(),
          ],
        ),
      ),
    );
  }

  List<RadarDataSet> _createRadarData() {
    if (_results.isEmpty) return [];
    return [
      RadarDataSet(
        dataEntries: [
          RadarEntry(value: _results[0].scores["BLEU-4"] ?? 0.0),
          RadarEntry(value: _results[0].scores["ROUGE-L"] ?? 0.0),
          RadarEntry(value: _results[0].scores["BERTScore"] ?? 0.0),
          RadarEntry(value: _results[0].scores["METEOR"] ?? 0.0),
          // RadarEntry(value: _results[0].scores["CIDEr"] ?? 0.0),
          // RadarEntry(value: _results[0].scores["SPICE"] ?? 0.0),
        ],
        fillColor: Colors.deepPurple.withOpacity(0.3),
        borderColor: Colors.deepPurple,
        entryRadius: 2,
        borderWidth: 2,
      ),
      if (_results.length > 1)
        RadarDataSet(
          dataEntries: [
            RadarEntry(value: _results[1].scores["BLEU-4"] ?? 0.0),
            RadarEntry(value: _results[1].scores["ROUGE-L"] ?? 0.0),
            RadarEntry(value: _results[1].scores["BERTScore"] ?? 0.0),
            RadarEntry(value: _results[1].scores["METEOR"] ?? 0.0),
            // RadarEntry(value: _results[1].scores["CIDEr"] ?? 0.0),
            // RadarEntry(value: _results[1].scores["SPICE"] ?? 0.0),
          ],
          fillColor: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue,
          entryRadius: 2,
          borderWidth: 2,
        ),
    ];
  }

  Widget _buildRadarLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First model legend (always show if we have at least 1 result)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                color: Colors.deepPurple,
              ),
              const SizedBox(width: 4),
              Text(_results[0].modelName),
            ],
          ),
        ),

        // Second model legend (only show if we have 2+ results)
        if (_results.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(_results[1].modelName),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRecentEvaluations() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Evaluations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            DataTable(
              columns: [
                DataColumn(label: Text('Model')),
                DataColumn(label: Text('BLEU-4'), numeric: true),
                DataColumn(label: Text('ROUGE-L'), numeric: true),
                DataColumn(label: Text('BERTScore'), numeric: true),
                DataColumn(label: Text('METEOR'), numeric: true),
                DataColumn(label: Text('Time')),
              ],
              rows: _results
                  .map((result) => DataRow(
                        cells: [
                          DataCell(Text(result.modelName)),
                          DataCell(Text(
                              result.scores["BLEU-4"]!.toStringAsFixed(2))),
                          DataCell(Text(
                              result.scores["ROUGE-L"]!.toStringAsFixed(2))),
                          DataCell(Text(
                              result.scores["BERTScore"]!.toStringAsFixed(2))),
                          DataCell(Text(
                              result.scores["METEOR"]!.toStringAsFixed(2))),
                          DataCell(Text("${result.latency/1000} sec")),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _startNewEvaluation() {
    // Navigation to new evaluation screen
  }
}

class ModelResult {
  final String modelName;
  final Map<String, double> scores;
  final double latency; // in ms
  final double cost; // in dollars
  final DateTime timestamp;

  ModelResult({
    required this.modelName,
    required this.scores,
    required this.latency,
    required this.cost,
    required this.timestamp,
  });
}

class LinearScore {
  final String metric;
  final double value;

  LinearScore(this.metric, this.value);
}
