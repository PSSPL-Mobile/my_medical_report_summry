// Import necessary packages for file picking, UI, state management, date formatting, and app-specific models/services.
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_medical_report_summry/blocs/home_event.dart';
import 'package:my_medical_report_summry/blocs/home_state.dart';
import '../models/report.dart';
import '../services/report_service.dart';

/// Name : HomeScreenBloc
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Bloc to manage HomeScreen state and events.
class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  // Service to handle report-related operations.
  final ReportService reportService;
  // In-memory list to store reports.
  List<Report> _reports = [];

  // Constructor initializing the bloc with ReportService and initial state.
  HomeScreenBloc(this.reportService) : super(HomeInitial()) {
    on<HomeLoadReports>(_onLoadReports); // Register event handler.
  }

  // Handle HomeLoadReports event to load reports, graph data, and tips.
  Future<void> _onLoadReports(HomeLoadReports event, Emitter<HomeScreenState> emit) async {
    emit(HomeLoading()); // Show loading state.
    try {
      _reports = await reportService.loadReports(); // Load reports.
      List<Map<String, dynamic>> hemoglobinData = await loadGraphData(_reports); // Load graph data.
      List<String> tips = await fetchTips(_reports); // Fetch health tips.
      emit(HomeLoaded(reports: _reports, hemoglobinData: hemoglobinData, tips: tips)); // Emit loaded state.
    } catch (e) {
      emit(HomeError(e.toString())); // Emit error state on failure.
    }
  }

  // Refresh the page by reloading reports, graph data, and tips.
  void refreshPage() async {
    try {
      _reports = await reportService.loadReports(); // Reload reports.
      List<Map<String, dynamic>> hemoglobinData = await loadGraphData(_reports); // Reload graph data.
      List<String> tips = await fetchTips(_reports); // Reload tips.
      emit(HomeLoaded(reports: _reports, hemoglobinData: hemoglobinData, tips: tips)); // Emit updated state.
    } catch (e) {
      emit(HomeError(e.toString())); // Emit error state on failure.
    }
  }

  // Load hemoglobin data for the graph based on reports.
  loadGraphData(List<Report> reports) async {
    try {
      // Filter reports for the current year (2025).
      final currentYear = DateFormat('yyyy').format(DateTime.now());
      // List to store hemoglobin values for each month (Jan-Dec).
      final List<List<double>> monthlyValues = List.generate(12, (_) => <double>[]);

      // Process reports for the current year.
      for (var report in reports) {
        final reportDate = report.date.toString() ?? '';
        if (!reportDate.startsWith(currentYear)) continue; // Skip non-2025 reports.

        // Extract month from date (e.g., "2025-03-15" -> 3 for March).
        final month = int.tryParse(reportDate.split('-')[1]) ?? 0;
        if (month < 1 || month > 12) continue; // Skip invalid months.

        if (report.metrics['hemoglobin'] != null) {
          var valueStr = report.metrics['hemoglobin'].toString();
          final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
          var value = double.parse(numericMatch!.group(0)!);
          monthlyValues[month - 1].add(value); // Add value to the corresponding month.
        }
      }

      // Create graph data for each month with max value and report count.
      final List<Map<String, dynamic>> hemoglobinData = List.generate(12, (index) {
        final values = monthlyValues[index];
        final month = (index + 1).toDouble(); // 1 for Jan, 12 for Dec.
        final value = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0.0; // Use max value or 0.
        return {
          'value': value,
          'month': month,
          'count': values.length, // Number of reports for this month.
        };
      });

      return hemoglobinData; // Return graph data.
    } catch (e) {
      emit(HomeError('Failed to load graph data: $e')); // Emit error on failure.
    }
  }

  // Fetch health tips based on the last 4 reports.
  fetchTips(List<Report> reports) async {
    try {
      // Check if there are at least 4 reports.
      if (reports.length < 4) {
        emit(HomeError('Not enough reports to generate tips. Need at least 4 reports.'));
      }

      // Get the last 4 reports in reverse order.
      var reverseReports = reports.reversed.toList();
      final lastFourReports = reverseReports.sublist(reports.length - 4);

      // Separate the 4th report and the previous 3 for comparison.
      final comparisonReport = lastFourReports.last;
      final previousReports = lastFourReports.sublist(0, 3);

      // Extract metrics from previous 3 reports.
      final previousHemoglobinValues =
      previousReports.map((report) => report.metrics['hemoglobin']?.toString() ?? 'N/A').toList();
      final previousBloodPressureValues =
      previousReports.map((report) => report.metrics['blood_pressure']?.toString() ?? 'N/A').toList();
      final previousSugarValues =
      previousReports.map((report) => report.metrics['sugar']?.toString() ?? 'N/A').toList();

      // Extract metrics from the 4th report.
      final comparisonHemoglobin = comparisonReport.metrics['hemoglobin']?.toString() ?? 'N/A';
      final comparisonBloodPressure = comparisonReport.metrics['blood_pressure']?.toString() ?? 'N/A';
      final comparisonSugar = comparisonReport.metrics['sugar']?.toString() ?? 'N/A';

      // Create prompt for Gemini API to generate tips.
      final prompt = '''
Based on the following medical metrics data, provide 3 health tips in a concise list format (e.g., "- Tip 1", "- Tip 2", "- Tip 3"). Compare the most recent metrics with the previous 3 reports to identify trends and suggest improvements.

**Previous 3 Reports:**
- Hemoglobin (g/dL): ${previousHemoglobinValues.join(', ')}
- Blood Pressure (mmHg): ${previousBloodPressureValues.join(', ')}
- Sugar (mg/dL): ${previousSugarValues.join(', ')}

**Most Recent Report:**
- Hemoglobin (g/dL): $comparisonHemoglobin
- Blood Pressure (mmHg): $comparisonBloodPressure
- Sugar (mg/dL): $comparisonSugar

Provide tips to maintain or improve these metrics based on the trends observed. If any metric is "N/A", note that data is missing and provide general advice for that metric and it should not consist header and tips should be user friendly and maximum 1 line and I don't want trends and improvements just tips.
''';

      // Fetch tips using ReportService.
      final tips = await reportService.generateTips(prompt);
      return tips; // Return generated tips.
    } catch (e) {
      emit(HomeError('Error fetching tips: $e')); // Emit error on failure.
    }
  }

  // Upload a new report and refresh the page.
  Future<void> uploadReport(PlatformFile file, BuildContext context) async {
    try {
      emit(HomeLoading()); // Show loading state.
      Map<String, dynamic> reportData = await reportService.analyzeReport(file); // Analyze the report.
      var report = _addReport(reportData); // Add the report if valid.
      if (report == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"No medical metrics could be extracted"')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    refreshPage(); // Refresh the page after upload.
  }

  // Add a report to the list and save it if it has metrics.
  Report? _addReport(Map<String, dynamic> reportData) {
    var report = Report(
      id: reportData['id'] as int,
      title: reportData['title'] as String,
      summary: reportData['summary'] as String,
      suggestions: reportData['suggestions'] as String,
      date: reportData['date'] as String,
      metrics: Map<String, dynamic>.from(reportData['metrics'] as Map),
    );
    if (report.metrics.isNotEmpty) {
      _reports.add(report); // Add report to the list.
      reportService.saveReportsToPrefs(report); // Save to preferences.
      return report; // Return the added report.
    } else {
      return null; // Return null if no metrics.
    }
  }
}