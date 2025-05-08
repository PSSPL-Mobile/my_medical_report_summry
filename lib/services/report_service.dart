import 'package:file_picker/file_picker.dart';

import '../models/report.dart';

abstract class ReportService {
  Future<Map<String, dynamic>> analyzeReport(PlatformFile file);

  Future<List<Report>> loadReports();

  Future<List<Report>> addReport(Report newReport);

  Future<List<Report>?> loadReportsFromPrefs();

  Future<void> saveReportsToPrefs(Report report);

  Future<List<String>> generateTips(String prompt);
}
