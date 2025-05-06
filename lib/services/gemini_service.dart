import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_medical_report_summry/models/report.dart';
import 'package:my_medical_report_summry/services/report_service.dart';

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
                      'Analyze this medical report. Extract the hemoglobin level, provide a summary of the findings, and suggest health recommendations. Format the response as: Hemoglobin: X g/dL\nSummary: ...\nSuggestions: ...',
                },
              ],
            },
          ],
        },
        queryParameters: {'key': apiKey},
      );

      // Parse response
      final geminiData = response.data['candidates']?[0]['content']['parts'][0]['text'];
      final hemoglobinMatch = RegExp(r'Hemoglobin: (\d+\.\d)').firstMatch(geminiData);
      final summaryMatch = RegExp(r'Summary: (.*?)\nSuggestions:').firstMatch(geminiData);
      final suggestionsMatch = RegExp(r'Suggestions: (.*)').firstMatch(geminiData);
      final date = RegExp(r'Date: (.*)').firstMatch(geminiData);

      var id = 0;
      await loadReports().then((value) {
        id = value[value.length-1].id;
      });
      return {
        'id': id + 2,
        'summary': summaryMatch?.group(1) ?? 'Analysis of ${file.name}: All levels normal.',
        'title': summaryMatch?.group(1) ?? 'Analysis of ${file.name}: All levels normal.',
        'suggestions': suggestionsMatch?.group(1) ?? 'Continue healthy lifestyle.',
        'date': date?.group(1) ?? '',
        'metrics': {
          'hemoglobin': double.tryParse(hemoglobinMatch?.group(1) ?? '13.5') ?? 13.5,
          // Add other metrics as extracted
          'fasting_glucose': 100 + (DateTime.now().millisecond % 20), // Mock additional metric
        },
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
    return jsonData.map((json) => Report.fromJson(json)).toList();
  }

  // Add a new report (in-memory for POC)
  @override
  Future<List<Report>> addReport(Report newReport) async {
    final reports = await loadReports();
    reports.add(newReport);
    return reports;
  }
}
