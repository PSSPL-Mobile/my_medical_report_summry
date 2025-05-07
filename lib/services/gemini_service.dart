import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:my_medical_report_summry/models/report.dart';
import 'package:my_medical_report_summry/services/report_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Gemini AI service for analyzing medical reports
class GeminiService implements ReportService {
  final Dio _dio = Dio();

  // Analyze a report file using Google AI Studio Gemini API
  @override
  Future<Map<String, dynamic>> analyzeReport(PlatformFile file) async {
    try {
      // Real Gemini API integration (Google AI Studio)
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'AIzaSyBd-CXnJYyIwGXm9e4qQhz3RprnFPGww5U';
      const endpoint = 'https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-001:generateContent';

      // Read file as bytes and encode to base64 (for small PDFs)
      // final fileBytes = await file.readStream?.toList();
      // Handle file reading based on platform
      late List<int> fileBytes;
      if (kIsWeb) {
        // On web, use file.bytes (readStream is typically null on web)
        fileBytes = file.bytes ?? [];
        if (fileBytes.isEmpty) {
          throw Exception('File bytes are empty on web.');
        }
      } else {
        // On mobile, check if readStream is available
        if (file.readStream != null) {
          final streamData = await file.readStream!.toList();
          fileBytes = streamData.expand((x) => x).toList();
        } else if (file.path != null) {
          // Fallback to reading from file path on mobile
          fileBytes = await File(file.path!).readAsBytes();
        } else {
          throw Exception('Unable to read file: No readStream or path available.');
        }
      }

      final base64Data = base64Encode(fileBytes);

      final response = await _dio.post(
        endpoint,
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'inlineData': {
                    'data': base64Data,
                    'mimeType': file.extension == 'pdf' ? 'application/pdf' : 'image/${file.extension}',
                  },
                },
                {
                  'text':
                      'Analyze this medical report. Extract the following medical metrics if available: hemoglobin (or Hgb, Hb), blood pressure (or BP), bp. (or B.P.), and sugar (e.g., fasting glucose, blood sugar), with their values and units. Provide a summary of the findings, suggest health recommendations, and include the date if available. Format the response as:\n**Metrics:**\nHemoglobin: Value Unit\nBlood Pressure: Value Unit\nbp.: Value Unit\nSugar: Value Unit\n\n**Summary:**\n...\n\n**Suggestions:**\n...\n\n**Date:** yyyy-MM-dd',
                },
              ],
            },
          ],
        },
        queryParameters: {'key': apiKey},
      );

      // Parse response
      final geminiData = response.data['candidates']?[0]['content']['parts'][0]['text'];
      if (geminiData == null) {
        throw Exception('Invalid API response format: geminiData is null');
      }

      // Log the geminiData for debugging
      if (kDebugMode) {
        print('geminiData: $geminiData');
      }

      // Parse metrics section
      final metricsMatch = RegExp(
              r'\*\*Metrics:\*\*\n(.*?)(?=\n\n\*\*Summary:\*\*|\n\n\*\*Suggestions:\*\*|\n\n\*\*Date:\*\*|$)',
              dotAll: true)
          .firstMatch(geminiData);
      // Parse metrics section
      final metricsSection = metricsMatch?.group(1) ?? '';

      // Parse specific metrics from the metrics section
      final metrics = <String, dynamic>{};

      // Extract Hemoglobin (e.g., "Hemoglobin: 9.9 g/dL", "Hgb: 9.9 g/dL", "Hb: 14.2 g/dL")
      final hemoglobinMatch = RegExp(r'Hemoglobin:\s*([^\n]+)', caseSensitive: false).firstMatch(metricsSection);
      if (hemoglobinMatch != null) {
        final hemoglobinValue = hemoglobinMatch.group(1)?.trim();
        // Extract just the first numeric value (int or float)
        final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(hemoglobinValue!);

        if (numericMatch != null) {
          final numericValue = double.parse(numericMatch.group(0)!); // parsed as double
          metrics['hemoglobin'] = "$numericValue g/dL";
        }
      }

      // Blood Pressure / BP
      final bpMatch = RegExp(r'(?:Blood Pressure|BP):\s*([^\n]+)', caseSensitive: false).firstMatch(metricsSection);
      if (bpMatch != null) {
        final bpValue = bpMatch.group(1)?.trim();
        // Extract just the first numeric value (int or float)
        final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(bpValue!);

        if (numericMatch != null) {
          final numericValue = double.parse(numericMatch.group(0)!); // parsed as double
          metrics['blood_pressure'] = '$numericValue mmHg';
        }
      }

      // Sugar
      final sugarMatch = RegExp(r'Sugar[^\n:]*:\s*([^\n]+)', caseSensitive: false).firstMatch(metricsSection);
      if (sugarMatch != null) {
        final sugarValue = sugarMatch.group(1)?.trim();

        // Extract just the first numeric value (int or float)
        final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(sugarValue!);

        if (numericMatch != null) {
          final numericValue = double.parse(numericMatch.group(0)!); // parsed as double
          metrics['sugar'] = '$numericValue mg/dL';
        }
      }

      // Parse summary, suggestions, and date
      final summaryMatch =
          RegExp(r'\*\*Summary:\*\*\n(.*?)(?=\n\n\*\*Suggestions:\*\*|\n\n\*\*Date:\*\*|$)', dotAll: true)
              .firstMatch(geminiData);
      final suggestionsMatch =
          RegExp(r'\*\*Suggestions:\*\*\n(.*?)(?=\n\n\*\*Date:\*\*|$)', dotAll: true).firstMatch(geminiData);
      // Extract the date in yyyy-MM-dd format
      final dateMatch = RegExp(r'\*\*Date:\*\*\s*(\d{4}-\d{2}-\d{2})').firstMatch(geminiData);
      final date = dateMatch?.group(1)?.trim() ?? DateTime.now().toIso8601String();

      int? id = 0;
      await loadReportsFromPrefs().then(
        (value) {
          if (value != null) {
            id = value[value.length - 1].id;
          } else {
            id = 16;
          }
        },
      );

      // Format date to dd/MM/yyyy
      final dateFormatter = DateFormat('yyyy-MM-dd');
      String formattedDate = dateFormatter.format(DateTime.now());

      return {
        'id': id! + 2,
        'summary': summaryMatch?.group(1)?.trim() ?? 'Analysis of ${file.name}: All levels normal.',
        'title': summaryMatch?.group(1)?.trim() ?? 'Analysis of ${file.name}',
        'suggestions': suggestionsMatch?.group(1)?.trim() ?? 'Continue healthy lifestyle.',
        'date': /*date*/ formattedDate,
        'metrics': metrics
      };
    } catch (e) {
      // Handle errors (e.g., API failure, file issues)
      if (kDebugMode) {
        print('Error analyzing report: $e');
      }
      return {
        'summary': 'Error analyzing ${file.name}.',
        'suggestions': 'Please try uploading again.',
        'metrics': {'hemoglobin': 13.5},
      };
    }
  }

  // Load static reports from JSON
  @override
  Future<List<Report>> loadReports() async {
    final String jsonString = await rootBundle.loadString('assets/reports.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    var filterReportList = jsonData.map((json) => Report.fromJson(json)).toList();
    await loadReportsFromPrefs().then(
      (value) {
        if (value != null) {
          filterReportList.addAll(value);
        }
      },
    );
    return filterReportList;
  }

  // Add a new report (in-memory for POC)
  @override
  Future<List<Report>> addReport(Report newReport) async {
    final reports = await loadReports();
    reports.add(newReport);
    return reports;
  }

  @override
  Future<List<Report>?> loadReportsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? reportsJson = prefs.getString('reports');
    if (reportsJson != null) {
      final List<dynamic> reportsData = jsonDecode(reportsJson);
      return reportsData.map((data) => Report.fromJson(data)).toList();
    }
    return null;
  }

  @override
  Future<void> saveReportsToPrefs(Report report) async {
    final prefs = await SharedPreferences.getInstance();
    loadReportsFromPrefs().then(
      (value) async {
        var reportsJson = jsonEncode(value?.map((report) => report.toJson()).toList());
        if (value == null) {
          List<Report> reportList = [];
          reportList.add(report);
          reportsJson = jsonEncode(reportList.map((report) => report.toJson()).toList());
        } else {
          value.add(report);
          reportsJson = jsonEncode(value.map((report) => report.toJson()).toList());
        }
        await prefs.setString('reports', reportsJson);
      },
    );
  }
}
