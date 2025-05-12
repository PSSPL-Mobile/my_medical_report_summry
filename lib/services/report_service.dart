import 'package:file_picker/file_picker.dart';

import '../models/report.dart';

/// Name : ReportService
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Abstract class defining the contract for report-related services.Provides methods for analyzing, loading, saving, and generating tips from reports.
abstract class ReportService {
  // Analyzes a PDF report file and extracts relevant metrics.
  // [file] - The PDF file selected by the user.
  // Returns a map containing extracted metrics (e.g., hemoglobin, blood pressure).
  Future<Map<String, dynamic>> analyzeReport(PlatformFile file);

  // Loads the list of stored reports.
  // Returns a list of Report objects.
  Future<List<Report>> loadReports();

  // Adds a new report to the existing list of reports.
  // [newReport] - The new report to add.
  // Returns the updated list of reports.
  Future<List<Report>> addReport(Report newReport);

  // Loads reports from shared preferences.
  // Returns a list of reports or null if none are found.
  Future<List<Report>?> loadReportsFromPrefs();

  // Saves a report to shared preferences.
  // [report] - The report to save.
  Future<void> saveReportsToPrefs(Report report);

  // Generates health tips based on a given prompt.
  // [prompt] - The prompt used to generate tips (e.g., based on report metrics).
  // Returns a list of generated health tips as strings.
  Future<List<String>> generateTips(String prompt);
}
