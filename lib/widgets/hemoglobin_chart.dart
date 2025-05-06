import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../models/report.dart';

// Widget for displaying hemoglobin chart
class HemoglobinChart extends StatelessWidget {
  final List<Report> reports;

  const HemoglobinChart({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    // Get current month and year
    final now = DateTime.now();
    final currentMonthYear = DateFormat('yyyy-MM').format(now); // e.g., "2025-05"

    // Filter reports for the current month
    final currentMonthReports = reports
        .where((report) => report.date.startsWith(currentMonthYear))
        .toList();

    // Get current month name for display
    final monthName = DateFormat('MMM').format(now); // e.g., "May"

    if (currentMonthReports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hemoglobin Levels ($monthName ${now.year})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No hemoglobin data available for this month.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Calculate average hemoglobin for the current month
    final avgHemoglobin = currentMonthReports
            .map((r) => (r.metrics['hemoglobin'] ?? 13.5) as double)
            .reduce((a, b) => a + b) /
        currentMonthReports.length;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hemoglobin Levels ($monthName ${now.year})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) =>
                          Text(value.toStringAsFixed(1)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(monthName),
                    ),
                  ),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: avgHemoglobin,
                        color: AppConstants.primaryColor,
                        width: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}