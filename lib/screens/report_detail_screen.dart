/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/report/report_bloc.dart';
import '../blocs/report/report_state.dart';
import '../constants.dart';
import '../models/report.dart';

// Screen for displaying report details
class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          String comparison = 'No previous report for comparison.';
          if (state is ReportsLoaded) {
            final previousReports = state.reports
                .where((r) =>
                    r.id != report.id &&
                    DateTime.parse(r.date).isBefore(DateTime.parse(report.date)))
                .toList();
            if (previousReports.isNotEmpty) {
              final previousReport = previousReports.last;
              final currentHb = report.metrics['hemoglobin'] ?? 13.5;
              final previousHb = previousReport.metrics['hemoglobin'] ?? 13.5;
              comparison = 'Hemoglobin: $currentHb g/dL (Previous: $previousHb g/dL, '
                  '${currentHb > previousHb ? "Higher" : currentHb < previousHb ? "Lower" : "Same"})';
            }
          }

          return Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${report.date}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(report.summary),
                  const SizedBox(height: 16),
                  const Text(
                    'Health Tips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(report.suggestions),
                  const SizedBox(height: 16),
                  const Text(
                    'Metrics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...report.metrics.entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${entry.key.replaceAll('_', ' ').toUpperCase()}: ${entry.value}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                  const SizedBox(height: 16),
                  const Text(
                    'Comparison',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(comparison),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}*/
