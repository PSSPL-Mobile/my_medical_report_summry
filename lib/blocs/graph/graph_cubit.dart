import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_medical_report_summry/models/report.dart';

part 'graph_state.dart';

// Cubit to manage graph data for hemoglobin
class GraphCubit extends Cubit<GraphState> {
  GraphCubit() : super(GraphInitial());

  void loadGraphData(List<Report> reports) async {
    emit(GraphLoading());

    try {
      // Current month filter (May 2025)
      final currentMonth = DateFormat('yyyy-MM').format(DateTime.now()); // "2025-05"

      // Prepare graph data for hemoglobin only
      final List<Map<String, dynamic>> hemoglobinData = [];

      // Process all reports for the current month
      for (var i = 0; i < reports.length; i++) {
        final report = reports[i];
        final reportDate = report.date.toString() ?? '';
        if (!reportDate.startsWith(currentMonth)) continue; // Skip reports not in May 2025
        final day = int.tryParse(reportDate.split('-').last.split('T').first) ?? (i + 1);

        if (report.metrics['hemoglobin'] != null) {
          hemoglobinData.add({
            'value': report.metrics['hemoglobin'] as double,
            'day': day.toDouble(),
          });
        }
      }

      // Sort by day for consistent plotting
      hemoglobinData.sort((a, b) => a['day'].compareTo(b['day']));
      emit(GraphLoaded(hemoglobinData));
    } catch (e) {
      emit(GraphError('Failed to load graph data: $e'));
    }
  }
}
