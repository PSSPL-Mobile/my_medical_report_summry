import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/report.dart';
import '../../services/report_service.dart';
import 'tips_state.dart';

class TipsCubit extends Cubit<TipsState> {
  final ReportService reportService;

  TipsCubit(this.reportService) : super(TipsLoading());

  Future<void> fetchTips(List<Report> reports) async {

    try {
      // Ensure we have at least 4 reports
      if (reports.length < 4) {
        emit(const TipsError('Not enough reports to generate tips. Need at least 4 reports.'));
        return;
      }

      // Get the last 4 reports
      var reverseReports = reports.reversed.toList();
      final lastFourReports = reverseReports.sublist(reports.length - 4);

      // Separate the 4th report (for comparison) and the previous 3 reports
      final comparisonReport = lastFourReports.last;
      final previousReports = lastFourReports.sublist(0, 3);

      // Extract metrics from previous 3 reports
      final previousHemoglobinValues =
          previousReports.map((report) => report.metrics['hemoglobin']?.toString() ?? 'N/A').toList();
      final previousBloodPressureValues =
          previousReports.map((report) => report.metrics['blood_pressure']?.toString() ?? 'N/A').toList();
      final previousSugarValues =
          previousReports.map((report) => report.metrics['sugar']?.toString() ?? 'N/A').toList();

      // Extract metrics from the comparison report (4th report)
      final comparisonHemoglobin = comparisonReport.metrics['hemoglobin']?.toString() ?? 'N/A';
      final comparisonBloodPressure = comparisonReport.metrics['blood_pressure']?.toString() ?? 'N/A';
      final comparisonSugar = comparisonReport.metrics['sugar']?.toString() ?? 'N/A';

      // Create a prompt for Gemini API
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

Provide tips to maintain or improve these metrics based on the trends observed. If any metric is "N/A", note that data is missing and provide general advice for that metric and it should not consist header and tips should be user friendly and maximum 1 line.
''';

      // Call Gemini API via GeminiService
      final tips = await reportService.generateTips(prompt);
      emit(TipsLoaded(tips));
    } catch (e) {
      emit(TipsError('Error fetching tips: $e'));
    }
  }
}
