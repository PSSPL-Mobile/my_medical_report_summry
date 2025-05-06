import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/report.dart';

// Widget for displaying a single report item
class ReportListItem extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;

  const ReportListItem({super.key, required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: AppConstants.padding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        title: Text(
          report.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(report.date),
        onTap: onTap,
      ),
    );
  }
}