/*
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/report.dart';

// Service for managing reports
class ReportService {
  // Load static reports from JSON
  Future<List<Report>> loadReports() async {
    final String jsonString = await rootBundle.loadString('assets/reports.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => Report.fromJson(json)).toList();
  }

  // Add a new report (in-memory for POC)
  Future<List<Report>> addReport(Report newReport) async {
    final reports = await loadReports();
    reports.add(newReport);
    return reports;
  }
}*/
import 'package:file_picker/file_picker.dart';

import '../models/report.dart';

abstract class ReportService {
  Future<Map<String, dynamic>> analyzeReport(PlatformFile file);

  Future<List<Report>> loadReports();

  Future<List<Report>> addReport(Report newReport);
}
