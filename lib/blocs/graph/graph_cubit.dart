/*
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
          var valueStr = report.metrics['hemoglobin'] as String;
          final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
          var value = double.parse(numericMatch!.group(0)!);
          hemoglobinData.add({'value': value, 'day': day.toDouble()});
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
*//*
*/
/*
*//*

*/
/*

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
      // Current year filter (2025)
      final currentYear = DateFormat('yyyy').format(DateTime.now()); // "2025"

      // Prepare graph data for hemoglobin, one entry per month (Jan to Dec)
      final List<Map<String, dynamic>> hemoglobinData = List.generate(12, (index) => {
        'value': 0.0, // Default value (will be updated if data exists)
        'month': (index + 1).toDouble(), // 1 for Jan, 2 for Feb, ..., 12 for Dec
      });

      // Process all reports for the current year
      for (var report in reports) {
        final reportDate = report.date.toString() ?? '';
        if (!reportDate.startsWith(currentYear)) continue; // Skip reports not in 2025

        // Extract the month from the report date (e.g., "2025-03-15" -> 3 for March)
        final month = int.tryParse(reportDate.split('-')[1]) ?? 0;
        if (month < 1 || month > 12) continue; // Skip invalid months

        if (report.metrics['hemoglobin'] != null) {
          var valueStr = report.metrics['hemoglobin'].toString();
          final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
          var value = double.parse(numericMatch!.group(0)!);

          // Update the hemoglobin value for the corresponding month (month - 1 for 0-based index)
          hemoglobinData[month - 1]['value'] = value;
        }
      }

      // Remove months with no data (optional, depending on your graph requirements)
      // If you want to keep all months (even those with 0 values), skip this step
      // hemoglobinData.removeWhere((data) => data['value'] == 0.0);

      emit(GraphLoaded(hemoglobinData));
    } catch (e) {
      emit(GraphError('Failed to load graph data: $e'));
    }
  }
}
*//*
*/
/*

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
      // Current year filter (2025)
      final currentYear = DateFormat('yyyy').format(DateTime.now()); // "2025"

      // Temporary structure to collect all hemoglobin values for each month
      final List<List<double>> monthlyValues = List.generate(12, (_) => <double>[]);

      // Process all reports for the current year
      for (var report in reports) {
        final reportDate = report.date.toString() ?? '';
        if (!reportDate.startsWith(currentYear)) continue; // Skip reports not in 2025

        // Extract the month from the report date (e.g., "2025-03-15" -> 3 for March)
        final month = int.tryParse(reportDate.split('-')[1]) ?? 0;
        if (month < 1 || month > 12) continue; // Skip invalid months

        if (report.metrics['hemoglobin'] != null) {
          var valueStr = report.metrics['hemoglobin'].toString();
          final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
          var value = double.parse(numericMatch!.group(0)!);

          // Add the hemoglobin value to the corresponding month's list
          monthlyValues[month - 1].add(value);
        }
      }

      // Prepare graph data for hemoglobin, one entry per month (Jan to Dec)
      final List<Map<String, dynamic>> hemoglobinData = List.generate(12, (index) {
        final values = monthlyValues[index];
        final month = (index + 1).toDouble(); // 1 for Jan, 2 for Feb, ..., 12 for Dec
        // Compute the average if there are values, otherwise use 0.0
        final value = values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : 0.0;
        return {
          'value': value,
          'month': month,
        };
      });

      // Remove months with no data (optional, depending on your graph requirements)
      // If you want to keep all months (even those with 0 values), skip this step
      // hemoglobinData.removeWhere((data) => data['value'] == 0.0);

      emit(GraphLoaded(hemoglobinData));
    } catch (e) {
      emit(GraphError('Failed to load graph data: $e'));
    }
  }
}
*//*

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
      // Current year filter (2025)
      final currentYear = DateFormat('yyyy').format(DateTime.now()); // "2025"

      // Temporary structure to collect all hemoglobin values for each month
      final List<List<double>> monthlyValues = List.generate(12, (_) => <double>[]);

      // Process all reports for the current year
      for (var report in reports) {
        final reportDate = report.date.toString() ?? '';
        if (!reportDate.startsWith(currentYear)) continue; // Skip reports not in 2025

        // Extract the month from the report date (e.g., "2025-03-15" -> 3 for March)
        final month = int.tryParse(reportDate.split('-')[1]) ?? 0;
        if (month < 1 || month > 12) continue; // Skip invalid months

        if (report.metrics['hemoglobin'] != null) {
          var valueStr = report.metrics['hemoglobin'].toString();
          final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
          var value = double.parse(numericMatch!.group(0)!);

          // Add the hemoglobin value to the corresponding month's list
          monthlyValues[month - 1].add(value);
        }
      }

      // Prepare graph data for hemoglobin, one entry per month (Jan to Dec)
      final List<Map<String, dynamic>> hemoglobinData = List.generate(12, (index) {
        final values = monthlyValues[index];
        final month = (index + 1).toDouble(); // 1 for Jan, 2 for Feb, ..., 12 for Dec
        // Compute the average if there are values, otherwise use 0.0
        final value = values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : 0.0;
        return {
          'value': value,
          'month': month,
          'count': values.length, // Number of reports for this month
        };
      });

      // Remove months with no data (optional, depending on your graph requirements)
      // If you want to keep all months (even those with 0 values), skip this step
      // hemoglobinData.removeWhere((data) => data['value'] == 0.0);

      emit(GraphLoaded(hemoglobinData));
    } catch (e) {
      emit(GraphError('Failed to load graph data: $e'));
    }
  }
}
*/
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
      // Current year filter (2025)
      final currentYear = DateFormat('yyyy').format(DateTime.now()); // "2025"

      // Temporary structure to collect all hemoglobin values for each month
      final List<List<double>> monthlyValues = List.generate(12, (_) => <double>[]);

      // Process all reports for the current year
      for (var report in reports) {
        final reportDate = report.date.toString() ?? '';
        if (!reportDate.startsWith(currentYear)) continue; // Skip reports not in 2025

        // Extract the month from the report date (e.g., "2025-03-15" -> 3 for March)
        final month = int.tryParse(reportDate.split('-')[1]) ?? 0;
        if (month < 1 || month > 12) continue; // Skip invalid months

        if (report.metrics['hemoglobin'] != null) {
          var valueStr = report.metrics['hemoglobin'].toString();
          final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
          var value = double.parse(numericMatch!.group(0)!);

          // Add the hemoglobin value to the corresponding month's list
          monthlyValues[month - 1].add(value);
        }
      }

      // Prepare graph data for hemoglobin, one entry per month (Jan to Dec)
      final List<Map<String, dynamic>> hemoglobinData = List.generate(12, (index) {
        final values = monthlyValues[index];
        final month = (index + 1).toDouble(); // 1 for Jan, 2 for Feb, ..., 12 for Dec
        // Use the maximum value if there are values, otherwise use 0.0
        final value = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0.0;
        return {
          'value': value,
          'month': month,
          'count': values.length, // Number of reports for this month
        };
      });

      emit(GraphLoaded(hemoglobinData));
    } catch (e) {
      emit(GraphError('Failed to load graph data: $e'));
    }
  }
}