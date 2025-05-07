import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/blocs/graph/graph_cubit.dart';
import 'package:my_medical_report_summry/constants.dart';

// Screen to display a graph of hemoglobin for the current month
class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              return const Center(child: Text('No hemoglobin data available for May 2025.'));
            }

            // Determine the range for hemoglobin (typical range: 0 to 20 g/dL)
            final values = hemoglobinData.map((data) => data['value'] as double).toList();
            final minValue = values.reduce((a, b) => a < b ? a : b) - 1; // Add some padding below min
            final maxValue = values.reduce((a, b) => a > b ? a : b) + 1; // Add some padding above max

            return Padding(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hemoglobin for May 2025',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                return Text(
                                  '${value.toInt()} g/dL',
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'Day ${value.toInt()}',
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
                        maxX: 31,
                        // Days in May
                        minY: minValue < 0 ? 0 : minValue,
                        // Ensure non-negative
                        maxY: maxValue > 20 ? maxValue : 20,
                        // Cap at typical max if needed
                        lineBarsData: [
                          LineChartBarData(
                            spots: hemoglobinData.map((data) {
                              final day = data['day'] as double;
                              final value = data['value'] as double;
                              return FlSpot(day, value);
                            }).toList(),
                            isCurved: true,
                            color: Colors.red,
                            // Hemoglobin in red
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Legend
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      const Text('Hemoglobin'),
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
