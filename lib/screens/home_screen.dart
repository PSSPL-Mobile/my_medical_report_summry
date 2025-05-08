import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/blocs/graph/graph_cubit.dart';
import 'package:my_medical_report_summry/blocs/report/report_bloc.dart';
import 'package:my_medical_report_summry/blocs/report/report_event.dart';
import 'package:my_medical_report_summry/blocs/report/report_state.dart';
import 'package:my_medical_report_summry/constants.dart';
import 'package:my_medical_report_summry/screens/graph_screen.dart';
import 'package:my_medical_report_summry/screens/tips_screen.dart';
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bar_chart,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              // Navigate to GraphScreen with all reports
              final state = context.read<ReportBloc>().state;
              if (state is ReportsLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => GraphCubit()..loadGraphData(state.reports),
                      child: GraphScreen(),
                    ),
                  ),
                );
              } else {
                // Show a message if reports aren't loaded
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait for reports to load.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          // Tips Icon
          IconButton(
            icon: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              // Navigate to TipsScreen with all reports
              final state = context.read<ReportBloc>().state;
              if (state is ReportsLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TipsScreen(reports: state.reports),
                  ),
                );
              } else {
                // Show a message if reports aren't loaded
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait for reports to load.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
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
                // Calculate reverse index for the report number
                final reverseIndex = state.reports.length - index;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Report $reverseIndex', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        /*const SizedBox(height: 8),
                        Text('Summary: ${report.summary}'),
                        const SizedBox(height: 8),
                        Text('Suggestions: ${report.suggestions}'),
                        const SizedBox(height: 8),*/
                        const SizedBox(height: 8),
                        Text('Date: ${report.date}'),
                        const SizedBox(height: 8),
                        if (report.metrics['hemoglobin'] != null) Text('Hemoglobin: ${report.metrics['hemoglobin']}'),
                        if (report.metrics['blood_pressure'] != null)
                          Text('Blood Pressure: ${report.metrics['blood_pressure']}'),
                        if (report.metrics['sugar'] != null) Text('Sugar: ${report.metrics['sugar']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ReportLoaded) {
            return const Center();
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
          ).then(
            (value) {
              context.read<ReportBloc>().add(const LoadReports());
            },
          );
        },
        backgroundColor: AppConstants.secondaryColor,
        child: const Icon(Icons.upload),
      ),
    );
  }
}
