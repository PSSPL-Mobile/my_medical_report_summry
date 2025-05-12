import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_medical_report_summry/constants.dart';

/// Name : GraphScreen
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Displays a line chart showing hemoglobin trends over months with a color-coded dot guide.
class GraphScreen extends StatelessWidget {
  final List<Map<String, dynamic>> hemoglobinData; // List of hemoglobin data points with month, value, and count.

  GraphScreen(this.hemoglobinData, {super.key});

  // List of month abbreviations for x-axis labels.
  final List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  // Determines the color of a dot based on the hemoglobin value.
  // Returns Colors.lightGreen for 16.0-20.0, Colors.blue for 12.0-15.9, and Colors.red for other values.
  Color getColorForValue(double value) {
    if (value >= 16.0 && value <= 20.0) {
      return Colors.lightGreen;
    } else if (value >= 12.0 && value <= 15.9) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current year for display in the "no data" message.
    final currentYear = DateFormat('yyyy').format(DateTime.now());

    // Section: Main Layout
    // Builds a column with the chart title, the line chart, and the dot color guide.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section: Chart Title
        // Displays the "Hemoglobin Trend" title with an icon.
        Container(
          color: AppConstants.sectionColor,
          padding: const EdgeInsets.only(top: 10, left: 15),
          child: Row(
            children: [
              const Icon(Icons.show_chart, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Hemoglobin Trend',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),

        // Section: No Data Message
        // Shows a message if there’s no hemoglobin data for the current year.
        if (hemoglobinData.isEmpty) Center(child: Text('No hemoglobin data available for $currentYear.')),

        // Section: Line Chart
        // Displays the hemoglobin trend as a line chart if data is available.
        if (hemoglobinData.isNotEmpty)
          Container(
            height: 280,
            color: AppConstants.sectionColor,
            padding: const EdgeInsets.fromLTRB(15, 15, 20, 10),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true), // Enable grid lines for better readability.
                titlesData: FlTitlesData(
                  // Configure left axis (y-axis) to show hemoglobin values in g/dL.
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42, // Space for y-axis labels.
                      interval: 5, // Show labels at intervals of 5 g/dL.
                      getTitlesWidget: (value, _) {
                        if (value < 5 || value > 20) return const Text(''); // Hide labels outside the 5-20 range.
                        return Text('${value.toInt()} g/dL', style: const TextStyle(fontSize: 11));
                      },
                    ),
                  ),
                  // Configure bottom axis (x-axis) to show month labels.
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt() - 1;
                        if (index < 0 || index >= monthLabels.length) return const Text(''); // Hide invalid months.
                        return Text(monthLabels[index], style: const TextStyle(fontSize: 11));
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide right axis.
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide top axis.
                ),
                borderData: FlBorderData(show: true), // Show chart borders.
                minX: 1, // Start x-axis at 1 (January).
                maxX: 12, // End x-axis at 12 (December).
                minY: 5, // Start y-axis at 5 g/dL.
                maxY: 20, // End y-axis at 20 g/dL.
                lineTouchData: LineTouchData(
                  enabled: true, // Enable touch interactions.
                  touchTooltipData: LineTouchTooltipData(
                    // Configure tooltip content to show month, hemoglobin value, and report count.
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt() - 1;
                        final month = monthLabels[index];
                        final value = spot.y;
                        final count = hemoglobinData[index]['count'] as int;
                        return LineTooltipItem(
                          '$month: ${value.toStringAsFixed(1)} g/dL\nReports: $count',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    // Map hemoglobin data to chart points (month vs. value).
                    spots: hemoglobinData.map((data) {
                      final x = data['month'] as double;
                      final y = data['value'] as double;
                      return FlSpot(x, y < 5 ? 5 : y); // Ensure y-value is at least 5.
                    }).toList(),
                    isCurved: true, // Smooth the line with curves.
                    color: AppConstants.graphLineColor, // Use custom color for the line.
                    dotData: FlDotData(
                      show: true, // Show dots at data points.
                      getDotPainter: (spot, _, __, ___) {
                        final dotColor = getColorForValue(spot.y);
                        return FlDotCirclePainter(
                          radius: 4,
                          color: dotColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false), // Disable area fill below the line.
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 15),

        // Section: Dot Color Guide
        // Displays a legend explaining the color coding of the chart dots.
        Container(
          color: AppConstants.sectionColor,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Dot Color Guide:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _colorLegendRow(Colors.lightGreen, '16.0–20.0 g/dL'),
                    const SizedBox(width: 10),
                    _colorLegendRow(Colors.blue, '12.0–15.9 g/dL'),
                    const SizedBox(width: 10),
                    _colorLegendRow(Colors.red, 'Other'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Builds a row for the dot color guide, showing a colored square and its label.
  Widget _colorLegendRow(Color color, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 5), child: Text(label)),
      ],
    );
  }
}