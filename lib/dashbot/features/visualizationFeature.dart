import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../services/dashbot_service.dart';
import 'package:apidash/models/request_model.dart';

class DocumentationFeature {
  final DashBotService _service;

  DocumentationFeature(this._service);

  Future<String> generateApiDoc({
    required RequestModel? requestModel,
    required dynamic responseModel,
    required String selectedAI,
  }) async {
    if (requestModel == null) {
      return "No recent API requests found for documentation.";
    }

    final method = requestModel.httpRequestModel?.method
            .toString()
            .split('.')
            .last
            .toUpperCase() ??
        "GET";
    final endpoint = requestModel.httpRequestModel?.url ?? "Unknown Endpoint";
    final headers = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
    final parameters = requestModel.httpRequestModel?.enabledParamsMap ?? {};
    final body = requestModel.httpRequestModel?.body;

    final prompt = """
# API Documentation

## Overview
This document provides a detailed specification of the API request, including its endpoint, method, parameters, headers, request body, and expected response format.

## API Endpoint
- **URL:** `$endpoint`
- **Method:** `$method`

## Request Details
- **Headers:** ${headers.isNotEmpty ? jsonEncode(headers) : "No headers"}
- **Parameters:** ${parameters.isNotEmpty ? jsonEncode(parameters) : "No parameters"}
- **Request Body:** ${body ?? "Empty body"}

## Expected Response
Provide a structured and detailed documentation explaining:
1. The expected response format
2. The meaning of each field in the response
3. Error codes and their meanings (if applicable)
4. Examples of successful and failed responses
5. Additional usage guidelines

Ensure the documentation is **well-formatted** and **easy to understand**.
""";

    // Get AI-generated response
    final aiResponse = await _service.generateResponse(prompt, selectedAI);

    // Save AI response to a PDF
    // final pdfPath = await saveToPDF(aiResponse);

    return aiResponse;
  }

  Future<String> saveToPDF(String documentation) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => _formatMarkdown(documentation),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/api_documentation.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // print("✅ PDF saved at: $filePath");
    return filePath; // Return file path
  }

  List<pw.Widget> _formatMarkdown(String text) {
    List<pw.Widget> widgets = [];
    List<String> lines = text.split("\n");

    for (String line in lines) {
      if (line.startsWith("# ")) {
        widgets.add(pw.Text(line.replaceFirst("# ", ""),
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)));
      } else if (line.startsWith("## ")) {
        widgets.add(pw.Text(line.replaceFirst("## ", ""),
            style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue)));
      } else if (line.startsWith("- **")) {
        widgets.add(pw.Bullet(
            text: line.replaceFirst("- **", ""),
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)));
      } else if (line.startsWith("* ")) {
        widgets.add(pw.Bullet(
            text: line.replaceFirst("* ", ""),
            style: pw.TextStyle(fontSize: 12)));
      } else if (line.startsWith("```json")) {
        widgets.add(_jsonBlock()); // JSON Block Styling
      } else if (line.startsWith("```")) {
        continue; // Ignore closing code block indicators
      } else if (line.trim().startsWith("{")) {
        widgets.add(_jsonBlock(line)); // JSON Block Styling
      } else {
        widgets.add(pw.Text(line, style: pw.TextStyle(fontSize: 12)));
      }
      widgets.add(pw.SizedBox(height: 5)); // Add spacing
    }

    return widgets;
  }

  pw.Container _jsonBlock([String jsonText = ""]) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Text(jsonText,
          style: pw.TextStyle(
            fontSize: 10,
          )),
    );
  }
}
