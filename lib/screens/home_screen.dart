import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_medical_report_summry/blocs/home_event.dart';
import 'package:my_medical_report_summry/blocs/home_state.dart';
import 'package:my_medical_report_summry/constants.dart';
import 'package:my_medical_report_summry/screens/graph_screen.dart';
import 'package:my_medical_report_summry/screens/tips_screen.dart';

import '../blocs/home_bloc.dart';

/// Name : HomeScreen
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Main screen of the app that displays medical reports, a hemoglobin graph, and health tips.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the HomeScreenBloc instance and trigger loading of reports.
    HomeScreenBloc homeScreenBloc = context.read<HomeScreenBloc>();
    homeScreenBloc.add(const HomeLoadReports());

    // Section: Scaffold Setup
    // Builds the main scaffold with an app bar and body content.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reports'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: AppConstants.primaryColor,
        centerTitle: true,
        actions: [
          // Upload button in the app bar to allow users to upload PDF reports.
          IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.white),
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'], // Restrict to PDF files only.
              );
              if (result != null && result.files.isNotEmpty) {
                homeScreenBloc.uploadReport(result.files.first, context);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          // Section: State Handling
          // Handle different states of the HomeScreenBloc (loading, loaded, error).
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            // Section: Empty Reports
            // Display a message if no reports are available.
            if (state.reports.isEmpty) {
              return const Center(
                child: Text(
                  'No reports yet.\nUpload a report to get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            // Section: Main Content
            // Display the hemoglobin graph, tips, and list of reports.
            return Container(
              color: AppConstants.bgColor, // Background color for the entire screen.
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the hemoglobin graph if data is available.
                    if (state.hemoglobinData.isNotEmpty) GraphScreen(state.hemoglobinData),
                    if (state.hemoglobinData.isNotEmpty) const SizedBox(height: 15),

                    // Display health tips if available.
                    if (state.tips.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        color: AppConstants.sectionColor,
                        child: TipsScreen(tips: state.tips),
                      ),

                    // Section: Reports List
                    // Display the list of medical reports with a colored strip indicating hemoglobin levels.
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      color: AppConstants.sectionColor, // Background color for the reports section.
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/icon_report.svg',
                                  width: 25,
                                  height: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Your Reports',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Map each report to a card with a colored strip and metrics.
                          ...state.reports.asMap().entries.map((entry) {
                            final index = entry.key;
                            final report = entry.value;
                            final reverseIndex = state.reports.length - index; // Display reports in reverse order.
                            return Card(
                              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey.shade300, width: 0.1),
                              ),
                              color: Colors.white,
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Colored strip indicating hemoglobin level.
                                    Container(
                                      width: 4,
                                      decoration: BoxDecoration(
                                        color: _getHemoglobinColor(report.metrics['hemoglobin']),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(11),
                                          bottomLeft: Radius.circular(11),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Card content with report details.
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Report $reverseIndex',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  report.date,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            // Display metrics if available.
                                            if (report.metrics['hemoglobin'] != null)
                                              _buildMetricRow('Hemoglobin', report.metrics['hemoglobin']),
                                            if (report.metrics['blood_pressure'] != null)
                                              _buildMetricRow('Blood Pressure', report.metrics['blood_pressure']),
                                            if (report.metrics['sugar'] != null)
                                              _buildMetricRow('Sugar', report.metrics['sugar']),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 80), // Space for FAB (currently not used).
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is HomeError) {
            // Display error message if loading fails.
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text('No reports yet. Upload a report to get started.'));
        },
      ),
    );
  }

  // Builds an icon based on hemoglobin level (not used in current layout but retained for potential future use).
  Widget _buildIconByHemoglobinLevel(String valueStr) {
    final numericMatch = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
    var value = double.parse(numericMatch!.group(0)!);
    if (value >= 16.0 && value <= 20.0) {
      return const Icon(Icons.insert_drive_file, color: Colors.lightGreen);
    } else if (value >= 12.0 && value <= 15.9) {
      return const Icon(Icons.insert_drive_file, color: Colors.blue);
    } else {
      return const Icon(Icons.insert_drive_file, color: Colors.red);
    }
  }

  // Determines the color of the strip based on hemoglobin value.
  // Returns Colors.green for 16.0-20.0, Colors.blue for 12.0-15.9, and Colors.red for other values.
  Color _getHemoglobinColor(String valueStr) {
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(valueStr);
    if (match == null) return Colors.grey; // Default to grey if value is invalid.
    final value = double.parse(match.group(0)!);
    if (value >= 16.0 && value <= 20.0) return Colors.green;
    if (value >= 12.0 && value <= 15.9) return Colors.blue;
    return Colors.red;
  }

  // Builds a row for displaying a metric label and value.
  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: AppConstants.metricsColor),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: AppConstants.metricsColor),
              overflow: TextOverflow.ellipsis, // Prevent text overflow by using ellipsis.
            ),
          ),
        ],
      ),
    );
  }
}
