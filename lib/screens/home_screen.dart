/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/services/gemini_service.dart';
import 'package:my_medical_report_summry/services/report_service.dart';

import '../blocs/report/report_bloc.dart';
import '../blocs/report/report_event.dart';
import '../blocs/report/report_state.dart';
import '../constants.dart';
import '../widgets/hemoglobin_chart.dart';
import '../widgets/report_list_item.dart';
import 'report_detail_screen.dart';
import 'upload_report_screen.dart';

// Home screen displaying reports and chart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reports'),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // Graph is displayed below
            },
          ),
        ],
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        bloc: ReportBloc(ReportService(), GeminiService())..add(LoadReports()),
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportError) {
            return Center(child: Text(state.message));
          } else if (state is ReportsLoaded) {
            return Column(
              children: [
                HemoglobinChart(reports: state.reports),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.padding),
                    itemCount: state.reports.length,
                    itemBuilder: (context, index) {
                      final report = state.reports[index];
                      return ReportListItem(
                        report: report,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportDetailScreen(report: report),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadReportScreen()),
          );
        },
        backgroundColor: AppConstants.secondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/blocs/report/report_bloc.dart';
import 'package:my_medical_report_summry/blocs/report/report_event.dart';
import 'package:my_medical_report_summry/blocs/report/report_state.dart';
import 'package:my_medical_report_summry/constants.dart';
import 'package:my_medical_report_summry/screens/upload_report_screen.dart';

// Home screen displaying reports and an upload button
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch LoadReports event when the screen is built
    context.read<ReportBloc>().add(const LoadReports());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reports'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportsLoaded) {
            if (state.reports.isEmpty) {
              return const Center(child: Text('No reports yet. Upload a report to get started.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppConstants.padding),
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final report = state.reports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Report ${index + 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Summary: ${report.summary}'),
                        const SizedBox(height: 8),
                        Text('Suggestions: ${report.suggestions}'),
                        const SizedBox(height: 8),
                        Text('Hemoglobin: ${report.metrics['hemoglobin']} g/dL'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ReportLoaded) {
            return Center();
            /*return Center(
              child: Card(
                margin: const EdgeInsets.all(AppConstants.padding),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Latest Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Summary: ${state.reportData['summary']}'),
                      const SizedBox(height: 8),
                      Text('Suggestions: ${state.reportData['suggestions']}'),
                      const SizedBox(height: 8),
                      Text('Hemoglobin: ${state.reportData['metrics']['hemoglobin']} g/dL'),
                    ],
                  ),
                ),
              ),
            );*/
          } else if (state is ReportError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No reports yet. Upload a report to get started.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadReportScreen()),
          );
        },
        backgroundColor: AppConstants.secondaryColor,
        child: const Icon(Icons.upload),
      ),
    );
  }
}
