import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_medical_report_summry/blocs/graph/graph_cubit.dart';
import 'package:my_medical_report_summry/constants.dart';

// Screen to display a graph of hemoglobin for the current year
class GraphScreen extends StatelessWidget {
  GraphScreen({super.key});

  // List of month abbreviations for x-axis labels
  final List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  // Helper function to determine the color based on hemoglobin value
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
    // Get the current year dynamically (same as in GraphCubit)
    final currentYear = DateFormat('yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hemoglobin Graph'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: BlocBuilder<GraphCubit, GraphState>(
        builder: (context, state) {
          if (state is GraphLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GraphLoaded) {
            final hemoglobinData = state.hemoglobinData;

            if (hemoglobinData.isEmpty) {
              return Center(child: Text('No hemoglobin data available for $currentYear.'));
            }

            // Determine the color based on the highest hemoglobin value (excluding zeros)
            final nonZeroValues =
                hemoglobinData.map((data) => data['value'] as double).where((value) => value > 0).toList();
            final highestValue = nonZeroValues.isNotEmpty ? nonZeroValues.reduce((a, b) => a > b ? a : b) : 0.0;
            final lineColor = getColorForValue(highestValue);

            return Padding(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hemoglobin $currentYear',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                // Only show labels within the range 5 to 20
                                if (value < 5 || value > 20) return const Text('');
                                return Text(
                                  '${value.toInt()} g/dL',
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                              interval: 5, // Show labels at intervals of 5 (5, 10, 15, 20)
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final monthIndex = value.toInt() - 1; // 0-based index for monthLabels
                                if (monthIndex < 0 || monthIndex >= monthLabels.length) {
                                  return const Text('');
                                }
                                return Text(
                                  monthLabels[monthIndex],
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        minX: 1,
                        maxX: 12,
                        // Months in a year (Jan to Dec)
                        minY: 5,
                        // Fixed minimum Y value
                        maxY: 20,
                        // Fixed maximum Y value
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                final monthIndex = spot.x.toInt() - 1;
                                final month = monthLabels[monthIndex];
                                final value = spot.y;
                                final count = hemoglobinData[monthIndex]['count'] as int;
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
                            spots: hemoglobinData.map((data) {
                              final month = data['month'] as double;
                              final value = data['value'] as double;
                              return FlSpot(month, value < 5 ? 5 : value); // Clamp values below 5 to 5 for visibility
                            }).toList(),
                            isCurved: true,
                            color: Colors.red,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                // Color the dot based on its hemoglobin value (spot.y)
                                final dotColor = getColorForValue(spot.y);
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: dotColor,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Legend
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dot Color Guide:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.lightGreen,
                          ),
                          const SizedBox(width: 8),
                          const Text('16.0–20.0 g/dL'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          const Text('12.0–15.9 g/dL'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text('Other'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is GraphError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No graph data available.'));
        },
      ),
    );
  }
}
